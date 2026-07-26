import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../core/exceptions.dart';
import '../models/notification_action.dart';
import '../models/notification_message.dart';

typedef ActionResolver = NotificationAction? Function(String id);

/// Converts FCM's platform-specific shape into a validated package model.
final class NotificationParser {
  const NotificationParser({
    required this.maxPayloadBytes,
    required this.defaultChannelId,
    required this.resolveAction,
  });

  final int maxPayloadBytes;
  final String defaultChannelId;
  final ActionResolver resolveAction;

  NotificationMessage parseRemoteMessage(RemoteMessage remote) {
    final raw = _jsonMap(remote.toMap());
    final data = _jsonMap(remote.data);
    return parseMap(<String, Object?>{
      ...data,
      if (remote.notification?.title != null)
        'title': remote.notification!.title,
      if (remote.notification?.body != null) 'body': remote.notification!.body,
      if (remote.notification?.android?.imageUrl != null)
        'image_url': remote.notification!.android!.imageUrl,
      if (remote.notification?.apple?.imageUrl != null)
        'image_url': remote.notification!.apple!.imageUrl,
      if (remote.category != null) 'category_id': remote.category,
      if (remote.messageId != null) 'message_id': remote.messageId,
      if (remote.sentTime != null)
        'sent_at': remote.sentTime!.toIso8601String(),
      if (remote.collapseKey != null) 'collapse_key': remote.collapseKey,
      if (remote.from?.startsWith('/topics/') ?? false)
        'topic': remote.from!.substring('/topics/'.length),
      if (remote.contentAvailable) 'silent': true,
    }, rawJson: raw);
  }

  NotificationMessage parseMap(
    Map<String, Object?> input, {
    Map<String, Object?>? rawJson,
  }) {
    final normalized = _jsonMap(input);
    final encoded = utf8.encode(jsonEncode(normalized));
    if (encoded.length > maxPayloadBytes) {
      throw InvalidNotificationPayloadException(
        'Payload is ${encoded.length} bytes; maximum is $maxPayloadBytes.',
      );
    }

    final messageId =
        _string(normalized['message_id']) ??
        _string(normalized['messageId']) ??
        sha256.convert(encoded).toString();
    final notificationId =
        _int(normalized['notification_id']) ?? _stableInt(messageId);
    final actions = _parseActions(normalized['actions']);
    final category =
        _string(normalized['category_id']) ??
        (actions.isEmpty ? null : _categoryFor(actions));

    return NotificationMessage(
      notificationId: notificationId,
      messageId: messageId,
      title: _string(normalized['title']),
      body: _string(normalized['body']),
      imageUrl:
          _string(normalized['image_url']) ?? _string(normalized['imageUrl']),
      data: normalized,
      actions: actions,
      channelId: _string(normalized['channel_id']) ?? defaultChannelId,
      categoryId: category,
      routeType:
          _string(normalized['type']) ?? _string(normalized['route_type']),
      deepLink:
          _string(normalized['deep_link']) ?? _string(normalized['deepLink']),
      sentAt: _dateTime(normalized['sent_at']),
      topic: _string(normalized['topic']),
      collapseKey: _string(normalized['collapse_key']),
      silent:
          _bool(normalized['silent']) ||
          (_string(normalized['content_available']) == '1'),
      rawJson: rawJson ?? normalized,
    );
  }

  List<NotificationAction> _parseActions(Object? value) {
    Object? decoded = value;
    if (value is String && value.trim().isNotEmpty) {
      try {
        decoded = jsonDecode(value);
      } on FormatException catch (error) {
        throw InvalidNotificationPayloadException(
          'The "actions" field is not valid JSON.',
          cause: error,
        );
      }
    }
    if (decoded == null || decoded == '') return const <NotificationAction>[];
    if (decoded is! List<Object?>) {
      throw const InvalidNotificationPayloadException(
        'The "actions" field must be a JSON array.',
      );
    }

    return decoded
        .map((item) {
          if (item is String) {
            final registered = resolveAction(item);
            if (registered == null) {
              throw InvalidNotificationPayloadException(
                'Action "$item" is not registered and has no inline definition.',
              );
            }
            return registered;
          }
          if (item is! Map) {
            throw const InvalidNotificationPayloadException(
              'Each action must be an object or registered action id.',
            );
          }
          final map = _jsonMap(item);
          final id = _string(map['id']);
          if (id == null) {
            throw const InvalidNotificationPayloadException(
              'Each action requires a non-empty "id".',
            );
          }
          final registered = resolveAction(id);
          return NotificationAction.fromJson(<String, Object?>{
            if (registered != null) ...registered.toJson(),
            ...map,
            'id': id,
            'title': _string(map['title']) ?? registered?.title ?? id,
          });
        })
        .toList(growable: false);
  }

  static Map<String, Object?> _jsonMap(Map<dynamic, dynamic> value) =>
      value.map((key, item) => MapEntry(key.toString(), _jsonValue(item)));

  static Object? _jsonValue(Object? value) {
    if (value == null || value is num || value is bool || value is String) {
      return value;
    }
    if (value is DateTime) return value.toIso8601String();
    if (value is Map) return _jsonMap(value);
    if (value is Iterable) {
      return value.map<Object?>((item) => _jsonValue(item)).toList();
    }
    return value.toString();
  }

  static String? _string(Object? value) {
    final result = value?.toString().trim();
    return result == null || result.isEmpty ? null : result;
  }

  static int? _int(Object? value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '');

  static bool _bool(Object? value) =>
      value == true ||
      value == 1 ||
      const <String>{
        'true',
        '1',
        'yes',
      }.contains(value?.toString().toLowerCase());

  static DateTime? _dateTime(Object? value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return DateTime.tryParse(value.toString());
  }

  static int _stableInt(String input) {
    final bytes = sha256.convert(utf8.encode(input)).bytes;
    return ((bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3]) &
        0x7fffffff;
  }

  static String _categoryFor(List<NotificationAction> actions) {
    final ids = actions.map((action) => action.id).join('|');
    return 'fcm_actions_${sha256.convert(utf8.encode(ids)).toString().substring(0, 12)}';
  }
}
