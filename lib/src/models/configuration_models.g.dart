// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteMapper _$RouteMapperFromJson(Map<String, dynamic> json) => _RouteMapper(
  type: json['type'] as String,
  route: json['route'] as String,
  replace: json['replace'] as bool? ?? false,
);

Map<String, dynamic> _$RouteMapperToJson(_RouteMapper instance) =>
    <String, dynamic>{
      'type': instance.type,
      'route': instance.route,
      'replace': instance.replace,
    };

_NotificationChannel _$NotificationChannelFromJson(Map<String, dynamic> json) =>
    _NotificationChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      importance:
          $enumDecodeNullable(_$ChannelImportanceEnumMap, json['importance']) ??
          ChannelImportance.defaultImportance,
      playSound: json['playSound'] as bool? ?? true,
      enableVibration: json['enableVibration'] as bool? ?? true,
      showBadge: json['showBadge'] as bool? ?? true,
      sound: json['sound'] as String?,
      categoryId: json['categoryId'] as String?,
    );

Map<String, dynamic> _$NotificationChannelToJson(
  _NotificationChannel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'importance': _$ChannelImportanceEnumMap[instance.importance]!,
  'playSound': instance.playSound,
  'enableVibration': instance.enableVibration,
  'showBadge': instance.showBadge,
  'sound': instance.sound,
  'categoryId': instance.categoryId,
};

const _$ChannelImportanceEnumMap = {
  ChannelImportance.max: 'max',
  ChannelImportance.high: 'high',
  ChannelImportance.defaultImportance: 'defaultImportance',
  ChannelImportance.low: 'low',
  ChannelImportance.silent: 'silent',
};
