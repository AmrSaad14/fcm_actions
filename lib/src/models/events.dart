import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';
import 'notification_message.dart';

part 'events.freezed.dart';
part 'events.g.dart';

/// Emitted whenever a notification is received, displayed, opened, or removed.
@freezed
abstract class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent({
    required NotificationMessage message,
    required DateTime timestamp,
    required NotificationPlatform platform,
    required NotificationState state,
    NotificationInteraction? interaction,
    @Default(<String, Object?>{}) Map<String, Object?> rawJson,
  }) = _NotificationEvent;

  factory NotificationEvent.fromJson(Map<String, Object?> json) =>
      _$NotificationEventFromJson(json);
}

/// Rich event emitted for action taps and inline replies.
@freezed
abstract class NotificationActionEvent with _$NotificationActionEvent {
  const factory NotificationActionEvent({
    required String actionId,
    required int notificationId,
    required DateTime timestamp,
    required NotificationMessage message,
    required NotificationPlatform platform,
    required NotificationState state,
    @Default(<String, Object?>{}) Map<String, Object?> payload,
    @Default(<String, Object?>{}) Map<String, Object?> rawJson,
    String? replyText,
    @Default(false) bool fromBackground,
  }) = _NotificationActionEvent;

  factory NotificationActionEvent.fromJson(Map<String, Object?> json) =>
      _$NotificationActionEventFromJson(json);
}
