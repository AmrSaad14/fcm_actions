import '../models/events.dart';

/// Object-oriented alternative to a callback action handler.
abstract interface class NotificationActionHandler {
  /// Action id this handler owns.
  String get actionId;

  /// Executes the action. Must be idempotent.
  Future<void> handle(NotificationActionEvent event);
}
