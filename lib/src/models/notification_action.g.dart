// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationAction _$NotificationActionFromJson(Map<String, dynamic> json) =>
    _NotificationAction(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String?,
      destructive: json['destructive'] as bool? ?? false,
      showsUserInterface: json['showsUserInterface'] as bool? ?? true,
      input: json['input'] as bool? ?? false,
      inputLabel: json['inputLabel'] as String?,
      executionMode:
          $enumDecodeNullable(
            _$ActionExecutionModeEnumMap,
            json['executionMode'],
          ) ??
          ActionExecutionMode.any,
      metadata:
          json['metadata'] as Map<String, dynamic>? ??
          const <String, Object?>{},
    );

Map<String, dynamic> _$NotificationActionToJson(_NotificationAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'icon': instance.icon,
      'destructive': instance.destructive,
      'showsUserInterface': instance.showsUserInterface,
      'input': instance.input,
      'inputLabel': instance.inputLabel,
      'executionMode': _$ActionExecutionModeEnumMap[instance.executionMode]!,
      'metadata': instance.metadata,
    };

const _$ActionExecutionModeEnumMap = {
  ActionExecutionMode.foreground: 'foreground',
  ActionExecutionMode.background: 'background',
  ActionExecutionMode.any: 'any',
};
