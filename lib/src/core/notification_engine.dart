import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../actions/action_registry.dart';
import '../channels/channel_registry.dart';
import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/events.dart';
import '../models/notification_message.dart';
import '../navigation/notification_navigator.dart';
import '../parser/notification_parser.dart';
import '../platform/background_dispatcher.dart';
import '../platform/firebase_messaging_gateway.dart';
import '../platform/local_notifications_gateway.dart';
import '../platform/platform_gateways.dart';
import '../services/action_queue.dart';
import '../services/event_bus.dart';
import '../services/replay_guard.dart';
import '../utils/platform_utils.dart';
import 'contracts.dart';
import 'exceptions.dart';
import 'fcm_actions_config.dart';

final class NotificationEngine with WidgetsBindingObserver {
  NotificationEngine({
    required this.config,
    ActionRegistry? actionRegistry,
    ChannelRegistry? channelRegistry,
    MessagingGateway? messaging,
    LocalNotificationsGateway? localNotifications,
    FcmActionsEventBus? eventBus,
    ReplayGuard? replayGuard,
    ActionQueue? actionQueue,
  }) : actions = actionRegistry ?? ActionRegistry(),
       channels = channelRegistry ?? ChannelRegistry(),
       messaging = messaging ?? FirebaseMessagingGateway(),
       localNotifications =
           localNotifications ?? FlutterLocalNotificationsGateway(),
       events = eventBus ?? FcmActionsEventBus(),
       _replayGuard =
           replayGuard ?? ReplayGuard(window: config.replayProtectionWindow),
       _actionQueue =
           actionQueue ?? ActionQueue(maxRetries: config.maxActionRetries),
       navigator = NotificationNavigator(
         navigatorKey: config.navigatorKey,
         routes: config.routes,
       ) {
    actions.registerAll(config.actions);
    channels.registerAll(config.channels);
    parser = NotificationParser(
      maxPayloadBytes: config.maxPayloadBytes,
      defaultChannelId: config.defaultChannelId,
      resolveAction: actions.find,
    );
  }

