import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'notification_action.freezed.dart';
part 'notification_action.g.dart';

/// A platform-neutral notification action.
///
/// [id] is intentionally not an enum: applications can add action types
/// without changing this package.
@freezed
abstract class NotificationAction with _$NotificationAction {
  const factory NotificationAction({
    required String id,
    required String title,
    String? icon,
    @Default(false) bool destructive,
    @Default(true) bool showsUserInterface,
    @Default(false) bool input,
    String? inputLabel,
    @Default(ActionExecutionMode.any) ActionExecutionMode executionMode,
    @Default(<String, Object?>{}) Map<String, Object?> metadata,
  }) = _NotificationAction;

  factory NotificationAction.fromJson(Map<String, Object?> json) =>
      _$NotificationActionFromJson(json);
}
