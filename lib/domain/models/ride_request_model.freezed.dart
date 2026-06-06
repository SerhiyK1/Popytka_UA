// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RideRequestModel _$RideRequestModelFromJson(Map<String, dynamic> json) {
  return _RideRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RideRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get fromCity => throw _privateConstructorUsedError;
  String get toCity => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  int get seatsRequired => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'matched', 'cancelled'
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RideRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RideRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RideRequestModelCopyWith<RideRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RideRequestModelCopyWith<$Res> {
  factory $RideRequestModelCopyWith(
    RideRequestModel value,
    $Res Function(RideRequestModel) then,
  ) = _$RideRequestModelCopyWithImpl<$Res, RideRequestModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String fromCity,
    String toCity,
    DateTime departureTime,
    int seatsRequired,
    String status,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RideRequestModelCopyWithImpl<$Res, $Val extends RideRequestModel>
    implements $RideRequestModelCopyWith<$Res> {
  _$RideRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RideRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fromCity = null,
    Object? toCity = null,
    Object? departureTime = null,
    Object? seatsRequired = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            fromCity: null == fromCity
                ? _value.fromCity
                : fromCity // ignore: cast_nullable_to_non_nullable
                      as String,
            toCity: null == toCity
                ? _value.toCity
                : toCity // ignore: cast_nullable_to_non_nullable
                      as String,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            seatsRequired: null == seatsRequired
                ? _value.seatsRequired
                : seatsRequired // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RideRequestModelImplCopyWith<$Res>
    implements $RideRequestModelCopyWith<$Res> {
  factory _$$RideRequestModelImplCopyWith(
    _$RideRequestModelImpl value,
    $Res Function(_$RideRequestModelImpl) then,
  ) = __$$RideRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String fromCity,
    String toCity,
    DateTime departureTime,
    int seatsRequired,
    String status,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RideRequestModelImplCopyWithImpl<$Res>
    extends _$RideRequestModelCopyWithImpl<$Res, _$RideRequestModelImpl>
    implements _$$RideRequestModelImplCopyWith<$Res> {
  __$$RideRequestModelImplCopyWithImpl(
    _$RideRequestModelImpl _value,
    $Res Function(_$RideRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RideRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? fromCity = null,
    Object? toCity = null,
    Object? departureTime = null,
    Object? seatsRequired = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RideRequestModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        fromCity: null == fromCity
            ? _value.fromCity
            : fromCity // ignore: cast_nullable_to_non_nullable
                  as String,
        toCity: null == toCity
            ? _value.toCity
            : toCity // ignore: cast_nullable_to_non_nullable
                  as String,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        seatsRequired: null == seatsRequired
            ? _value.seatsRequired
            : seatsRequired // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RideRequestModelImpl
    with DiagnosticableTreeMixin
    implements _RideRequestModel {
  const _$RideRequestModelImpl({
    required this.id,
    required this.userId,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.seatsRequired,
    this.status = 'pending',
    required this.createdAt,
  });

  factory _$RideRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RideRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String fromCity;
  @override
  final String toCity;
  @override
  final DateTime departureTime;
  @override
  final int seatsRequired;
  @override
  @JsonKey()
  final String status;
  // 'pending', 'matched', 'cancelled'
  @override
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RideRequestModel(id: $id, userId: $userId, fromCity: $fromCity, toCity: $toCity, departureTime: $departureTime, seatsRequired: $seatsRequired, status: $status, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RideRequestModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('fromCity', fromCity))
      ..add(DiagnosticsProperty('toCity', toCity))
      ..add(DiagnosticsProperty('departureTime', departureTime))
      ..add(DiagnosticsProperty('seatsRequired', seatsRequired))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RideRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fromCity, fromCity) ||
                other.fromCity == fromCity) &&
            (identical(other.toCity, toCity) || other.toCity == toCity) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.seatsRequired, seatsRequired) ||
                other.seatsRequired == seatsRequired) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    fromCity,
    toCity,
    departureTime,
    seatsRequired,
    status,
    createdAt,
  );

  /// Create a copy of RideRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RideRequestModelImplCopyWith<_$RideRequestModelImpl> get copyWith =>
      __$$RideRequestModelImplCopyWithImpl<_$RideRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RideRequestModelImplToJson(this);
  }
}

abstract class _RideRequestModel implements RideRequestModel {
  const factory _RideRequestModel({
    required final String id,
    required final String userId,
    required final String fromCity,
    required final String toCity,
    required final DateTime departureTime,
    required final int seatsRequired,
    final String status,
    required final DateTime createdAt,
  }) = _$RideRequestModelImpl;

  factory _RideRequestModel.fromJson(Map<String, dynamic> json) =
      _$RideRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get fromCity;
  @override
  String get toCity;
  @override
  DateTime get departureTime;
  @override
  int get seatsRequired;
  @override
  String get status; // 'pending', 'matched', 'cancelled'
  @override
  DateTime get createdAt;

  /// Create a copy of RideRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RideRequestModelImplCopyWith<_$RideRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
