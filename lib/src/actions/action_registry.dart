import 'dart:collection';

import '../core/contracts.dart';
import '../core/exceptions.dart';
import '../models/notification_action.dart';

/// In-memory registry owned by an [FcmActionsClient] instance.
final class ActionRegistry {
  final Map<String, NotificationAction> _actions =
      <String, NotificationAction>{};
  final Map<String, NotificationActionCallback> _handlers =
      <String, NotificationActionCallback>{};

  /// Registered action definitions keyed by id.
  UnmodifiableMapView<String, NotificationAction> get actions =>
      UnmodifiableMapView<String, NotificationAction>(_actions);

  /// Adds or replaces an action definition.
  void register(
    NotificationAction action, {
    NotificationActionCallback? handler,
  }) {
    _validateId(action.id);
    if (action.title.trim().isEmpty) {
      throw const InvalidNotificationPayloadException(
        'Action title must not be empty.',
      );
    }
    _actions[action.id] = action;
    if (handler != null) _handlers[action.id] = handler;
  }

  /// Registers every action in [actions].
  void registerAll(Iterable<NotificationAction> actions) {
    for (final action in actions) {
      register(action);
    }
  }

  /// Binds a handler to [actionId] without changing the definition.
  void registerHandler(String actionId, NotificationActionCallback handler) {
    _validateId(actionId);
    _handlers[actionId] = handler;
  }

  /// Returns the definition for [id], if registered.
  NotificationAction? find(String id) => _actions[id];

  /// Returns the handler for [id], if registered.
  NotificationActionCallback? handlerFor(String id) => _handlers[id];

  /// Removes the definition and handler for [id].
  bool unregister(String id) {
    _handlers.remove(id);
    return _actions.remove(id) != null;
  }

  /// Removes every definition and handler.
  void clear() {
    _actions.clear();
    _handlers.clear();
  }

  static void _validateId(String id) {
    final normalized = id.trim();
    if (normalized.isEmpty ||
        normalized.length > 128 ||
        !RegExp(r'^[A-Za-z0-9_.:-]+$').hasMatch(normalized)) {
      throw InvalidNotificationPayloadException(
        'Invalid action id "$id". Use 1-128 letters, numbers, ".", "_", '
        '":" or "-".',
      );
    }
  }
}
