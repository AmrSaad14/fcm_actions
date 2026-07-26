// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationEvent _$NotificationEventFromJson(Map<String, dynamic> json) =>
    _NotificationEvent(
      message: NotificationMessage.fromJson(
        json['message'] as Map<String, dynamic>,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      platform: $enumDecode(_$NotificationPlatformEnumMap, json['platform']),
      state: $enumDecode(_$NotificationStateEnumMap, json['state']),
      interaction: $enumDecodeNullable(
        _$NotificationInteractionEnumMap,
        json['interaction'],
      ),
      rawJson:
          json['rawJson'] as Map<String, dynamic>? ?? const <String, Object?>{},
    );

Map<String, dynamic> _$NotificationEventToJson(_NotificationEvent instance) =>
    <String, dynamic>{
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'platform': _$NotificationPlatformEnumMap[instance.platform]!,
      'state': _$NotificationStateEnumMap[instance.state]!,
      'interaction': _$NotificationInteractionEnumMap[instance.interaction],
      'rawJson': instance.rawJson,
    };

const _$NotificationPlatformEnumMap = {
  NotificationPlatform.android: 'android',
  NotificationPlatform.ios: 'ios',
  NotificationPlatform.unknown: 'unknown',
};

const _$NotificationStateEnumMap = {
  NotificationState.foreground: 'foreground',
  NotificationState.background: 'background',
  NotificationState.terminated: 'terminated',
  NotificationState.resumed: 'resumed',
  NotificationState.unknown: 'unknown',
};

const _$NotificationInteractionEnumMap = {
  NotificationInteraction.bodyTap: 'bodyTap',
  NotificationInteraction.actionTap: 'actionTap',
  NotificationInteraction.dismiss: 'dismiss',
  NotificationInteraction.reply: 'reply',
  NotificationInteraction.launch: 'launch',
};

_NotificationActionEvent _$NotificationActionEventFromJson(
  Map<String, dynamic> json,
) => _NotificationActionEvent(
  actionId: json['actionId'] as String,
  notificationId: (json['notificationId'] as num).toInt(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  message: NotificationMessage.fromJson(
    json['message'] as Map<String, dynamic>,
  ),
  platform: $enumDecode(_$NotificationPlatformEnumMap, json['platform']),
  state: $enumDecode(_$NotificationStateEnumMap, json['state']),
  payload:
      json['payload'] as Map<String, dynamic>? ?? const <String, Object?>{},
  rawJson:
      json['rawJson'] as Map<String, dynamic>? ?? const <String, Object?>{},
  replyText: json['replyText'] as String?,
  fromBackground: json['fromBackground'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationActionEventToJson(
  _NotificationActionEvent instance,
) => <String, dynamic>{
  'actionId': instance.actionId,
  'notificationId': instance.notificationId,
  'timestamp': instance.timestamp.toIso8601String(),
  'message': instance.message,
  'platform': _$NotificationPlatformEnumMap[instance.platform]!,
  'state': _$NotificationStateEnumMap[instance.state]!,
  'payload': instance.payload,
  'rawJson': instance.rawJson,
  'replyText': instance.replyText,
  'fromBackground': instance.fromBackground,
};
