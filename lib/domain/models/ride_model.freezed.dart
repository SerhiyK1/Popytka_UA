// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ride_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RideModel _$RideModelFromJson(Map<String, dynamic> json) {
  return _RideModel.fromJson(json);
}

/// @nodoc
mixin _$RideModel {
  String get id => throw _privateConstructorUsedError;
  String get riderId => throw _privateConstructorUsedError;
  String? get driverId => throw _privateConstructorUsedError;
  String? get carId => throw _privateConstructorUsedError;
  LocationModel get fromLocation => throw _privateConstructorUsedError;
  LocationModel get toLocation => throw _privateConstructorUsedError;
  List<LocationModel> get waypoints => throw _privateConstructorUsedError;
  List<LatLng> get routePoints =>
      throw _privateConstructorUsedError; // Full road geometry
  String get status => throw _privateConstructorUsedError;
  double get pricePerSeat => throw _privateConstructorUsedError;
  int get seatsAvailable => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RideModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RideModelCopyWith<RideModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RideModelCopyWith<$Res> {
  factory $RideModelCopyWith(RideModel value, $Res Function(RideModel) then) =
      _$RideModelCopyWithImpl<$Res, RideModel>;
  @useResult
  $Res call({
    String id,
    String riderId,
    String? driverId,
    String? carId,
    LocationModel fromLocation,
    LocationModel toLocation,
    List<LocationModel> waypoints,
    List<LatLng> routePoints,
    String status,
    double pricePerSeat,
    int seatsAvailable,
    DateTime departureTime,
    DateTime createdAt,
  });

  $LocationModelCopyWith<$Res> get fromLocation;
  $LocationModelCopyWith<$Res> get toLocation;
}

/// @nodoc
class _$RideModelCopyWithImpl<$Res, $Val extends RideModel>
    implements $RideModelCopyWith<$Res> {
  _$RideModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? riderId = null,
    Object? driverId = freezed,
    Object? carId = freezed,
    Object? fromLocation = null,
    Object? toLocation = null,
    Object? waypoints = null,
    Object? routePoints = null,
    Object? status = null,
    Object? pricePerSeat = null,
    Object? seatsAvailable = null,
    Object? departureTime = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            riderId: null == riderId
                ? _value.riderId
                : riderId // ignore: cast_nullable_to_non_nullable
                      as String,
            driverId: freezed == driverId
                ? _value.driverId
                : driverId // ignore: cast_nullable_to_non_nullable
                      as String?,
            carId: freezed == carId
                ? _value.carId
                : carId // ignore: cast_nullable_to_non_nullable
                      as String?,
            fromLocation: null == fromLocation
                ? _value.fromLocation
                : fromLocation // ignore: cast_nullable_to_non_nullable
                      as LocationModel,
            toLocation: null == toLocation
                ? _value.toLocation
                : toLocation // ignore: cast_nullable_to_non_nullable
                      as LocationModel,
            waypoints: null == waypoints
                ? _value.waypoints
                : waypoints // ignore: cast_nullable_to_non_nullable
                      as List<LocationModel>,
            routePoints: null == routePoints
                ? _value.routePoints
                : routePoints // ignore: cast_nullable_to_non_nullable
                      as List<LatLng>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            pricePerSeat: null == pricePerSeat
                ? _value.pricePerSeat
                : pricePerSeat // ignore: cast_nullable_to_non_nullable
                      as double,
            seatsAvailable: null == seatsAvailable
                ? _value.seatsAvailable
                : seatsAvailable // ignore: cast_nullable_to_non_nullable
                      as int,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res> get fromLocation {
    return $LocationModelCopyWith<$Res>(_value.fromLocation, (value) {
      return _then(_value.copyWith(fromLocation: value) as $Val);
    });
  }

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res> get toLocation {
    return $LocationModelCopyWith<$Res>(_value.toLocation, (value) {
      return _then(_value.copyWith(toLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RideModelImplCopyWith<$Res>
    implements $RideModelCopyWith<$Res> {
  factory _$$RideModelImplCopyWith(
    _$RideModelImpl value,
    $Res Function(_$RideModelImpl) then,
  ) = __$$RideModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String riderId,
    String? driverId,
    String? carId,
    LocationModel fromLocation,
    LocationModel toLocation,
    List<LocationModel> waypoints,
    List<LatLng> routePoints,
    String status,
    double pricePerSeat,
    int seatsAvailable,
    DateTime departureTime,
    DateTime createdAt,
  });

  @override
  $LocationModelCopyWith<$Res> get fromLocation;
  @override
  $LocationModelCopyWith<$Res> get toLocation;
}

/// @nodoc
class __$$RideModelImplCopyWithImpl<$Res>
    extends _$RideModelCopyWithImpl<$Res, _$RideModelImpl>
    implements _$$RideModelImplCopyWith<$Res> {
  __$$RideModelImplCopyWithImpl(
    _$RideModelImpl _value,
    $Res Function(_$RideModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? riderId = null,
    Object? driverId = freezed,
    Object? carId = freezed,
    Object? fromLocation = null,
    Object? toLocation = null,
    Object? waypoints = null,
    Object? routePoints = null,
    Object? status = null,
    Object? pricePerSeat = null,
    Object? seatsAvailable = null,
    Object? departureTime = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RideModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        riderId: null == riderId
            ? _value.riderId
            : riderId // ignore: cast_nullable_to_non_nullable
                  as String,
        driverId: freezed == driverId
            ? _value.driverId
            : driverId // ignore: cast_nullable_to_non_nullable
                  as String?,
        carId: freezed == carId
            ? _value.carId
            : carId // ignore: cast_nullable_to_non_nullable
                  as String?,
        fromLocation: null == fromLocation
            ? _value.fromLocation
            : fromLocation // ignore: cast_nullable_to_non_nullable
                  as LocationModel,
        toLocation: null == toLocation
            ? _value.toLocation
            : toLocation // ignore: cast_nullable_to_non_nullable
                  as LocationModel,
        waypoints: null == waypoints
            ? _value._waypoints
            : waypoints // ignore: cast_nullable_to_non_nullable
                  as List<LocationModel>,
        routePoints: null == routePoints
            ? _value._routePoints
            : routePoints // ignore: cast_nullable_to_non_nullable
                  as List<LatLng>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        pricePerSeat: null == pricePerSeat
            ? _value.pricePerSeat
            : pricePerSeat // ignore: cast_nullable_to_non_nullable
                  as double,
        seatsAvailable: null == seatsAvailable
            ? _value.seatsAvailable
            : seatsAvailable // ignore: cast_nullable_to_non_nullable
                  as int,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
class _$RideModelImpl with DiagnosticableTreeMixin implements _RideModel {
  const _$RideModelImpl({
    required this.id,
    required this.riderId,
    this.driverId,
    this.carId,
    required this.fromLocation,
    required this.toLocation,
    final List<LocationModel> waypoints = const [],
    final List<LatLng> routePoints = const [],
    this.status = 'pending',
    required this.pricePerSeat,
    required this.seatsAvailable,
    required this.departureTime,
    required this.createdAt,
  }) : _waypoints = waypoints,
       _routePoints = routePoints;

  factory _$RideModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RideModelImplFromJson(json);

  @override
  final String id;
  @override
  final String riderId;
  @override
  final String? driverId;
  @override
  final String? carId;
  @override
  final LocationModel fromLocation;
  @override
  final LocationModel toLocation;
  final List<LocationModel> _waypoints;
  @override
  @JsonKey()
  List<LocationModel> get waypoints {
    if (_waypoints is EqualUnmodifiableListView) return _waypoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_waypoints);
  }

  final List<LatLng> _routePoints;
  @override
  @JsonKey()
  List<LatLng> get routePoints {
    if (_routePoints is EqualUnmodifiableListView) return _routePoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routePoints);
  }

  // Full road geometry
  @override
  @JsonKey()
  final String status;
  @override
  final double pricePerSeat;
  @override
  final int seatsAvailable;
  @override
  final DateTime departureTime;
  @override
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RideModel(id: $id, riderId: $riderId, driverId: $driverId, carId: $carId, fromLocation: $fromLocation, toLocation: $toLocation, waypoints: $waypoints, routePoints: $routePoints, status: $status, pricePerSeat: $pricePerSeat, seatsAvailable: $seatsAvailable, departureTime: $departureTime, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RideModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('riderId', riderId))
      ..add(DiagnosticsProperty('driverId', driverId))
      ..add(DiagnosticsProperty('carId', carId))
      ..add(DiagnosticsProperty('fromLocation', fromLocation))
      ..add(DiagnosticsProperty('toLocation', toLocation))
      ..add(DiagnosticsProperty('waypoints', waypoints))
      ..add(DiagnosticsProperty('routePoints', routePoints))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('pricePerSeat', pricePerSeat))
      ..add(DiagnosticsProperty('seatsAvailable', seatsAvailable))
      ..add(DiagnosticsProperty('departureTime', departureTime))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RideModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.riderId, riderId) || other.riderId == riderId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.fromLocation, fromLocation) ||
                other.fromLocation == fromLocation) &&
            (identical(other.toLocation, toLocation) ||
                other.toLocation == toLocation) &&
            const DeepCollectionEquality().equals(
              other._waypoints,
              _waypoints,
            ) &&
            const DeepCollectionEquality().equals(
              other._routePoints,
              _routePoints,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.seatsAvailable, seatsAvailable) ||
                other.seatsAvailable == seatsAvailable) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    riderId,
    driverId,
    carId,
    fromLocation,
    toLocation,
    const DeepCollectionEquality().hash(_waypoints),
    const DeepCollectionEquality().hash(_routePoints),
    status,
    pricePerSeat,
    seatsAvailable,
    departureTime,
    createdAt,
  );

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RideModelImplCopyWith<_$RideModelImpl> get copyWith =>
      __$$RideModelImplCopyWithImpl<_$RideModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RideModelImplToJson(this);
  }
}

abstract class _RideModel implements RideModel {
  const factory _RideModel({
    required final String id,
    required final String riderId,
    final String? driverId,
    final String? carId,
    required final LocationModel fromLocation,
    required final LocationModel toLocation,
    final List<LocationModel> waypoints,
    final List<LatLng> routePoints,
    final String status,
    required final double pricePerSeat,
    required final int seatsAvailable,
    required final DateTime departureTime,
    required final DateTime createdAt,
  }) = _$RideModelImpl;

  factory _RideModel.fromJson(Map<String, dynamic> json) =
      _$RideModelImpl.fromJson;

  @override
  String get id;
  @override
  String get riderId;
  @override
  String? get driverId;
  @override
  String? get carId;
  @override
  LocationModel get fromLocation;
  @override
  LocationModel get toLocation;
  @override
  List<LocationModel> get waypoints;
  @override
  List<LatLng> get routePoints; // Full road geometry
  @override
  String get status;
  @override
  double get pricePerSeat;
  @override
  int get seatsAvailable;
  @override
  DateTime get departureTime;
  @override
  DateTime get createdAt;

  /// Create a copy of RideModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RideModelImplCopyWith<_$RideModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
