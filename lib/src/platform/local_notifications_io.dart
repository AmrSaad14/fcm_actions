import 'dart:convert';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../actions/action_registry.dart';
import '../core/contracts.dart';
import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/events.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import '../parser/notification_parser.dart';
import '../services/replay_guard.dart';
import '../utils/platform_utils.dart';
import 'background_dispatcher.dart';
import 'platform_gateways.dart';

final class FlutterLocalNotificationsGateway
    implements LocalNotificationsGateway {
  FlutterLocalNotificationsGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final Map<String, DarwinNotificationCategory> _categories =
      <String, DarwinNotificationCategory>{};
  String _icon = '@mipmap/ic_launcher';
  PlatformNotificationResponseCallback? _onResponse;

  @override
  Future<PlatformNotificationResponse?> initialize({
    required String defaultAndroidIcon,
    required bool requestPermission,
    required List<NotificationMessage> categoryTemplates,
    required PlatformNotificationResponseCallback onResponse,
  }) async {
    _icon = defaultAndroidIcon;
    _onResponse = onResponse;
    _addCategories(categoryTemplates);
    await _initializePlugin(requestPermission: requestPermission);

    if (requestPermission) {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if (launch?.didNotificationLaunchApp != true || response == null) {
      return null;
    }
    return _convert(response, launchedApp: true);
  }

  Future<void> _initializePlugin({required bool requestPermission}) {
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: requestPermission,
      requestBadgePermission: requestPermission,
      requestSoundPermission: requestPermission,
      notificationCategories: _categories.values.toList(),
    );
    return _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings(_icon),
        iOS: darwin,
        macOS: darwin,
        web: const WebInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) async {
        await _onResponse?.call(_convert(response));
      },
      onDidReceiveBackgroundNotificationResponse:
          fcmActionsBackgroundNotificationResponse,
    );
  }

  @override
  Future<void> createChannels(Iterable<NotificationChannel> channels) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    for (final channel in channels) {
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          channel.id,
          channel.name,
          description: channel.description,
          importance: _importance(channel.importance),
          playSound: channel.playSound,
          sound: channel.sound == null
              ? null
              : RawResourceAndroidNotificationSound(channel.sound),
          enableVibration: channel.enableVibration,
          showBadge: channel.showBadge,
        ),
      );
    }
  }

  @override
  Future<void> registerCategories(
    Iterable<NotificationMessage> templates,
  ) async {
    final before = _categories.length;
    _addCategories(templates);
    if (_categories.length != before) {
      await _initializePlugin(requestPermission: false);
    }
  }

  void _addCategories(Iterable<NotificationMessage> templates) {
    for (final template in templates) {
      final id = template.categoryId;
      if (id == null || template.actions.isEmpty) continue;
      _categories[id] = DarwinNotificationCategory(
        id,
        actions: template.actions.map(_darwinAction).toList(),
        options: const <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.customDismissAction,
        },
      );
    }
  }

  @override
  Future<void> show(
    NotificationMessage message,
    NotificationChannel channel,
  ) async {
    await registerCategories(<NotificationMessage>[message]);
    final androidActions = message.actions.map(_androidAction).toList();
    final darwin = DarwinNotificationDetails(
      categoryIdentifier: message.categoryId,
      presentAlert: !message.silent,
      presentBanner: !message.silent,
      presentList: !message.silent,
      presentSound: channel.playSound && !message.silent,
      sound: channel.sound,
      presentBadge: channel.showBadge,
    );
    await _plugin.show(
      id: message.notificationId,
      title: message.title,
      body: message.body,
      payload: jsonEncode(message.toJson()),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: _importance(channel.importance),
          priority: _priority(channel.importance),
          playSound: channel.playSound,
          sound: channel.sound == null
              ? null
              : RawResourceAndroidNotificationSound(channel.sound),
          enableVibration: channel.enableVibration,
          channelShowBadge: channel.showBadge,
          silent: channel.importance == ChannelImportance.silent,
          styleInformation: message.body == null
              ? null
              : BigTextStyleInformation(message.body!),
          actions: androidActions,
          dismissIsolate: NotificationDismissedIsolate.main,
        ),
        iOS: darwin,
        macOS: darwin,
        web: WebNotificationDetails(
          isSilent: message.silent,
          imageUrl: message.imageUrl == null
              ? null
              : Uri.tryParse(message.imageUrl!),
          actions: message.actions
              .map(
                (action) => WebNotificationAction(
                  action: action.id,
                  title: action.title,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Future<void> cancel(int id) => _plugin.cancel(id: id);

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  static AndroidNotificationAction _androidAction(NotificationAction action) =>
      AndroidNotificationAction(
        action.id,
        action.title,
        icon: action.icon == null
            ? null
            : DrawableResourceAndroidBitmap(action.icon!),
        showsUserInterface:
            action.executionMode == ActionExecutionMode.foreground ||
            (action.executionMode == ActionExecutionMode.any &&
                action.showsUserInterface),
        allowGeneratedReplies: action.input,
        inputs: action.input
            ? <AndroidNotificationActionInput>[
                AndroidNotificationActionInput(label: action.inputLabel),
              ]
            : const <AndroidNotificationActionInput>[],
      );

  static DarwinNotificationAction _darwinAction(NotificationAction action) {
    final options = <DarwinNotificationActionOption>{
      if (action.destructive) DarwinNotificationActionOption.destructive,
      DarwinNotificationActionOption.foreground,
    };
    if (action.input) {
      return DarwinNotificationAction.text(
        action.id,
        action.title,
        buttonTitle: action.title,
        placeholder: action.inputLabel,
        options: options,
      );
    }
    return DarwinNotificationAction.plain(
      action.id,
      action.title,
      options: options,
    );
  }

  static PlatformNotificationResponse _convert(
    NotificationResponse response, {
    bool launchedApp = false,
  }) => PlatformNotificationResponse(
    notificationId: response.id,
    payload: response.payload,
    actionId: response.actionId,
    input: response.input,
    dismissed:
        response.notificationResponseType ==
        NotificationResponseType.notificationDismissed,
    launchedApp: launchedApp,
    fromBackground: false,
  );

  static Importance _importance(ChannelImportance importance) =>
      switch (importance) {
        ChannelImportance.max => Importance.max,
        ChannelImportance.high => Importance.high,
        ChannelImportance.defaultImportance => Importance.defaultImportance,
        ChannelImportance.low => Importance.low,
        ChannelImportance.silent => Importance.none,
      };

  static Priority _priority(ChannelImportance importance) =>
      switch (importance) {
        ChannelImportance.max => Priority.max,
        ChannelImportance.high => Priority.high,
        ChannelImportance.defaultImportance => Priority.defaultPriority,
        ChannelImportance.low => Priority.low,
        ChannelImportance.silent => Priority.min,
      };
}

@pragma('vm:entry-point')
Future<void> fcmActionsBackgroundMessageHandler(RemoteMessage remote) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    final config = await BackgroundDispatcher.readConfiguration();
    if (config == null) return;
    if (Firebase.apps.isEmpty) {
      final optionsValue = config['firebaseOptions'];
      await Firebase.initializeApp(
        name: config['firebaseAppName'] as String?,
        options: optionsValue is Map<Object?, Object?>
            ? BackgroundDispatcher.firebaseOptionsFromJson(
                optionsValue.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
              )
            : null,
      );
    }

    final registry = ActionRegistry();
    final actionValues = config['actions'];
    if (actionValues is List) {
      registry.registerAll(
        actionValues.whereType<Map<Object?, Object?>>().map(
          (value) => NotificationAction.fromJson(
            value.map((key, item) => MapEntry(key.toString(), item)),
          ),
        ),
      );
    }
    final parser = NotificationParser(
      maxPayloadBytes: config['maxPayloadBytes'] as int? ?? 32768,
      defaultChannelId:
          config['defaultChannelId'] as String? ?? 'fcm_actions_default',
      resolveAction: registry.find,
    );
    final message = parser.parseRemoteMessage(remote);
    final event = NotificationEvent(
      message: message,
      timestamp: DateTime.now().toUtc(),
      platform: currentNotificationPlatform,
      state: NotificationState.background,
      rawJson: message.rawJson,
    );
    await BackgroundDispatcher.appendPendingNotification(event);

    if (remote.notification == null && !message.silent) {
      final channels = (config['channels'] as List? ?? const <Object?>[])
          .whereType<Map<Object?, Object?>>()
          .map(
            (value) => NotificationChannel.fromJson(
              value.map((key, item) => MapEntry(key.toString(), item)),
            ),
          )
          .toList();
      NotificationChannel? channel;
      for (final item in channels) {
        if (item.id == message.channelId) {
          channel = item;
          break;
        }
      }
      final fallback = channel ?? NotificationChannel.defaultChannel;
      final local = FlutterLocalNotificationsGateway();
      await local.initialize(
        defaultAndroidIcon: config['icon'] as String? ?? '@mipmap/ic_launcher',
        requestPermission: false,
        categoryTemplates: <NotificationMessage>[message],
        onResponse: (_) async {},
      );
      await local.createChannels(<NotificationChannel>[fallback]);
      await local.show(message, fallback);
    }
  } on Object {
    // Background callbacks must never terminate the host application.
  }
}

@pragma('vm:entry-point')
void fcmActionsBackgroundNotificationResponse(
  NotificationResponse response,
) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    if (response.payload == null) return;
    final message = NotificationMessage.fromJson(
      Map<String, Object?>.from(jsonDecode(response.payload!) as Map),
    );
    final event = NotificationActionEvent(
      actionId: response.actionId ?? 'default',
      notificationId: response.id ?? message.notificationId,
      timestamp: DateTime.now().toUtc(),
      message: message,
      platform: currentNotificationPlatform,
      state: NotificationState.background,
      payload: message.data,
      rawJson: message.rawJson,
      replyText: response.input,
      fromBackground: true,
    );
    final config = await BackgroundDispatcher.readConfiguration();
    if (config == null) return;
    final claimed =
        await ReplayGuard(
          window: Duration(
            milliseconds:
                config['replayWindowMs'] as int? ??
                const Duration(days: 7).inMilliseconds,
          ),
        ).claim(
          'action:${event.notificationId}:${event.actionId}:'
          '${event.message.messageId}',
          event.timestamp,
        );
    if (!claimed) return;
    final rawHandle = config['callbackHandle'];
    if (rawHandle is int) {
      final callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(rawHandle),
      );
      if (callback is NotificationActionCallback) {
        try {
          await callback(event);
          return;
        } on Object {
          await BackgroundDispatcher.appendPendingAction(event);
        }
      } else {
        await BackgroundDispatcher.appendPendingAction(event);
      }
    } else {
      await BackgroundDispatcher.appendPendingAction(event);
    }
    await BackgroundDispatcher.appendPendingNotification(
      NotificationEvent(
        message: message,
        timestamp: event.timestamp,
        platform: event.platform,
        state: event.state,
        interaction: response.input == null
            ? NotificationInteraction.actionTap
            : NotificationInteraction.reply,
        rawJson: event.rawJson,
      ),
    );
  } on Object {
    // The platform owns this isolate; never allow user callbacks to crash it.
  }
}
