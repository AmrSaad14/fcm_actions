// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationAction {

 String get id; String get title; String? get icon; bool get destructive; bool get showsUserInterface; bool get input; String? get inputLabel; ActionExecutionMode get executionMode; Map<String, Object?> get metadata;
/// Create a copy of NotificationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationActionCopyWith<NotificationAction> get copyWith => _$NotificationActionCopyWithImpl<NotificationAction>(this as NotificationAction, _$identity);

  /// Serializes this NotificationAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationAction&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.destructive, destructive) || other.destructive == destructive)&&(identical(other.showsUserInterface, showsUserInterface) || other.showsUserInterface == showsUserInterface)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputLabel, inputLabel) || other.inputLabel == inputLabel)&&(identical(other.executionMode, executionMode) || other.executionMode == executionMode)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,icon,destructive,showsUserInterface,input,inputLabel,executionMode,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'NotificationAction(id: $id, title: $title, icon: $icon, destructive: $destructive, showsUserInterface: $showsUserInterface, input: $input, inputLabel: $inputLabel, executionMode: $executionMode, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $NotificationActionCopyWith<$Res>  {
  factory $NotificationActionCopyWith(NotificationAction value, $Res Function(NotificationAction) _then) = _$NotificationActionCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? icon, bool destructive, bool showsUserInterface, bool input, String? inputLabel, ActionExecutionMode executionMode, Map<String, Object?> metadata
});




}
/// @nodoc
class _$NotificationActionCopyWithImpl<$Res>
    implements $NotificationActionCopyWith<$Res> {
  _$NotificationActionCopyWithImpl(this._self, this._then);

  final NotificationAction _self;
  final $Res Function(NotificationAction) _then;

/// Create a copy of NotificationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? icon = freezed,Object? destructive = null,Object? showsUserInterface = null,Object? input = null,Object? inputLabel = freezed,Object? executionMode = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as bool,showsUserInterface: null == showsUserInterface ? _self.showsUserInterface : showsUserInterface // ignore: cast_nullable_to_non_nullable
as bool,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as bool,inputLabel: freezed == inputLabel ? _self.inputLabel : inputLabel // ignore: cast_nullable_to_non_nullable
as String?,executionMode: null == executionMode ? _self.executionMode : executionMode // ignore: cast_nullable_to_non_nullable
as ActionExecutionMode,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationAction].
extension NotificationActionPatterns on NotificationAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationAction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationAction value)  $default,){
final _that = this;
switch (_that) {
case _NotificationAction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationAction value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationAction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? icon,  bool destructive,  bool showsUserInterface,  bool input,  String? inputLabel,  ActionExecutionMode executionMode,  Map<String, Object?> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationAction() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.destructive,_that.showsUserInterface,_that.input,_that.inputLabel,_that.executionMode,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? icon,  bool destructive,  bool showsUserInterface,  bool input,  String? inputLabel,  ActionExecutionMode executionMode,  Map<String, Object?> metadata)  $default,) {final _that = this;
switch (_that) {
case _NotificationAction():
return $default(_that.id,_that.title,_that.icon,_that.destructive,_that.showsUserInterface,_that.input,_that.inputLabel,_that.executionMode,_that.metadata);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? icon,  bool destructive,  bool showsUserInterface,  bool input,  String? inputLabel,  ActionExecutionMode executionMode,  Map<String, Object?> metadata)?  $default,) {final _that = this;
switch (_that) {
case _NotificationAction() when $default != null:
return $default(_that.id,_that.title,_that.icon,_that.destructive,_that.showsUserInterface,_that.input,_that.inputLabel,_that.executionMode,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationAction implements NotificationAction {
  const _NotificationAction({required this.id, required this.title, this.icon, this.destructive = false, this.showsUserInterface = true, this.input = false, this.inputLabel, this.executionMode = ActionExecutionMode.any, final  Map<String, Object?> metadata = const <String, Object?>{}}): _metadata = metadata;
  factory _NotificationAction.fromJson(Map<String, dynamic> json) => _$NotificationActionFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? icon;
@override@JsonKey() final  bool destructive;
@override@JsonKey() final  bool showsUserInterface;
@override@JsonKey() final  bool input;
@override final  String? inputLabel;
@override@JsonKey() final  ActionExecutionMode executionMode;
 final  Map<String, Object?> _metadata;
@override@JsonKey() Map<String, Object?> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of NotificationAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationActionCopyWith<_NotificationAction> get copyWith => __$NotificationActionCopyWithImpl<_NotificationAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationAction&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.destructive, destructive) || other.destructive == destructive)&&(identical(other.showsUserInterface, showsUserInterface) || other.showsUserInterface == showsUserInterface)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputLabel, inputLabel) || other.inputLabel == inputLabel)&&(identical(other.executionMode, executionMode) || other.executionMode == executionMode)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,icon,destructive,showsUserInterface,input,inputLabel,executionMode,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'NotificationAction(id: $id, title: $title, icon: $icon, destructive: $destructive, showsUserInterface: $showsUserInterface, input: $input, inputLabel: $inputLabel, executionMode: $executionMode, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$NotificationActionCopyWith<$Res> implements $NotificationActionCopyWith<$Res> {
  factory _$NotificationActionCopyWith(_NotificationAction value, $Res Function(_NotificationAction) _then) = __$NotificationActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? icon, bool destructive, bool showsUserInterface, bool input, String? inputLabel, ActionExecutionMode executionMode, Map<String, Object?> metadata
});




}
/// @nodoc
class __$NotificationActionCopyWithImpl<$Res>
    implements _$NotificationActionCopyWith<$Res> {
  __$NotificationActionCopyWithImpl(this._self, this._then);

  final _NotificationAction _self;
  final $Res Function(_NotificationAction) _then;

/// Create a copy of NotificationAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? icon = freezed,Object? destructive = null,Object? showsUserInterface = null,Object? input = null,Object? inputLabel = freezed,Object? executionMode = null,Object? metadata = null,}) {
  return _then(_NotificationAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,destructive: null == destructive ? _self.destructive : destructive // ignore: cast_nullable_to_non_nullable
as bool,showsUserInterface: null == showsUserInterface ? _self.showsUserInterface : showsUserInterface // ignore: cast_nullable_to_non_nullable
as bool,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as bool,inputLabel: freezed == inputLabel ? _self.inputLabel : inputLabel // ignore: cast_nullable_to_non_nullable
as String?,executionMode: null == executionMode ? _self.executionMode : executionMode // ignore: cast_nullable_to_non_nullable
as ActionExecutionMode,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
