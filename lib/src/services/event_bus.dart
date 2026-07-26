import 'dart:async';

import '../models/events.dart';

/// Typed broadcast streams for package events.
final class FcmActionsEventBus {
  final StreamController<NotificationEvent> _notifications =
      StreamController<NotificationEvent>.broadcast();
  final StreamController<NotificationActionEvent> _actions =
      StreamController<NotificationActionEvent>.broadcast();
  final StreamController<NotificationEvent> _dismissals =
      StreamController<NotificationEvent>.broadcast();
  final StreamController<NotificationActionEvent> _replies =
      StreamController<NotificationActionEvent>.broadcast();
  final StreamController<NotificationEvent> _foreground =
      StreamController<NotificationEvent>.broadcast();
  final StreamController<NotificationEvent> _background =
      StreamController<NotificationEvent>.broadcast();
  final StreamController<NotificationEvent> _opened =
      StreamController<NotificationEvent>.broadcast();

  Stream<NotificationEvent> get onNotification => _notifications.stream;
  Stream<NotificationActionEvent> get onAction => _actions.stream;
  Stream<NotificationEvent> get onDismiss => _dismissals.stream;
  Stream<NotificationActionEvent> get onReply => _replies.stream;
  Stream<NotificationEvent> get onForegroundMessage => _foreground.stream;
  Stream<NotificationEvent> get onBackgroundMessage => _background.stream;
  Stream<NotificationEvent> get onOpenedApp => _opened.stream;

  void notification(NotificationEvent event) => _notifications.add(event);
  void action(NotificationActionEvent event) => _actions.add(event);
  void dismissal(NotificationEvent event) => _dismissals.add(event);
  void reply(NotificationActionEvent event) => _replies.add(event);
  void foreground(NotificationEvent event) => _foreground.add(event);
  void background(NotificationEvent event) => _background.add(event);
  void opened(NotificationEvent event) => _opened.add(event);

  Future<void> dispose() async {
    await Future.wait<void>(<Future<void>>[
      _notifications.close(),
      _actions.close(),
      _dismissals.close(),
      _replies.close(),
      _foreground.close(),
      _background.close(),
      _opened.close(),
    ]);
  }
}