  final FcmActionsConfig config;
  final ActionRegistry actions;
  final ChannelRegistry channels;
  final MessagingGateway messaging;
  final LocalNotificationsGateway localNotifications;
  final FcmActionsEventBus events;
  final ReplayGuard _replayGuard;
  final ActionQueue _actionQueue;
  final NotificationNavigator navigator;
  late final NotificationParser parser;
  final List<StreamSubscription<Object?>> _subscriptions =
      <StreamSubscription<Object?>>[];
  bool _initialized = false;
  bool _disposed = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_disposed) {
      throw const FcmActionsInitializationException(
        'A disposed FcmActionsClient cannot be initialized.',
      );
    }
    if (_initialized) return;
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await _initializeFirebase();
      await BackgroundDispatcher.configure(config);
      messaging.registerBackgroundHandler();

      final templates = <NotificationMessage>[
        if (config.actions.isNotEmpty)
          parser.parseMap(<String, Object?>{
            'message_id': 'fcm_actions_registered_actions',
            'actions': config.actions.map((action) => action.toJson()).toList(),
          }),
      ];
      final localLaunch = await localNotifications.initialize(
        defaultAndroidIcon: config.defaultAndroidIcon,
        requestPermission: config.requestPermission,
        categoryTemplates: templates,
        onResponse: _handleLocalResponse,
      );
      await localNotifications.createChannels(channels.channels.values);
      if (config.requestPermission) await messaging.requestPermission();
      await messaging.configureForegroundPresentation();

      _subscriptions
        ..add(
          messaging.foregroundMessages.listen(
            (message) => unawaited(_handleForeground(message)),
            onError: _streamError,
          ),
        )
        ..add(
          messaging.openedMessages.listen(
            (message) =>
                unawaited(_handleOpened(message, NotificationState.resumed)),
            onError: _streamError,
          ),
        );
      WidgetsBinding.instance.addObserver(this);
      _initialized = true;

      await _publishPendingBackgroundEvents();
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        await _handleOpened(initialMessage, NotificationState.terminated);
      }
      if (localLaunch != null) await _handleLocalResponse(localLaunch);
      await retryPendingActions();
    } on FcmActionsException {
      rethrow;
    } on Object catch (error, stackTrace) {
      config.logger.log(
        FcmLogLevel.error,
        'Initialization failed.',
        error: error,
        stackTrace: stackTrace,
      );
      throw FcmActionsInitializationException(
        'Could not initialize notification services.',
        cause: error,
      );
    }
  }

  Future<void> _initializeFirebase() async {
    if (!config.initializeFirebase) return;
    if (config.firebaseAppName == null) {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: config.firebaseOptions);
      }
      return;
    }
    final exists = Firebase.apps.any(
      (app) => app.name == config.firebaseAppName,
    );
    if (!exists) {
      await Firebase.initializeApp(
        name: config.firebaseAppName,
        options: config.firebaseOptions,
      );
    }
  }

  Future<void> _handleForeground(RemoteMessage remote) async {
    await _guard('foreground message', () async {
      final message = parser.parseRemoteMessage(remote);
      final event = _notificationEvent(message, NotificationState.foreground);
      await _publishNotification(event);
      events.foreground(event);
      if (!message.silent &&
          (remote.notification != null || config.autoDisplayDataMessages)) {
        await show(message);
      }
    });
  }

  Future<void> _handleOpened(
    RemoteMessage remote,
    NotificationState state,
  ) async {
    await _guard('opened message', () async {
      final message = parser.parseRemoteMessage(remote);
      if (!await _replayGuard.claim(
        'open:${message.messageId}',
        DateTime.now().toUtc(),
      )) {
        return;
      }
      final event = _notificationEvent(
        message,
        state,
        interaction: state == NotificationState.terminated
            ? NotificationInteraction.launch
            : NotificationInteraction.bodyTap,
      );
      await _publishNotification(event);
      events.opened(event);
      if (config.autoNavigate) await navigator.navigateMessage(message);
    });
  }

  Future<void> _handleLocalResponse(
    PlatformNotificationResponse response,
  ) async {
    await _guard('notification response', () async {
      if (response.payload == null) return;
      final decoded = jsonDecode(response.payload!);
      if (decoded is! Map) {
        throw const InvalidNotificationPayloadException(
          'Notification response payload is not a JSON object.',
        );
      }
      final message = NotificationMessage.fromJson(
        decoded.map((key, value) => MapEntry(key.toString(), value)),
      );
      final state = response.launchedApp
          ? NotificationState.terminated
          : response.fromBackground
          ? NotificationState.background
          : NotificationState.foreground;

      if (response.dismissed) {
        final event = _notificationEvent(
          message,
          state,
          interaction: NotificationInteraction.dismiss,
        );
        events.dismissal(event);
        await _forEachAnalytics(
          (analytics) => analytics.notificationDismissed(event),
        );
        return;
      }

      final actionId = response.actionId;
      if (actionId == null || actionId.isEmpty) {
        final event = _notificationEvent(
          message,
          state,
          interaction: response.launchedApp
              ? NotificationInteraction.launch
              : NotificationInteraction.bodyTap,
        );
        await _publishNotification(event);
        events.opened(event);
        if (config.autoNavigate) await navigator.navigateMessage(message);
        return;
      }

      final actionEvent = NotificationActionEvent(
        actionId: actionId,
        notificationId: response.notificationId ?? message.notificationId,
        timestamp: DateTime.now().toUtc(),
        message: message,
        platform: currentNotificationPlatform,
        state: state,
        payload: message.data,
        rawJson: message.rawJson,
        replyText: response.input,
        fromBackground: response.fromBackground,
      );
      await executeAction(actionEvent);
    });
  }

  Future<void> show(NotificationMessage message) async {
    await _guard('display notification', () async {
      var current = message;
      for (final interceptor in config.interceptors) {
        final intercepted = await interceptor.beforeDisplay(current);
        if (intercepted == null) return;
        current = intercepted;
      }
      final channel =
          channels.find(current.channelId) ??
          channels.find(config.defaultChannelId) ??
          NotificationChannel.defaultChannel;
      await localNotifications.show(current, channel);
      for (final interceptor in config.interceptors.reversed) {
        await interceptor.afterDisplay(current);
      }
      final event = _notificationEvent(current, NotificationState.foreground);
      await _forEachAnalytics(
        (analytics) => analytics.notificationDisplayed(event),
      );
    });
  }

  Future<void> executeAction(
    NotificationActionEvent event, {
    bool skipReplayCheck = false,
    bool queueOnFailure = true,
  }) async {
    if (!skipReplayCheck &&
        !await _replayGuard.claim(
          'action:${event.notificationId}:${event.actionId}:'
          '${event.message.messageId}',
          event.timestamp,
        )) {
      config.logger.log(
        FcmLogLevel.warning,
        'Ignored duplicate action "${event.actionId}".',
      );
      return;
    }

    try {
      var current = event;
      for (final interceptor in config.actionInterceptors) {
        final intercepted = await interceptor.beforeAction(current);
        if (intercepted == null) return;
        current = intercepted;
      }
      await _runMiddleware(current, 0);
      for (final interceptor in config.actionInterceptors.reversed) {
        await interceptor.afterAction(current);
      }
      events.action(current);
      if (current.replyText != null) events.reply(current);
      await _forEachAnalytics((analytics) => analytics.actionExecuted(current));
    } on Object catch (error, stackTrace) {
      config.logger.log(
        FcmLogLevel.error,
        'Action "${event.actionId}" failed.',
        error: error,
        stackTrace: stackTrace,
      );
      if (queueOnFailure && config.queueFailedActions) {
        await _actionQueue.enqueue(event);
      }
    }
  }

  Future<void> _runMiddleware(NotificationActionEvent event, int index) async {
    if (index < config.middleware.length) {
      await config.middleware[index].handle(
        event,
        (nextEvent) => _runMiddleware(nextEvent, index + 1),
      );
      return;
    }
    final handler = actions.handlerFor(event.actionId);
    if (handler != null) await handler(event);
    await config.onAction?.call(event, event.payload);
  }

  Future<void> retryPendingActions() => _actionQueue.drain(
    (event) =>
        executeAction(event, skipReplayCheck: true, queueOnFailure: false),
  );

  Future<void> _publishPendingBackgroundEvents() async {
    final pending = await BackgroundDispatcher.takePendingNotifications();
    for (final event in pending) {
      await _publishNotification(event);
      events.background(event);
    }
    final actions = await BackgroundDispatcher.takePendingActions();
    for (final event in actions) {
      await executeAction(event, skipReplayCheck: true);
    }
  }

  Future<void> _publishNotification(NotificationEvent event) async {
    events.notification(event);
    await config.onNotification?.call(event);
    await _forEachAnalytics(
      (analytics) => analytics.notificationReceived(event),
    );
  }

  NotificationEvent _notificationEvent(
    NotificationMessage message,
    NotificationState state, {
    NotificationInteraction? interaction,
  }) => NotificationEvent(
    message: message,
    timestamp: DateTime.now().toUtc(),
    platform: currentNotificationPlatform,
    state: state,
    interaction: interaction,
    rawJson: message.rawJson,
  );

  Future<void> _forEachAnalytics(
    Future<void> Function(NotificationAnalytics analytics) callback,
  ) async {
    for (final analytics in config.analytics) {
      try {
        await callback(analytics);
      } on Object catch (error, stackTrace) {
        config.logger.log(
          FcmLogLevel.warning,
          'Analytics adapter failed.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _guard(
    String operation,
    Future<void> Function() callback,
  ) async {
    try {
      await callback();
    } on Object catch (error, stackTrace) {
      config.logger.log(
        FcmLogLevel.error,
        'Failed to process $operation.',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _streamError(Object error, StackTrace stackTrace) {
    config.logger.log(
      FcmLogLevel.error,
      'A messaging stream failed.',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(retryPendingActions());
      unawaited(_publishPendingBackgroundEvents());
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    WidgetsBinding.instance.removeObserver(this);
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await events.dispose();
    _disposed = true;
    _initialized = false;
  }
}
