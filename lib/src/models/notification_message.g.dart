// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationMessage _$NotificationMessageFromJson(Map<String, dynamic> json) =>
    _NotificationMessage(
      notificationId: (json['notificationId'] as num).toInt(),
      messageId: json['messageId'] as String,
      title: json['title'] as String?,
      body: json['body'] as String?,
      imageUrl: json['imageUrl'] as String?,
      data: json['data'] as Map<String, dynamic>? ?? const <String, Object?>{},
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map(
                (e) => NotificationAction.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <NotificationAction>[],
      channelId: json['channelId'] as String? ?? 'fcm_actions_default',
      categoryId: json['categoryId'] as String?,
      routeType: json['routeType'] as String?,
      deepLink: json['deepLink'] as String?,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      topic: json['topic'] as String?,
      collapseKey: json['collapseKey'] as String?,
      silent: json['silent'] as bool? ?? false,
      rawJson:
          json['rawJson'] as Map<String, dynamic>? ?? const <String, Object?>{},
    );

Map<String, dynamic> _$NotificationMessageToJson(
  _NotificationMessage instance,
) => <String, dynamic>{
  'notificationId': instance.notificationId,
  'messageId': instance.messageId,
  'title': instance.title,
  'body': instance.body,
  'imageUrl': instance.imageUrl,
  'data': instance.data,
  'actions': instance.actions,
  'channelId': instance.channelId,
  'categoryId': instance.categoryId,
  'routeType': instance.routeType,
  'deepLink': instance.deepLink,
  'sentAt': instance.sentAt?.toIso8601String(),
  'topic': instance.topic,
  'collapseKey': instance.collapseKey,
  'silent': instance.silent,
  'rawJson': instance.rawJson,
};
