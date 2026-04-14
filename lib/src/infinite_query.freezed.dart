// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infinite_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InfiniteQueryResponse<T> {

 List<T> get data;
/// Create a copy of InfiniteQueryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfiniteQueryResponseCopyWith<T, InfiniteQueryResponse<T>> get copyWith => _$InfiniteQueryResponseCopyWithImpl<T, InfiniteQueryResponse<T>>(this as InfiniteQueryResponse<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfiniteQueryResponse<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'InfiniteQueryResponse<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class $InfiniteQueryResponseCopyWith<T,$Res>  {
  factory $InfiniteQueryResponseCopyWith(InfiniteQueryResponse<T> value, $Res Function(InfiniteQueryResponse<T>) _then) = _$InfiniteQueryResponseCopyWithImpl;
@useResult
$Res call({
 List<T> data
});




}
/// @nodoc
class _$InfiniteQueryResponseCopyWithImpl<T,$Res>
    implements $InfiniteQueryResponseCopyWith<T, $Res> {
  _$InfiniteQueryResponseCopyWithImpl(this._self, this._then);

  final InfiniteQueryResponse<T> _self;
  final $Res Function(InfiniteQueryResponse<T>) _then;

/// Create a copy of InfiniteQueryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}

}


/// Adds pattern-matching-related methods to [InfiniteQueryResponse].
extension InfiniteQueryResponsePatterns<T> on InfiniteQueryResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InfiniteQueryResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InfiniteQueryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InfiniteQueryResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _InfiniteQueryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InfiniteQueryResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _InfiniteQueryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfiniteQueryResponse() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> data)  $default,) {final _that = this;
switch (_that) {
case _InfiniteQueryResponse():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> data)?  $default,) {final _that = this;
switch (_that) {
case _InfiniteQueryResponse() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _InfiniteQueryResponse<T> implements InfiniteQueryResponse<T> {
  const _InfiniteQueryResponse(final  List<T> data): _data = data;
  

 final  List<T> _data;
@override List<T> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of InfiniteQueryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfiniteQueryResponseCopyWith<T, _InfiniteQueryResponse<T>> get copyWith => __$InfiniteQueryResponseCopyWithImpl<T, _InfiniteQueryResponse<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfiniteQueryResponse<T>&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'InfiniteQueryResponse<$T>(data: $data)';
}


}

/// @nodoc
abstract mixin class _$InfiniteQueryResponseCopyWith<T,$Res> implements $InfiniteQueryResponseCopyWith<T, $Res> {
  factory _$InfiniteQueryResponseCopyWith(_InfiniteQueryResponse<T> value, $Res Function(_InfiniteQueryResponse<T>) _then) = __$InfiniteQueryResponseCopyWithImpl;
@override @useResult
$Res call({
 List<T> data
});




}
/// @nodoc
class __$InfiniteQueryResponseCopyWithImpl<T,$Res>
    implements _$InfiniteQueryResponseCopyWith<T, $Res> {
  __$InfiniteQueryResponseCopyWithImpl(this._self, this._then);

  final _InfiniteQueryResponse<T> _self;
  final $Res Function(_InfiniteQueryResponse<T>) _then;

/// Create a copy of InfiniteQueryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_InfiniteQueryResponse<T>(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<T>,
  ));
}


}

/// @nodoc
mixin _$InfiniteQueryRequest<Req> {

 List<Req> get payload;
/// Create a copy of InfiniteQueryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfiniteQueryRequestCopyWith<Req, InfiniteQueryRequest<Req>> get copyWith => _$InfiniteQueryRequestCopyWithImpl<Req, InfiniteQueryRequest<Req>>(this as InfiniteQueryRequest<Req>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfiniteQueryRequest<Req>&&const DeepCollectionEquality().equals(other.payload, payload));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'InfiniteQueryRequest<$Req>(payload: $payload)';
}


}

/// @nodoc
abstract mixin class $InfiniteQueryRequestCopyWith<Req,$Res>  {
  factory $InfiniteQueryRequestCopyWith(InfiniteQueryRequest<Req> value, $Res Function(InfiniteQueryRequest<Req>) _then) = _$InfiniteQueryRequestCopyWithImpl;
@useResult
$Res call({
 List<Req> payload
});




}
/// @nodoc
class _$InfiniteQueryRequestCopyWithImpl<Req,$Res>
    implements $InfiniteQueryRequestCopyWith<Req, $Res> {
  _$InfiniteQueryRequestCopyWithImpl(this._self, this._then);

  final InfiniteQueryRequest<Req> _self;
  final $Res Function(InfiniteQueryRequest<Req>) _then;

/// Create a copy of InfiniteQueryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payload = null,}) {
  return _then(_self.copyWith(
payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as List<Req>,
  ));
}

}


/// Adds pattern-matching-related methods to [InfiniteQueryRequest].
extension InfiniteQueryRequestPatterns<Req> on InfiniteQueryRequest<Req> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InfiniteQueryRequest<Req> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InfiniteQueryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InfiniteQueryRequest<Req> value)  $default,){
final _that = this;
switch (_that) {
case _InfiniteQueryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InfiniteQueryRequest<Req> value)?  $default,){
final _that = this;
switch (_that) {
case _InfiniteQueryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Req> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfiniteQueryRequest() when $default != null:
return $default(_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Req> payload)  $default,) {final _that = this;
switch (_that) {
case _InfiniteQueryRequest():
return $default(_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Req> payload)?  $default,) {final _that = this;
switch (_that) {
case _InfiniteQueryRequest() when $default != null:
return $default(_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class _InfiniteQueryRequest<Req> implements InfiniteQueryRequest<Req> {
  const _InfiniteQueryRequest(final  List<Req> payload): _payload = payload;
  

 final  List<Req> _payload;
@override List<Req> get payload {
  if (_payload is EqualUnmodifiableListView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payload);
}


/// Create a copy of InfiniteQueryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfiniteQueryRequestCopyWith<Req, _InfiniteQueryRequest<Req>> get copyWith => __$InfiniteQueryRequestCopyWithImpl<Req, _InfiniteQueryRequest<Req>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfiniteQueryRequest<Req>&&const DeepCollectionEquality().equals(other._payload, _payload));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'InfiniteQueryRequest<$Req>(payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$InfiniteQueryRequestCopyWith<Req,$Res> implements $InfiniteQueryRequestCopyWith<Req, $Res> {
  factory _$InfiniteQueryRequestCopyWith(_InfiniteQueryRequest<Req> value, $Res Function(_InfiniteQueryRequest<Req>) _then) = __$InfiniteQueryRequestCopyWithImpl;
@override @useResult
$Res call({
 List<Req> payload
});




}
/// @nodoc
class __$InfiniteQueryRequestCopyWithImpl<Req,$Res>
    implements _$InfiniteQueryRequestCopyWith<Req, $Res> {
  __$InfiniteQueryRequestCopyWithImpl(this._self, this._then);

  final _InfiniteQueryRequest<Req> _self;
  final $Res Function(_InfiniteQueryRequest<Req>) _then;

/// Create a copy of InfiniteQueryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payload = null,}) {
  return _then(_InfiniteQueryRequest<Req>(
null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as List<Req>,
  ));
}


}

// dart format on
