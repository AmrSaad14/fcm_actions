import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'configuration_models.freezed.dart';
part 'configuration_models.g.dart';

/// Maps a payload `type` to a named Flutter route.
@freezed
abstract class RouteMapper with _$RouteMapper {
  const factory RouteMapper({
    required String type,
    required String route,
    @Default(false) bool replace,
  }) = _RouteMapper;

  factory RouteMapper.fromJson(Map<String, Object?> json) =>
      _$RouteMapperFromJson(json);
}

/// Cross-platform channel configuration.
///
/// iOS ignores Android-only channel properties and uses [categoryId].
@freezed
abstract class NotificationChannel with _$NotificationChannel {
  const factory NotificationChannel({
    required String id,
    required String name,
    @Default('') String description,
    @Default(ChannelImportance.defaultImportance) ChannelImportance importance,
    @Default(true) bool playSound,
    @Default(true) bool enableVibration,
    @Default(true) bool showBadge,
    String? sound,
    String? categoryId,
  }) = _NotificationChannel;

  factory NotificationChannel.fromJson(Map<String, Object?> json) =>
      _$NotificationChannelFromJson(json);

  static const NotificationChannel max = NotificationChannel(
    id: 'fcm_actions_max',
    name: 'Urgent notifications',
    description: 'Time-sensitive notifications requiring immediate attention.',
    importance: ChannelImportance.max,
  );

  static const NotificationChannel high = NotificationChannel(
    id: 'fcm_actions_high',
    name: 'High priority notifications',
    description: 'Important notifications.',
    importance: ChannelImportance.high,
  );

  static const NotificationChannel defaultChannel = NotificationChannel(
    id: 'fcm_actions_default',
    name: 'General notifications',
    description: 'General application notifications.',
  );

  static const NotificationChannel low = NotificationChannel(
    id: 'fcm_actions_low',
    name: 'Low priority notifications',
    description: 'Non-urgent notifications.',
    importance: ChannelImportance.low,
  );

  static const NotificationChannel silent = NotificationChannel(
    id: 'fcm_actions_silent',
    name: 'Silent notifications',
    description: 'Notifications delivered without sound or vibration.',
    importance: ChannelImportance.silent,
    playSound: false,
    enableVibration: false,
  );
}
