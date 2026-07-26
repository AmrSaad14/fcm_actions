import 'package:freezed_annotation/freezed_annotation.dart';

import 'notification_action.dart';

part 'notification_message.freezed.dart';
part 'notification_message.g.dart';

/// A normalized FCM or local notification.
@freezed
abstract class NotificationMessage with _$NotificationMessage {
  const factory NotificationMessage({
    required int notificationId,
    required String messageId,
    String? title,
    String? body,
    String? imageUrl,
    @Default(<String, Object?>{}) Map<String, Object?> data,
    @Default(<NotificationAction>[]) List<NotificationAction> actions,
    @Default('fcm_actions_default') String channelId,
    String? categoryId,
    String? routeType,
    String? deepLink,
    DateTime? sentAt,
    String? topic,
    String? collapseKey,
    @Default(false) bool silent,
    @Default(<String, Object?>{}) Map<String, Object?> rawJson,
  }) = _NotificationMessage;

  factory NotificationMessage.fromJson(Map<String, Object?> json) =>
      _$NotificationMessageFromJson(json);
}
