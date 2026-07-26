import 'dart:async';

import '../handlers/notification_action_handler.dart';
import '../models/configuration_models.dart';
import '../models/enums.dart';
import '../models/events.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';
import '../platform/background_dispatcher.dart';
import 'contracts.dart';
import 'fcm_actions_config.dart';
import 'notification_engine.dart';

/// Injectable, independently disposable package API.
///
/// Most applications use the static `FcmActions` facade. Tests and multi-app
/// setups can construct this class and inject a custom [NotificationEngine].
final class FcmActionsClient {
  FcmActionsClient(this.config, {NotificationEngine? engine})
    : _engine = engine ?? NotificationEngine(config: config);

  final FcmActionsConfig config;
  final NotificationEngine _engine;

  bool get isInitialized => _engine.isInitialized;
  Stream<NotificationEvent> get onNotification => _engine.events.onNotification;
  Stream<NotificationActionEvent> get onAction => _engine.events.onAction;
  Stream<NotificationEvent> get onDismiss => _engine.events.onDismiss;
  Stream<NotificationActionEvent> get onReply => _engine.events.onReply;
  Stream<NotificationEvent> get onForegroundMessage =>
      _engine.events.onForegroundMessage;
  Stream<NotificationEvent> get onBackgroundMessage =>
      _engine.events.onBackgroundMessage;
  Stream<NotificationEvent> get onOpenedApp => _engine.events.onOpenedApp;

  Future<void> initialize() => _engine.initialize();

  void registerAction(
    NotificationAction action, {
    NotificationActionCallback? handler,
  }) {
    _engine.actions.register(action, handler: handler);
    _schedulePersist();
  }

  void registerActions(Iterable<NotificationAction> actions) {
    _engine.actions.registerAll(actions);
    _schedulePersist();
  }

  void registerActionHandler(
    String actionId,
    NotificationActionCallback handler,
  ) => _engine.actions.registerHandler(actionId, handler);

  void registerHandler(NotificationActionHandler handler) =>
      registerActionHandler(handler.actionId, handler.handle);

  Future<void> registerChannel(NotificationChannel channel) async {
    _engine.channels.register(channel);
    if (isInitialized) {
      await _engine.localNotifications.createChannels(<NotificationChannel>[
        channel,
      ]);
    }
    await _persistRuntimeState();
  }

  void registerRoute(RouteMapper route) => _engine.navigator.register(route);

  NotificationMessage parse(Map<String, Object?> payload) =>
      _engine.parser.parseMap(payload);

  Future<void> show(NotificationMessage message) => _engine.show(message);

  Future<void> cancel(int notificationId) =>
      _engine.localNotifications.cancel(notificationId);

  Future<void> dismiss(int notificationId) => cancel(notificationId);

  Future<void> cancelAll() => _engine.localNotifications.cancelAll();

  Future<Object?> navigate(
    String route, {
    Object? arguments,
    bool replace = false,
  }) =>
      _engine.navigator.navigate(route, arguments: arguments, replace: replace);

  Future<void> retryPendingActions() => _engine.retryPendingActions();

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
