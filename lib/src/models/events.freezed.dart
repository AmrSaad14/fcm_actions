// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationEvent {

 NotificationMessage get message; DateTime get timestamp; NotificationPlatform get platform; NotificationState get state; NotificationInteraction? get interaction; Map<String, Object?> get rawJson;
/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationEventCopyWith<NotificationEvent> get copyWith => _$NotificationEventCopyWithImpl<NotificationEvent>(this as NotificationEvent, _$identity);

  /// Serializes this NotificationEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.state, state) || other.state == state)&&(identical(other.interaction, interaction) || other.interaction == interaction)&&const DeepCollectionEquality().equals(other.rawJson, rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,timestamp,platform,state,interaction,const DeepCollectionEquality().hash(rawJson));

@override
String toString() {
  return 'NotificationEvent(message: $message, timestamp: $timestamp, platform: $platform, state: $state, interaction: $interaction, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class $NotificationEventCopyWith<$Res>  {
  factory $NotificationEventCopyWith(NotificationEvent value, $Res Function(NotificationEvent) _then) = _$NotificationEventCopyWithImpl;
@useResult
$Res call({
 NotificationMessage message, DateTime timestamp, NotificationPlatform platform, NotificationState state, NotificationInteraction? interaction, Map<String, Object?> rawJson
});


$NotificationMessageCopyWith<$Res> get message;

}
/// @nodoc
class _$NotificationEventCopyWithImpl<$Res>
    implements $NotificationEventCopyWith<$Res> {
  _$NotificationEventCopyWithImpl(this._self, this._then);

  final NotificationEvent _self;
  final $Res Function(NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? timestamp = null,Object? platform = null,Object? state = null,Object? interaction = freezed,Object? rawJson = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as NotificationMessage,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotificationPlatform,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NotificationState,interaction: freezed == interaction ? _self.interaction : interaction // ignore: cast_nullable_to_non_nullable
as NotificationInteraction?,rawJson: null == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res> get message {
  
  return $NotificationMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationEvent].
extension NotificationEventPatterns on NotificationEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationEvent value)  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationEvent value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NotificationMessage message,  DateTime timestamp,  NotificationPlatform platform,  NotificationState state,  NotificationInteraction? interaction,  Map<String, Object?> rawJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.message,_that.timestamp,_that.platform,_that.state,_that.interaction,_that.rawJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NotificationMessage message,  DateTime timestamp,  NotificationPlatform platform,  NotificationState state,  NotificationInteraction? interaction,  Map<String, Object?> rawJson)  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent():
return $default(_that.message,_that.timestamp,_that.platform,_that.state,_that.interaction,_that.rawJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NotificationMessage message,  DateTime timestamp,  NotificationPlatform platform,  NotificationState state,  NotificationInteraction? interaction,  Map<String, Object?> rawJson)?  $default,) {final _that = this;
switch (_that) {
case _NotificationEvent() when $default != null:
return $default(_that.message,_that.timestamp,_that.platform,_that.state,_that.interaction,_that.rawJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationEvent implements NotificationEvent {
  const _NotificationEvent({required this.message, required this.timestamp, required this.platform, required this.state, this.interaction, final  Map<String, Object?> rawJson = const <String, Object?>{}}): _rawJson = rawJson;
  factory _NotificationEvent.fromJson(Map<String, dynamic> json) => _$NotificationEventFromJson(json);

@override final  NotificationMessage message;
@override final  DateTime timestamp;
@override final  NotificationPlatform platform;
@override final  NotificationState state;
@override final  NotificationInteraction? interaction;
 final  Map<String, Object?> _rawJson;
@override@JsonKey() Map<String, Object?> get rawJson {
  if (_rawJson is EqualUnmodifiableMapView) return _rawJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rawJson);
}


/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationEventCopyWith<_NotificationEvent> get copyWith => __$NotificationEventCopyWithImpl<_NotificationEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.state, state) || other.state == state)&&(identical(other.interaction, interaction) || other.interaction == interaction)&&const DeepCollectionEquality().equals(other._rawJson, _rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,timestamp,platform,state,interaction,const DeepCollectionEquality().hash(_rawJson));

@override
String toString() {
  return 'NotificationEvent(message: $message, timestamp: $timestamp, platform: $platform, state: $state, interaction: $interaction, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class _$NotificationEventCopyWith<$Res> implements $NotificationEventCopyWith<$Res> {
  factory _$NotificationEventCopyWith(_NotificationEvent value, $Res Function(_NotificationEvent) _then) = __$NotificationEventCopyWithImpl;
@override @useResult
$Res call({
 NotificationMessage message, DateTime timestamp, NotificationPlatform platform, NotificationState state, NotificationInteraction? interaction, Map<String, Object?> rawJson
});


@override $NotificationMessageCopyWith<$Res> get message;

}
/// @nodoc
class __$NotificationEventCopyWithImpl<$Res>
    implements _$NotificationEventCopyWith<$Res> {
  __$NotificationEventCopyWithImpl(this._self, this._then);

  final _NotificationEvent _self;
  final $Res Function(_NotificationEvent) _then;

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? timestamp = null,Object? platform = null,Object? state = null,Object? interaction = freezed,Object? rawJson = null,}) {
  return _then(_NotificationEvent(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as NotificationMessage,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotificationPlatform,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NotificationState,interaction: freezed == interaction ? _self.interaction : interaction // ignore: cast_nullable_to_non_nullable
as NotificationInteraction?,rawJson: null == rawJson ? _self._rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

/// Create a copy of NotificationEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res> get message {
  
  return $NotificationMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// @nodoc
mixin _$NotificationActionEvent {

 String get actionId; int get notificationId; DateTime get timestamp; NotificationMessage get message; NotificationPlatform get platform; NotificationState get state; Map<String, Object?> get payload; Map<String, Object?> get rawJson; String? get replyText; bool get fromBackground;
/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationActionEventCopyWith<NotificationActionEvent> get copyWith => _$NotificationActionEventCopyWithImpl<NotificationActionEvent>(this as NotificationActionEvent, _$identity);

  /// Serializes this NotificationActionEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationActionEvent&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other.payload, payload)&&const DeepCollectionEquality().equals(other.rawJson, rawJson)&&(identical(other.replyText, replyText) || other.replyText == replyText)&&(identical(other.fromBackground, fromBackground) || other.fromBackground == fromBackground));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionId,notificationId,timestamp,message,platform,state,const DeepCollectionEquality().hash(payload),const DeepCollectionEquality().hash(rawJson),replyText,fromBackground);

@override
String toString() {
  return 'NotificationActionEvent(actionId: $actionId, notificationId: $notificationId, timestamp: $timestamp, message: $message, platform: $platform, state: $state, payload: $payload, rawJson: $rawJson, replyText: $replyText, fromBackground: $fromBackground)';
}


}

/// @nodoc
abstract mixin class $NotificationActionEventCopyWith<$Res>  {
  factory $NotificationActionEventCopyWith(NotificationActionEvent value, $Res Function(NotificationActionEvent) _then) = _$NotificationActionEventCopyWithImpl;
@useResult
$Res call({
 String actionId, int notificationId, DateTime timestamp, NotificationMessage message, NotificationPlatform platform, NotificationState state, Map<String, Object?> payload, Map<String, Object?> rawJson, String? replyText, bool fromBackground
});


$NotificationMessageCopyWith<$Res> get message;

}
/// @nodoc
class _$NotificationActionEventCopyWithImpl<$Res>
    implements $NotificationActionEventCopyWith<$Res> {
  _$NotificationActionEventCopyWithImpl(this._self, this._then);

  final NotificationActionEvent _self;
  final $Res Function(NotificationActionEvent) _then;

/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actionId = null,Object? notificationId = null,Object? timestamp = null,Object? message = null,Object? platform = null,Object? state = null,Object? payload = null,Object? rawJson = null,Object? replyText = freezed,Object? fromBackground = null,}) {
  return _then(_self.copyWith(
actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as NotificationMessage,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotificationPlatform,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NotificationState,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,rawJson: null == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,replyText: freezed == replyText ? _self.replyText : replyText // ignore: cast_nullable_to_non_nullable
as String?,fromBackground: null == fromBackground ? _self.fromBackground : fromBackground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res> get message {
  
  return $NotificationMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationActionEvent].
extension NotificationActionEventPatterns on NotificationActionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationActionEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationActionEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationActionEvent value)  $default,){
final _that = this;
switch (_that) {
case _NotificationActionEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationActionEvent value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationActionEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String actionId,  int notificationId,  DateTime timestamp,  NotificationMessage message,  NotificationPlatform platform,  NotificationState state,  Map<String, Object?> payload,  Map<String, Object?> rawJson,  String? replyText,  bool fromBackground)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationActionEvent() when $default != null:
return $default(_that.actionId,_that.notificationId,_that.timestamp,_that.message,_that.platform,_that.state,_that.payload,_that.rawJson,_that.replyText,_that.fromBackground);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String actionId,  int notificationId,  DateTime timestamp,  NotificationMessage message,  NotificationPlatform platform,  NotificationState state,  Map<String, Object?> payload,  Map<String, Object?> rawJson,  String? replyText,  bool fromBackground)  $default,) {final _that = this;
switch (_that) {
case _NotificationActionEvent():
return $default(_that.actionId,_that.notificationId,_that.timestamp,_that.message,_that.platform,_that.state,_that.payload,_that.rawJson,_that.replyText,_that.fromBackground);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String actionId,  int notificationId,  DateTime timestamp,  NotificationMessage message,  NotificationPlatform platform,  NotificationState state,  Map<String, Object?> payload,  Map<String, Object?> rawJson,  String? replyText,  bool fromBackground)?  $default,) {final _that = this;
switch (_that) {
case _NotificationActionEvent() when $default != null:
return $default(_that.actionId,_that.notificationId,_that.timestamp,_that.message,_that.platform,_that.state,_that.payload,_that.rawJson,_that.replyText,_that.fromBackground);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationActionEvent implements NotificationActionEvent {
  const _NotificationActionEvent({required this.actionId, required this.notificationId, required this.timestamp, required this.message, required this.platform, required this.state, final  Map<String, Object?> payload = const <String, Object?>{}, final  Map<String, Object?> rawJson = const <String, Object?>{}, this.replyText, this.fromBackground = false}): _payload = payload,_rawJson = rawJson;
  factory _NotificationActionEvent.fromJson(Map<String, dynamic> json) => _$NotificationActionEventFromJson(json);

@override final  String actionId;
@override final  int notificationId;
@override final  DateTime timestamp;
@override final  NotificationMessage message;
@override final  NotificationPlatform platform;
@override final  NotificationState state;
 final  Map<String, Object?> _payload;
@override@JsonKey() Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

 final  Map<String, Object?> _rawJson;
@override@JsonKey() Map<String, Object?> get rawJson {
  if (_rawJson is EqualUnmodifiableMapView) return _rawJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rawJson);
}

@override final  String? replyText;
@override@JsonKey() final  bool fromBackground;

/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationActionEventCopyWith<_NotificationActionEvent> get copyWith => __$NotificationActionEventCopyWithImpl<_NotificationActionEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationActionEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationActionEvent&&(identical(other.actionId, actionId) || other.actionId == actionId)&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.message, message) || other.message == message)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.state, state) || other.state == state)&&const DeepCollectionEquality().equals(other._payload, _payload)&&const DeepCollectionEquality().equals(other._rawJson, _rawJson)&&(identical(other.replyText, replyText) || other.replyText == replyText)&&(identical(other.fromBackground, fromBackground) || other.fromBackground == fromBackground));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,actionId,notificationId,timestamp,message,platform,state,const DeepCollectionEquality().hash(_payload),const DeepCollectionEquality().hash(_rawJson),replyText,fromBackground);

