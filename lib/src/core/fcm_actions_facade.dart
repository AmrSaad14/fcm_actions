import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../handlers/notification_action_handler.dart';
import '../models/configuration_models.dart';
import '../models/events.dart';
import '../models/fcm_actions_init_result.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import '../models/notification_permission.dart';
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
  static Future<FcmActionsInitResult>? _initializing;
  static FcmActionsInitResult? _lastResult;

  /// The default client. Throws if [initialize] has not completed.
  static FcmActionsClient get client {
    final value = _client;
    if (value == null) {
      throw StateError('Call FcmActions.initialize() before using the API.');
    }
    return value;
  }

  /// Whether the default client finished initializing.
  static bool get isInitialized => _client?.isInitialized ?? false;

  /// Last successful [initialize] result for the default client.
  static FcmActionsInitResult? get lastResult => _lastResult;

  /// Notifications received from FCM or local callbacks.
  static Stream<NotificationEvent> get onNotification => client.onNotification;

  /// Action taps that completed the middleware/handler chain.
  static Stream<NotificationActionEvent> get onAction => client.onAction;

  /// Notification dismissals.
  static Stream<NotificationEvent> get onDismiss => client.onDismiss;

  /// Inline replies.
  static Stream<NotificationActionEvent> get onReply => client.onReply;

  /// Foreground FCM messages.
  static Stream<NotificationEvent> get onForegroundMessage =>
      client.onForegroundMessage;

  /// Background FCM messages replayed onto the main isolate.
  static Stream<NotificationEvent> get onBackgroundMessage =>
      client.onBackgroundMessage;

  /// Notification taps that opened or resumed the app.
  static Stream<NotificationEvent> get onOpenedApp => client.onOpenedApp;

  /// FCM token rotations.
  static Stream<String> get onTokenRefresh => client.onTokenRefresh;

  /// Initializes the default client and returns permission plus token state.
  static Future<FcmActionsInitResult> initialize({
    GlobalKey<NavigatorState>? navigatorKey,
    FirebaseOptions? firebaseOptions,
    String? firebaseAppName,
    bool initializeFirebase = true,
    bool requestPermission = true,
    NotificationPermissionRequest permissionRequest =
        const NotificationPermissionRequest(),
    bool autoDisplayDataMessages = true,
    bool autoNavigate = true,
    bool fetchTokenOnInitialize = true,
    String? vapidKey,
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
      permissionRequest: permissionRequest,
      autoDisplayDataMessages: autoDisplayDataMessages,
      autoNavigate: autoNavigate,
      fetchTokenOnInitialize: fetchTokenOnInitialize,
      vapidKey: vapidKey,
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

  /// Initializes the default client from an explicit [config].
  static Future<FcmActionsInitResult> initializeWithConfig(
    FcmActionsConfig config,
  ) {
    if (_client?.isInitialized ?? false) {
      return Future<FcmActionsInitResult>.value(
        _lastResult ?? const FcmActionsInitResult.unavailable(),
      );
    }
    final inProgress = _initializing;
    if (inProgress != null) return inProgress;
    final value = FcmActionsClient(config);
    _client = value;
    final future = value.initialize().then((result) {
      _lastResult = result;
      return result;
    });
    _initializing = future;
    return future.whenComplete(() {
      _initializing = null;
      if (!value.isInitialized) {
        _client = null;
        _lastResult = null;
      }
    });
  }

  /// Registers an action definition and optional handler.
  static void registerAction(
    NotificationAction action, {
    NotificationActionCallback? handler,
  }) => client.registerAction(action, handler: handler);

  /// Registers multiple action definitions.
  static void registerActions(Iterable<NotificationAction> actions) =>
      client.registerActions(actions);

  /// Removes a previously registered action.
  static void unregisterAction(String actionId) =>
      client.unregisterAction(actionId);

  /// Binds a handler to an already registered action id.
  static void registerActionHandler(
    String actionId,
    NotificationActionCallback handler,
  ) => client.registerActionHandler(actionId, handler);

  /// Registers an object-oriented action handler.
  static void registerHandler(NotificationActionHandler handler) =>
      client.registerHandler(handler);

  /// Registers an Android channel.
  static Future<void> registerChannel(NotificationChannel channel) =>
      client.registerChannel(channel);

  /// Maps a payload `type` to a named route.
  static void registerRoute(RouteMapper route) => client.registerRoute(route);

  /// Normalizes an FCM-style map into a [NotificationMessage].
  static NotificationMessage parse(Map<String, Object?> payload) =>
      client.parse(payload);

  /// Displays a local notification with the package action path.
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

  /// Alias for [cancel].
  static Future<void> dismiss(int notificationId) =>
      client.dismiss(notificationId);

  /// Cancels a displayed notification.
  static Future<void> cancel(int notificationId) =>
      client.cancel(notificationId);

  /// Cancels every displayed notification.
  static Future<void> cancelAll() => client.cancelAll();

  /// Pushes a named route through the configured navigator key.
  static Future<Object?> navigate(
    String route, {
    Object? arguments,
    bool replace = false,
  }) => client.navigate(route, arguments: arguments, replace: replace);

  /// Retries persisted failed actions.
  static Future<void> retryPendingActions() => client.retryPendingActions();

  /// Current FCM registration token.
  static Future<String?> getToken({String? vapidKey}) =>
      client.getToken(vapidKey: vapidKey);

  /// Apple Push Notification service token, or `null` elsewhere.
  static Future<String?> getAPNSToken() => client.getAPNSToken();

  /// Invalidates the current FCM token.
  static Future<void> deleteToken() => client.deleteToken();

  /// Subscribes this app instance to an FCM topic.
  static Future<void> subscribeToTopic(String topic) =>
      client.subscribeToTopic(topic);

  /// Unsubscribes this app instance from an FCM topic.
  static Future<void> unsubscribeFromTopic(String topic) =>
      client.unsubscribeFromTopic(topic);

  /// Reads notification permission without prompting.
  static Future<NotificationPermission> getPermissionStatus() =>
      client.getPermissionStatus();

  /// Whether FCM is supported on this platform/browser.
  static Future<bool> isSupported() => client.isSupported();

  /// Disposes the default client.
  static Future<void> dispose() async {
    final value = _client;
    _client = null;
    _initializing = null;
    _lastResult = null;
    await value?.dispose();
  }
}
