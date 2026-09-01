import 'dart:async';

import '../handlers/notification_action_handler.dart';
import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/events.dart';
import '../models/fcm_actions_init_result.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import '../models/notification_permission.dart';
import '../platform/background_dispatcher.dart';
import 'contracts.dart';
import 'fcm_actions_config.dart';
import 'notification_engine.dart';

/// Injectable, independently disposable package API.
///
/// Most applications use the static `FcmActions` facade. Tests and multi-app
/// setups can construct this class and inject a custom [NotificationEngine].
final class FcmActionsClient {
  /// Creates a client that owns or wraps a [NotificationEngine].
  FcmActionsClient(this.config, {NotificationEngine? engine})
    : _engine = engine ?? NotificationEngine(config: config);

  /// Initialization options used by this client.
  final FcmActionsConfig config;
  final NotificationEngine _engine;

  /// Whether [initialize] completed successfully.
  bool get isInitialized => _engine.isInitialized;

  /// Last successful [initialize] result, if any.
  FcmActionsInitResult? get lastResult => _engine.lastResult;

  /// Notifications received from FCM or local callbacks.
  Stream<NotificationEvent> get onNotification => _engine.events.onNotification;

  /// Action taps that completed the middleware/handler chain.
  Stream<NotificationActionEvent> get onAction => _engine.events.onAction;

  /// Notification dismissals.
  Stream<NotificationEvent> get onDismiss => _engine.events.onDismiss;

  /// Inline replies.
  Stream<NotificationActionEvent> get onReply => _engine.events.onReply;

  /// Foreground FCM messages.
  Stream<NotificationEvent> get onForegroundMessage =>
      _engine.events.onForegroundMessage;

  /// Background FCM messages replayed onto the main isolate.
  Stream<NotificationEvent> get onBackgroundMessage =>
      _engine.events.onBackgroundMessage;

  /// Notification taps that opened or resumed the app.
  Stream<NotificationEvent> get onOpenedApp => _engine.events.onOpenedApp;

  /// FCM token rotations.
  Stream<String> get onTokenRefresh => _engine.messaging.tokenRefresh;

  /// Initializes Firebase, local notifications, and FCM listeners.
  Future<FcmActionsInitResult> initialize() => _engine.initialize();

  /// Registers an action definition and optional handler.
  void registerAction(
    NotificationAction action, {
    NotificationActionCallback? handler,
  }) {
    _engine.actions.register(action, handler: handler);
    _schedulePersist();
  }

  /// Registers multiple action definitions.
  void registerActions(Iterable<NotificationAction> actions) {
    _engine.actions.registerAll(actions);
    _schedulePersist();
  }

  /// Removes a previously registered action.
  void unregisterAction(String actionId) {
    _engine.actions.unregister(actionId);
    _schedulePersist();
  }

  /// Binds a handler to an already registered action id.
  void registerActionHandler(
    String actionId,
    NotificationActionCallback handler,
  ) => _engine.actions.registerHandler(actionId, handler);

  /// Registers an object-oriented action handler.
  void registerHandler(NotificationActionHandler handler) =>
      registerActionHandler(handler.actionId, handler.handle);

  /// Registers an Android channel and persists it for background isolates.
  Future<void> registerChannel(NotificationChannel channel) async {
    _engine.channels.register(channel);
    if (isInitialized) {
      await _engine.localNotifications.createChannels(<NotificationChannel>[
        channel,
      ]);
    }
    await _persistRuntimeState();
  }

  /// Maps a payload `type` to a named route.
  void registerRoute(RouteMapper route) => _engine.navigator.register(route);

  /// Normalizes an FCM-style map into a [NotificationMessage].
  NotificationMessage parse(Map<String, Object?> payload) =>
      _engine.parser.parseMap(payload);

  /// Displays a local notification with the package action path.
  Future<void> show(NotificationMessage message) => _engine.show(message);

  /// Cancels a displayed notification.
  Future<void> cancel(int notificationId) =>
      _engine.localNotifications.cancel(notificationId);

  /// Alias for [cancel].
  Future<void> dismiss(int notificationId) => cancel(notificationId);

  /// Cancels every displayed notification.
  Future<void> cancelAll() => _engine.localNotifications.cancelAll();

  /// Pushes a named route through the configured navigator key.
  Future<Object?> navigate(
    String route, {
    Object? arguments,
    bool replace = false,
  }) =>
      _engine.navigator.navigate(route, arguments: arguments, replace: replace);

  /// Retries persisted failed actions.
  Future<void> retryPendingActions() => _engine.retryPendingActions();

  /// Current FCM registration token.
  Future<String?> getToken({String? vapidKey}) =>
      _engine.messaging.getToken(vapidKey: vapidKey ?? config.vapidKey);

  /// Apple Push Notification service token, or `null` elsewhere.
  Future<String?> getAPNSToken() => _engine.messaging.getAPNSToken();

  /// Invalidates the current FCM token.
  Future<void> deleteToken() => _engine.messaging.deleteToken();

  /// Subscribes this app instance to an FCM topic.
  Future<void> subscribeToTopic(String topic) =>
      _engine.messaging.subscribeToTopic(topic);

  /// Unsubscribes this app instance from an FCM topic.
  Future<void> unsubscribeFromTopic(String topic) =>
      _engine.messaging.unsubscribeFromTopic(topic);

  /// Reads notification permission without prompting.
  Future<NotificationPermission> getPermissionStatus() =>
      _engine.messaging.getPermissionStatus();

  /// Whether FCM is supported on this platform/browser.
  Future<bool> isSupported() => _engine.messaging.isSupported();

  /// Releases streams and lifecycle observers.
  Future<void> dispose() => _engine.dispose();

  Future<void> _persistRuntimeState() => BackgroundDispatcher.configure(
    config,
    actions: _engine.actions.actions.values,
    channels: _engine.channels.channels.values,
  );

  void _schedulePersist() {
    unawaited(
      _persistRuntimeState().onError((error, stackTrace) {
        config.logger.log(
          FcmLogLevel.warning,
          'Could not persist background action configuration.',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }
}
