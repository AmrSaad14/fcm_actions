import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/events.dart';

typedef QueuedActionExecutor =
    Future<void> Function(NotificationActionEvent event);

/// Durable failed-action queue. It is intentionally transport agnostic:
/// authentication/network middleware can throw and the action is retried when
/// the app resumes or [drain] is called explicitly.
final class ActionQueue {
  ActionQueue({SharedPreferencesAsync? preferences, required this.maxRetries})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _storageKey = 'fcm_actions.queue.v1';

  final SharedPreferencesAsync _preferences;
  final int maxRetries;
  Future<void> _serial = Future<void>.value();

  Future<void> enqueue(NotificationActionEvent event) {
    _serial = _serial.then((_) async {
      final queue = await _read();
      final identity = _identity(event);
      if (queue.any((item) => item.identity == identity)) return;
      queue.add(_QueuedAction(identity: identity, event: event, attempts: 0));
      await _write(queue);
    });
    return _serial;
  }

  Future<void> drain(QueuedActionExecutor execute) {
    _serial = _serial.then((_) async {
      final queue = await _read();
      final remaining = <_QueuedAction>[];
      for (final item in queue) {
        try {
          await execute(item.event);
        } on Object {
          final attempts = item.attempts + 1;
          if (attempts < maxRetries) {
            remaining.add(item.copyWith(attempts: attempts));
          }
        }
      }
      await _write(remaining);
    });
    return _serial;
  }

  Future<int> count() async => (await _read()).length;

  Future<List<_QueuedAction>> _read() async {
    final encoded = await _preferences.getString(_storageKey);
    if (encoded == null) return <_QueuedAction>[];
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! List) return <_QueuedAction>[];
      return decoded
          .whereType<Map<Object?, Object?>>()
          .map(
            (item) => _QueuedAction.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList();
    } on Object {
      return <_QueuedAction>[];
    }
  }

  Future<void> _write(List<_QueuedAction> queue) => _preferences.setString(
    _storageKey,
    jsonEncode(queue.map((item) => item.toJson()).toList()),
  );

  static String _identity(NotificationActionEvent event) =>
      '${event.notificationId}:${event.actionId}:${event.message.messageId}';
}

final class _QueuedAction {
  const _QueuedAction({
    required this.identity,
    required this.event,
    required this.attempts,
  });

  final String identity;
  final NotificationActionEvent event;
  final int attempts;

  factory _QueuedAction.fromJson(Map<String, Object?> json) => _QueuedAction(
    identity: json['identity']! as String,
    event: NotificationActionEvent.fromJson(
      Map<String, Object?>.from(json['event']! as Map),
    ),
    attempts: json['attempts']! as int,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'identity': identity,
    'event': event.toJson(),
    'attempts': attempts,
  };

  _QueuedAction copyWith({int? attempts}) => _QueuedAction(
    identity: identity,
    event: event,
    attempts: attempts ?? this.attempts,
  );
}
