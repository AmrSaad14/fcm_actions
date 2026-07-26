import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../handlers/notification_action_handler.dart';
import '../models/configuration_models.dart';
import '../models/events.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import 'contracts.dart';
import 'fcm_actions_client.dart';
import 'fcm_actions_config.dart';

/// One-call facade for the common single-Firebase-app use case.
///
/// The facade owns one default [FcmActionsClient]. Construct a client directly
/// when dependency injection, multiple Firebase apps, or isolated tests are
/// required.
abstract final class FcmActions {
  static FcmActionsClient? _client;
  static Future<void>? _initializing;

  static FcmActionsClient get client {
    final value = _client;
    if (value == null) {
      throw StateError('Call FcmActions.initialize() before using the API.');
    }
    return value;
  }

  static bool get isInitialized => _client?.isInitialized ?? false;

  static Stream<NotificationEvent> get onNotification => client.onNotification;
  static Stream<NotificationActionEvent> get onAction => client.onAction;
  static Stream<NotificationEvent> get onDismiss => client.onDismiss;
  static Stream<NotificationActionEvent> get onReply => client.onReply;
  static Stream<NotificationEvent> get onForegroundMessage =>
      client.onForegroundMessage;
  static Stream<NotificationEvent> get onBackgroundMessage =>
      client.onBackgroundMessage;
  static Stream<NotificationEvent> get onOpenedApp => client.onOpenedApp;

  static Future<void> initialize({
    GlobalKey<NavigatorState>? navigatorKey,
    FirebaseOptions? firebaseOptions,
    String? firebaseAppName,
    bool initializeFirebase = true,
    bool requestPermission = true,
    bool autoDisplayDataMessages = true,
    bool autoNavigate = true,
    String defaultAndroidIcon = '@mipmap/ic_launcher',
    String defaultChannelId = 'fcm_actions_default',
    List<NotificationAction> actions = const <NotificationAction>[],
    List<NotificationChannel> channels = const <NotificationChannel>[
      NotificationChannel.max,
      NotificationChannel.high,
      NotificationChannel.defaultChannel,
      NotificationChannel.low,
      NotificationChannel.silent,
    ],
    List<RouteMapper> routes = const <RouteMapper>[],
    FcmActionsInitializeCallback? onAction,
    NotificationEventCallback? onNotification,
    NotificationActionCallback? backgroundActionHandler,
    List<NotificationInterceptor> interceptors =
        const <NotificationInterceptor>[],
    List<ActionInterceptor> actionInterceptors = const <ActionInterceptor>[],
    List<NotificationMiddleware> middleware = const <NotificationMiddleware>[],
    List<NotificationAnalytics> analytics = const <NotificationAnalytics>[],
    FcmActionsLogger logger = const DebugFcmActionsLogger(),
    Duration replayProtectionWindow = const Duration(days: 7),
    int maxPayloadBytes = 32768,
    bool queueFailedActions = true,
    int maxActionRetries = 3,
  }) => initializeWithConfig(
    FcmActionsConfig(
      navigatorKey: navigatorKey,
      firebaseOptions: firebaseOptions,
      firebaseAppName: firebaseAppName,
      initializeFirebase: initializeFirebase,
      requestPermission: requestPermission,
      autoDisplayDataMessages: autoDisplayDataMessages,
      autoNavigate: autoNavigate,
      defaultAndroidIcon: defaultAndroidIcon,
      defaultChannelId: defaultChannelId,
      actions: actions,
      channels: channels,
      routes: routes,
      onAction: onAction,
      onNotification: onNotification,
      backgroundActionHandler: backgroundActionHandler,
      interceptors: interceptors,
      actionInterceptors: actionInterceptors,
      middleware: middleware,
      analytics: analytics,
      logger: logger,
      replayProtectionWindow: replayProtectionWindow,
      maxPayloadBytes: maxPayloadBytes,
      queueFailedActions: queueFailedActions,
      maxActionRetries: maxActionRetries,
    ),
  );

  static Future<void> initializeWithConfig(FcmActionsConfig config) {
    if (_client?.isInitialized ?? false) return Future<void>.value();
    final inProgress = _initializing;
    if (inProgress != null) return inProgress;
    final value = FcmActionsClient(config);
    _client = value;
    final future = value.initialize();
    _initializing = future;
    return future.whenComplete(() {
      _initializing = null;
      if (!value.isInitialized) _client = null;
    });
  }

  static void registerAction(
    NotificationAction action, {
    NotificationActionCallback? handler,
  }) => client.registerAction(action, handler: handler);

  static void registerActions(Iterable<NotificationAction> actions) =>
      client.registerActions(actions);

  static void registerActionHandler(
    String actionId,
    NotificationActionCallback handler,
  ) => client.registerActionHandler(actionId, handler);

  static void registerHandler(NotificationActionHandler handler) =>
      client.registerHandler(handler);

  static Future<void> registerChannel(NotificationChannel channel) =>
      client.registerChannel(channel);

  static void registerRoute(RouteMapper route) => client.registerRoute(route);

  static NotificationMessage parse(Map<String, Object?> payload) =>
      client.parse(payload);

  static Future<void> show({
    int? notificationId,
    String? messageId,
    String? title,
    String? body,
    String? imageUrl,
    Map<String, Object?> data = const <String, Object?>{},
    List<NotificationAction> actions = const <NotificationAction>[],
    String? channelId,
    String? categoryId,
    String? routeType,
    String? deepLink,
    bool silent = false,
  }) {
    final message = client.parse(<String, Object?>{
      ...data,
      'notification_id': notificationId,
      'message_id': messageId,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'actions': actions.map((action) => action.toJson()).toList(),
      'channel_id': channelId,
      'category_id': categoryId,
      'type': routeType,
      'deep_link': deepLink,
      'silent': silent,
    });
    return client.show(message);
  }

  static Future<void> dismiss(int notificationId) =>
      client.dismiss(notificationId);
  static Future<void> cancel(int notificationId) =>
      client.cancel(notificationId);
  static Future<void> cancelAll() => client.cancelAll();

  static Future<Object?> navigate(
    String route, {
    Object? arguments,
    bool replace = false,
  }) => client.navigate(route, arguments: arguments, replace: replace);

  static Future<void> retryPendingActions() => client.retryPendingActions();

  static Future<void> dispose() async {
    final value = _client;
    _client = null;
    _initializing = null;
    await value?.dispose();
  }
}
