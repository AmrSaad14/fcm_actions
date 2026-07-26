// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationMessage {

 int get notificationId; String get messageId; String? get title; String? get body; String? get imageUrl; Map<String, Object?> get data; List<NotificationAction> get actions; String get channelId; String? get categoryId; String? get routeType; String? get deepLink; DateTime? get sentAt; String? get topic; String? get collapseKey; bool get silent; Map<String, Object?> get rawJson;
/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationMessageCopyWith<NotificationMessage> get copyWith => _$NotificationMessageCopyWithImpl<NotificationMessage>(this as NotificationMessage, _$identity);

  /// Serializes this NotificationMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationMessage&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.routeType, routeType) || other.routeType == routeType)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.collapseKey, collapseKey) || other.collapseKey == collapseKey)&&(identical(other.silent, silent) || other.silent == silent)&&const DeepCollectionEquality().equals(other.rawJson, rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,messageId,title,body,imageUrl,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(actions),channelId,categoryId,routeType,deepLink,sentAt,topic,collapseKey,silent,const DeepCollectionEquality().hash(rawJson));

@override
String toString() {
  return 'NotificationMessage(notificationId: $notificationId, messageId: $messageId, title: $title, body: $body, imageUrl: $imageUrl, data: $data, actions: $actions, channelId: $channelId, categoryId: $categoryId, routeType: $routeType, deepLink: $deepLink, sentAt: $sentAt, topic: $topic, collapseKey: $collapseKey, silent: $silent, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class $NotificationMessageCopyWith<$Res>  {
  factory $NotificationMessageCopyWith(NotificationMessage value, $Res Function(NotificationMessage) _then) = _$NotificationMessageCopyWithImpl;
@useResult
$Res call({
 int notificationId, String messageId, String? title, String? body, String? imageUrl, Map<String, Object?> data, List<NotificationAction> actions, String channelId, String? categoryId, String? routeType, String? deepLink, DateTime? sentAt, String? topic, String? collapseKey, bool silent, Map<String, Object?> rawJson
});




}
/// @nodoc
class _$NotificationMessageCopyWithImpl<$Res>
    implements $NotificationMessageCopyWith<$Res> {
  _$NotificationMessageCopyWithImpl(this._self, this._then);

  final NotificationMessage _self;
  final $Res Function(NotificationMessage) _then;

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationId = null,Object? messageId = null,Object? title = freezed,Object? body = freezed,Object? imageUrl = freezed,Object? data = null,Object? actions = null,Object? channelId = null,Object? categoryId = freezed,Object? routeType = freezed,Object? deepLink = freezed,Object? sentAt = freezed,Object? topic = freezed,Object? collapseKey = freezed,Object? silent = null,Object? rawJson = null,}) {
  return _then(_self.copyWith(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<NotificationAction>,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,routeType: freezed == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,collapseKey: freezed == collapseKey ? _self.collapseKey : collapseKey // ignore: cast_nullable_to_non_nullable
as String?,silent: null == silent ? _self.silent : silent // ignore: cast_nullable_to_non_nullable
as bool,rawJson: null == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationMessage].
extension NotificationMessagePatterns on NotificationMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationMessage value)  $default,){
final _that = this;
switch (_that) {
case _NotificationMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationMessage value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int notificationId,  String messageId,  String? title,  String? body,  String? imageUrl,  Map<String, Object?> data,  List<NotificationAction> actions,  String channelId,  String? categoryId,  String? routeType,  String? deepLink,  DateTime? sentAt,  String? topic,  String? collapseKey,  bool silent,  Map<String, Object?> rawJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
return $default(_that.notificationId,_that.messageId,_that.title,_that.body,_that.imageUrl,_that.data,_that.actions,_that.channelId,_that.categoryId,_that.routeType,_that.deepLink,_that.sentAt,_that.topic,_that.collapseKey,_that.silent,_that.rawJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int notificationId,  String messageId,  String? title,  String? body,  String? imageUrl,  Map<String, Object?> data,  List<NotificationAction> actions,  String channelId,  String? categoryId,  String? routeType,  String? deepLink,  DateTime? sentAt,  String? topic,  String? collapseKey,  bool silent,  Map<String, Object?> rawJson)  $default,) {final _that = this;
switch (_that) {
case _NotificationMessage():
return $default(_that.notificationId,_that.messageId,_that.title,_that.body,_that.imageUrl,_that.data,_that.actions,_that.channelId,_that.categoryId,_that.routeType,_that.deepLink,_that.sentAt,_that.topic,_that.collapseKey,_that.silent,_that.rawJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int notificationId,  String messageId,  String? title,  String? body,  String? imageUrl,  Map<String, Object?> data,  List<NotificationAction> actions,  String channelId,  String? categoryId,  String? routeType,  String? deepLink,  DateTime? sentAt,  String? topic,  String? collapseKey,  bool silent,  Map<String, Object?> rawJson)?  $default,) {final _that = this;
switch (_that) {
case _NotificationMessage() when $default != null:
return $default(_that.notificationId,_that.messageId,_that.title,_that.body,_that.imageUrl,_that.data,_that.actions,_that.channelId,_that.categoryId,_that.routeType,_that.deepLink,_that.sentAt,_that.topic,_that.collapseKey,_that.silent,_that.rawJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationMessage implements NotificationMessage {
  const _NotificationMessage({required this.notificationId, required this.messageId, this.title, this.body, this.imageUrl, final  Map<String, Object?> data = const <String, Object?>{}, final  List<NotificationAction> actions = const <NotificationAction>[], this.channelId = 'fcm_actions_default', this.categoryId, this.routeType, this.deepLink, this.sentAt, this.topic, this.collapseKey, this.silent = false, final  Map<String, Object?> rawJson = const <String, Object?>{}}): _data = data,_actions = actions,_rawJson = rawJson;
  factory _NotificationMessage.fromJson(Map<String, dynamic> json) => _$NotificationMessageFromJson(json);

@override final  int notificationId;
@override final  String messageId;
@override final  String? title;
@override final  String? body;
@override final  String? imageUrl;
 final  Map<String, Object?> _data;
@override@JsonKey() Map<String, Object?> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

 final  List<NotificationAction> _actions;
@override@JsonKey() List<NotificationAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

@override@JsonKey() final  String channelId;
@override final  String? categoryId;
@override final  String? routeType;
@override final  String? deepLink;
@override final  DateTime? sentAt;
@override final  String? topic;
@override final  String? collapseKey;
@override@JsonKey() final  bool silent;
 final  Map<String, Object?> _rawJson;
@override@JsonKey() Map<String, Object?> get rawJson {
  if (_rawJson is EqualUnmodifiableMapView) return _rawJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rawJson);
}


/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationMessageCopyWith<_NotificationMessage> get copyWith => __$NotificationMessageCopyWithImpl<_NotificationMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationMessage&&(identical(other.notificationId, notificationId) || other.notificationId == notificationId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._data, _data)&&const DeepCollectionEquality().equals(other._actions, _actions)&&(identical(other.channelId, channelId) || other.channelId == channelId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.routeType, routeType) || other.routeType == routeType)&&(identical(other.deepLink, deepLink) || other.deepLink == deepLink)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.collapseKey, collapseKey) || other.collapseKey == collapseKey)&&(identical(other.silent, silent) || other.silent == silent)&&const DeepCollectionEquality().equals(other._rawJson, _rawJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationId,messageId,title,body,imageUrl,const DeepCollectionEquality().hash(_data),const DeepCollectionEquality().hash(_actions),channelId,categoryId,routeType,deepLink,sentAt,topic,collapseKey,silent,const DeepCollectionEquality().hash(_rawJson));

@override
String toString() {
  return 'NotificationMessage(notificationId: $notificationId, messageId: $messageId, title: $title, body: $body, imageUrl: $imageUrl, data: $data, actions: $actions, channelId: $channelId, categoryId: $categoryId, routeType: $routeType, deepLink: $deepLink, sentAt: $sentAt, topic: $topic, collapseKey: $collapseKey, silent: $silent, rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class _$NotificationMessageCopyWith<$Res> implements $NotificationMessageCopyWith<$Res> {
  factory _$NotificationMessageCopyWith(_NotificationMessage value, $Res Function(_NotificationMessage) _then) = __$NotificationMessageCopyWithImpl;
@override @useResult
$Res call({
 int notificationId, String messageId, String? title, String? body, String? imageUrl, Map<String, Object?> data, List<NotificationAction> actions, String channelId, String? categoryId, String? routeType, String? deepLink, DateTime? sentAt, String? topic, String? collapseKey, bool silent, Map<String, Object?> rawJson
});




}
/// @nodoc
class __$NotificationMessageCopyWithImpl<$Res>
    implements _$NotificationMessageCopyWith<$Res> {
  __$NotificationMessageCopyWithImpl(this._self, this._then);

  final _NotificationMessage _self;
  final $Res Function(_NotificationMessage) _then;

/// Create a copy of NotificationMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationId = null,Object? messageId = null,Object? title = freezed,Object? body = freezed,Object? imageUrl = freezed,Object? data = null,Object? actions = null,Object? channelId = null,Object? categoryId = freezed,Object? routeType = freezed,Object? deepLink = freezed,Object? sentAt = freezed,Object? topic = freezed,Object? collapseKey = freezed,Object? silent = null,Object? rawJson = null,}) {
  return _then(_NotificationMessage(
notificationId: null == notificationId ? _self.notificationId : notificationId // ignore: cast_nullable_to_non_nullable
as int,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<NotificationAction>,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,routeType: freezed == routeType ? _self.routeType : routeType // ignore: cast_nullable_to_non_nullable
as String?,deepLink: freezed == deepLink ? _self.deepLink : deepLink // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,collapseKey: freezed == collapseKey ? _self.collapseKey : collapseKey // ignore: cast_nullable_to_non_nullable
as String?,silent: null == silent ? _self.silent : silent // ignore: cast_nullable_to_non_nullable
as bool,rawJson: null == rawJson ? _self._rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