@override
String toString() {
  return 'NotificationActionEvent(actionId: $actionId, notificationId: $notificationId, timestamp: $timestamp, message: $message, platform: $platform, state: $state, payload: $payload, rawJson: $rawJson, replyText: $replyText, fromBackground: $fromBackground)';
}


}

/// @nodoc
abstract mixin class _$NotificationActionEventCopyWith<$Res> implements $NotificationActionEventCopyWith<$Res> {
  factory _$NotificationActionEventCopyWith(_NotificationActionEvent value, $Res Function(_NotificationActionEvent) _then) = __$NotificationActionEventCopyWithImpl;
@override @useResult
$Res call({
 String actionId, int notificationId, DateTime timestamp, NotificationMessage message, NotificationPlatform platform, NotificationState state, Map<String, Object?> payload, Map<String, Object?> rawJson, String? replyText, bool fromBackground
});


@override $NotificationMessageCopyWith<$Res> get message;

}
/// @nodoc
class __$NotificationActionEventCopyWithImpl<$Res>
    implements _$NotificationActionEventCopyWith<$Res> {
  __$NotificationActionEventCopyWithImpl(this._self, this._then);

  final _NotificationActionEvent _self;
  final $Res Function(_NotificationActionEvent) _then;

/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actionId = null,Object? notificationId = null,Object? timestamp = null,Object? message = null,Object? platform = null,Object? state = null,Object? payload = null,Object? rawJson = null,Object? replyText = freezed,Object? fromBackground = null,}) {
  return _then(_NotificationActionEvent(
actionId: null == actionId ? _self.actionId : actionId // ignore: cast_nullable_to_non_nullable
as String,notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as NotificationMessage,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as NotificationPlatform,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as NotificationState,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,rawJson: null == rawJson ? _self._rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,replyText: freezed == replyText ? _self.replyText : replyText // ignore: cast_nullable_to_non_nullable
as String?,fromBackground: null == fromBackground ? _self.fromBackground : fromBackground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of NotificationActionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<$Res> get message {
  
  return $NotificationMessageCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}

// dart format on
