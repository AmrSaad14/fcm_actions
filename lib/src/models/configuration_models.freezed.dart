// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'configuration_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RouteMapper {

 String get type; String get route; bool get replace;
/// Create a copy of RouteMapper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteMapperCopyWith<RouteMapper> get copyWith => _$RouteMapperCopyWithImpl<RouteMapper>(this as RouteMapper, _$identity);

  /// Serializes this RouteMapper to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteMapper&&(identical(other.type, type) || other.type == type)&&(identical(other.route, route) || other.route == route)&&(identical(other.replace, replace) || other.replace == replace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,route,replace);

@override
String toString() {
  return 'RouteMapper(type: $type, route: $route, replace: $replace)';
}


}

/// @nodoc
abstract mixin class $RouteMapperCopyWith<$Res>  {
  factory $RouteMapperCopyWith(RouteMapper value, $Res Function(RouteMapper) _then) = _$RouteMapperCopyWithImpl;
@useResult
$Res call({
 String type, String route, bool replace
});




}
/// @nodoc
class _$RouteMapperCopyWithImpl<$Res>
    implements $RouteMapperCopyWith<$Res> {
  _$RouteMapperCopyWithImpl(this._self, this._then);

  final RouteMapper _self;
  final $Res Function(RouteMapper) _then;

/// Create a copy of RouteMapper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? route = null,Object? replace = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,replace: null == replace ? _self.replace : replace // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteMapper].
extension RouteMapperPatterns on RouteMapper {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RouteMapper value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RouteMapper() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RouteMapper value)  $default,){
final _that = this;
switch (_that) {
case _RouteMapper():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RouteMapper value)?  $default,){
final _that = this;
switch (_that) {
case _RouteMapper() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String route,  bool replace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RouteMapper() when $default != null:
return $default(_that.type,_that.route,_that.replace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String route,  bool replace)  $default,) {final _that = this;
switch (_that) {
case _RouteMapper():
return $default(_that.type,_that.route,_that.replace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String route,  bool replace)?  $default,) {final _that = this;
switch (_that) {
case _RouteMapper() when $default != null:
return $default(_that.type,_that.route,_that.replace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RouteMapper implements RouteMapper {
  const _RouteMapper({required this.type, required this.route, this.replace = false});
  factory _RouteMapper.fromJson(Map<String, dynamic> json) => _$RouteMapperFromJson(json);

@override final  String type;
@override final  String route;
@override@JsonKey() final  bool replace;

/// Create a copy of RouteMapper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RouteMapperCopyWith<_RouteMapper> get copyWith => __$RouteMapperCopyWithImpl<_RouteMapper>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RouteMapperToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RouteMapper&&(identical(other.type, type) || other.type == type)&&(identical(other.route, route) || other.route == route)&&(identical(other.replace, replace) || other.replace == replace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,route,replace);

@override
String toString() {
  return 'RouteMapper(type: $type, route: $route, replace: $replace)';
}


}

/// @nodoc
abstract mixin class _$RouteMapperCopyWith<$Res> implements $RouteMapperCopyWith<$Res> {
  factory _$RouteMapperCopyWith(_RouteMapper value, $Res Function(_RouteMapper) _then) = __$RouteMapperCopyWithImpl;
@override @useResult
$Res call({
 String type, String route, bool replace
});




}
/// @nodoc
class __$RouteMapperCopyWithImpl<$Res>
    implements _$RouteMapperCopyWith<$Res> {
  __$RouteMapperCopyWithImpl(this._self, this._then);

  final _RouteMapper _self;
  final $Res Function(_RouteMapper) _then;

/// Create a copy of RouteMapper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? route = null,Object? replace = null,}) {
  return _then(_RouteMapper(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,replace: null == replace ? _self.replace : replace // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NotificationChannel {

 String get id; String get name; String get description; ChannelImportance get importance; bool get playSound; bool get enableVibration; bool get showBadge; String? get sound; String? get categoryId;
/// Create a copy of NotificationChannel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationChannelCopyWith<NotificationChannel> get copyWith => _$NotificationChannelCopyWithImpl<NotificationChannel>(this as NotificationChannel, _$identity);

  /// Serializes this NotificationChannel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.playSound, playSound) || other.playSound == playSound)&&(identical(other.enableVibration, enableVibration) || other.enableVibration == enableVibration)&&(identical(other.showBadge, showBadge) || other.showBadge == showBadge)&&(identical(other.sound, sound) || other.sound == sound)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,importance,playSound,enableVibration,showBadge,sound,categoryId);

@override
String toString() {
  return 'NotificationChannel(id: $id, name: $name, description: $description, importance: $importance, playSound: $playSound, enableVibration: $enableVibration, showBadge: $showBadge, sound: $sound, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class $NotificationChannelCopyWith<$Res>  {
  factory $NotificationChannelCopyWith(NotificationChannel value, $Res Function(NotificationChannel) _then) = _$NotificationChannelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, ChannelImportance importance, bool playSound, bool enableVibration, bool showBadge, String? sound, String? categoryId
});




}
/// @nodoc
class _$NotificationChannelCopyWithImpl<$Res>
    implements $NotificationChannelCopyWith<$Res> {
  _$NotificationChannelCopyWithImpl(this._self, this._then);

  final NotificationChannel _self;
  final $Res Function(NotificationChannel) _then;

/// Create a copy of NotificationChannel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? importance = null,Object? playSound = null,Object? enableVibration = null,Object? showBadge = null,Object? sound = freezed,Object? categoryId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as ChannelImportance,playSound: null == playSound ? _self.playSound : playSound // ignore: cast_nullable_to_non_nullable
as bool,enableVibration: null == enableVibration ? _self.enableVibration : enableVibration // ignore: cast_nullable_to_non_nullable
as bool,showBadge: null == showBadge ? _self.showBadge : showBadge // ignore: cast_nullable_to_non_nullable
as bool,sound: freezed == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationChannel].
extension NotificationChannelPatterns on NotificationChannel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationChannel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationChannel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationChannel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationChannel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationChannel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationChannel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  ChannelImportance importance,  bool playSound,  bool enableVibration,  bool showBadge,  String? sound,  String? categoryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationChannel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.importance,_that.playSound,_that.enableVibration,_that.showBadge,_that.sound,_that.categoryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  ChannelImportance importance,  bool playSound,  bool enableVibration,  bool showBadge,  String? sound,  String? categoryId)  $default,) {final _that = this;
switch (_that) {
case _NotificationChannel():
return $default(_that.id,_that.name,_that.description,_that.importance,_that.playSound,_that.enableVibration,_that.showBadge,_that.sound,_that.categoryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  ChannelImportance importance,  bool playSound,  bool enableVibration,  bool showBadge,  String? sound,  String? categoryId)?  $default,) {final _that = this;
switch (_that) {
case _NotificationChannel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.importance,_that.playSound,_that.enableVibration,_that.showBadge,_that.sound,_that.categoryId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationChannel implements NotificationChannel {
  const _NotificationChannel({required this.id, required this.name, this.description = '', this.importance = ChannelImportance.defaultImportance, this.playSound = true, this.enableVibration = true, this.showBadge = true, this.sound, this.categoryId});
  factory _NotificationChannel.fromJson(Map<String, dynamic> json) => _$NotificationChannelFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override@JsonKey() final  ChannelImportance importance;
@override@JsonKey() final  bool playSound;
@override@JsonKey() final  bool enableVibration;
@override@JsonKey() final  bool showBadge;
@override final  String? sound;
@override final  String? categoryId;

/// Create a copy of NotificationChannel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationChannelCopyWith<_NotificationChannel> get copyWith => __$NotificationChannelCopyWithImpl<_NotificationChannel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationChannelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationChannel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.playSound, playSound) || other.playSound == playSound)&&(identical(other.enableVibration, enableVibration) || other.enableVibration == enableVibration)&&(identical(other.showBadge, showBadge) || other.showBadge == showBadge)&&(identical(other.sound, sound) || other.sound == sound)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,importance,playSound,enableVibration,showBadge,sound,categoryId);

@override
String toString() {
  return 'NotificationChannel(id: $id, name: $name, description: $description, importance: $importance, playSound: $playSound, enableVibration: $enableVibration, showBadge: $showBadge, sound: $sound, categoryId: $categoryId)';
}


}

/// @nodoc
abstract mixin class _$NotificationChannelCopyWith<$Res> implements $NotificationChannelCopyWith<$Res> {
  factory _$NotificationChannelCopyWith(_NotificationChannel value, $Res Function(_NotificationChannel) _then) = __$NotificationChannelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, ChannelImportance importance, bool playSound, bool enableVibration, bool showBadge, String? sound, String? categoryId
});




}
/// @nodoc
class __$NotificationChannelCopyWithImpl<$Res>
    implements _$NotificationChannelCopyWith<$Res> {
  __$NotificationChannelCopyWithImpl(this._self, this._then);

  final _NotificationChannel _self;
  final $Res Function(_NotificationChannel) _then;

/// Create a copy of NotificationChannel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? importance = null,Object? playSound = null,Object? enableVibration = null,Object? showBadge = null,Object? sound = freezed,Object? categoryId = freezed,}) {
  return _then(_NotificationChannel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as ChannelImportance,playSound: null == playSound ? _self.playSound : playSound // ignore: cast_nullable_to_non_nullable
as bool,enableVibration: null == enableVibration ? _self.enableVibration : enableVibration // ignore: cast_nullable_to_non_nullable
as bool,showBadge: null == showBadge ? _self.showBadge : showBadge // ignore: cast_nullable_to_non_nullable
as bool,sound: freezed == sound ? _self.sound : sound // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
