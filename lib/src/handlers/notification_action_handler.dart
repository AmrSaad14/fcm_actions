import '../models/events.dart';

/// Object-oriented alternative to a callback action handler.
abstract interface class NotificationActionHandler {
  String get actionId;

  Future<void> handle(NotificationActionEvent event);
}
