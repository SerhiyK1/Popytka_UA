// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatisticsModel {
  int get totalRidesPublished => throw _privateConstructorUsedError;
  int get totalRidesAsPassenger => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  double get totalEarned => throw _privateConstructorUsedError;
  int get passengersCarried => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsModelCopyWith<StatisticsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsModelCopyWith<$Res> {
  factory $StatisticsModelCopyWith(
    StatisticsModel value,
    $Res Function(StatisticsModel) then,
  ) = _$StatisticsModelCopyWithImpl<$Res, StatisticsModel>;
  @useResult
  $Res call({
    int totalRidesPublished,
    int totalRidesAsPassenger,
    double totalSpent,
    double totalEarned,
    int passengersCarried,
  });
}

/// @nodoc
class _$StatisticsModelCopyWithImpl<$Res, $Val extends StatisticsModel>
    implements $StatisticsModelCopyWith<$Res> {
  _$StatisticsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRidesPublished = null,
    Object? totalRidesAsPassenger = null,
    Object? totalSpent = null,
    Object? totalEarned = null,
    Object? passengersCarried = null,
  }) {
    return _then(
      _value.copyWith(
            totalRidesPublished: null == totalRidesPublished
                ? _value.totalRidesPublished
                : totalRidesPublished // ignore: cast_nullable_to_non_nullable
                      as int,
            totalRidesAsPassenger: null == totalRidesAsPassenger
                ? _value.totalRidesAsPassenger
                : totalRidesAsPassenger // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double,
            totalEarned: null == totalEarned
                ? _value.totalEarned
                : totalEarned // ignore: cast_nullable_to_non_nullable
                      as double,
            passengersCarried: null == passengersCarried
                ? _value.passengersCarried
                : passengersCarried // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StatisticsModelImplCopyWith<$Res>
    implements $StatisticsModelCopyWith<$Res> {
  factory _$$StatisticsModelImplCopyWith(
    _$StatisticsModelImpl value,
    $Res Function(_$StatisticsModelImpl) then,
  ) = __$$StatisticsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalRidesPublished,
    int totalRidesAsPassenger,
    double totalSpent,
    double totalEarned,
    int passengersCarried,
  });
}

/// @nodoc
class __$$StatisticsModelImplCopyWithImpl<$Res>
    extends _$StatisticsModelCopyWithImpl<$Res, _$StatisticsModelImpl>
    implements _$$StatisticsModelImplCopyWith<$Res> {
  __$$StatisticsModelImplCopyWithImpl(
    _$StatisticsModelImpl _value,
    $Res Function(_$StatisticsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRidesPublished = null,
    Object? totalRidesAsPassenger = null,
    Object? totalSpent = null,
    Object? totalEarned = null,
    Object? passengersCarried = null,
  }) {
    return _then(
      _$StatisticsModelImpl(
        totalRidesPublished: null == totalRidesPublished
            ? _value.totalRidesPublished
            : totalRidesPublished // ignore: cast_nullable_to_non_nullable
                  as int,
        totalRidesAsPassenger: null == totalRidesAsPassenger
            ? _value.totalRidesAsPassenger
            : totalRidesAsPassenger // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double,
        totalEarned: null == totalEarned
            ? _value.totalEarned
            : totalEarned // ignore: cast_nullable_to_non_nullable
                  as double,
        passengersCarried: null == passengersCarried
            ? _value.passengersCarried
            : passengersCarried // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$StatisticsModelImpl implements _StatisticsModel {
  const _$StatisticsModelImpl({
    this.totalRidesPublished = 0,
    this.totalRidesAsPassenger = 0,
    this.totalSpent = 0.0,
    this.totalEarned = 0.0,
    this.passengersCarried = 0,
  });

  @override
  @JsonKey()
  final int totalRidesPublished;
  @override
  @JsonKey()
  final int totalRidesAsPassenger;
  @override
  @JsonKey()
  final double totalSpent;
  @override
  @JsonKey()
  final double totalEarned;
  @override
  @JsonKey()
  final int passengersCarried;

  @override
  String toString() {
    return 'StatisticsModel(totalRidesPublished: $totalRidesPublished, totalRidesAsPassenger: $totalRidesAsPassenger, totalSpent: $totalSpent, totalEarned: $totalEarned, passengersCarried: $passengersCarried)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsModelImpl &&
            (identical(other.totalRidesPublished, totalRidesPublished) ||
                other.totalRidesPublished == totalRidesPublished) &&
            (identical(other.totalRidesAsPassenger, totalRidesAsPassenger) ||
                other.totalRidesAsPassenger == totalRidesAsPassenger) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalEarned, totalEarned) ||
                other.totalEarned == totalEarned) &&
            (identical(other.passengersCarried, passengersCarried) ||
                other.passengersCarried == passengersCarried));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRidesPublished,
    totalRidesAsPassenger,
    totalSpent,
    totalEarned,
    passengersCarried,
  );

  /// Create a copy of StatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsModelImplCopyWith<_$StatisticsModelImpl> get copyWith =>
      __$$StatisticsModelImplCopyWithImpl<_$StatisticsModelImpl>(
        this,
        _$identity,
      );
}

abstract class _StatisticsModel implements StatisticsModel {
  const factory _StatisticsModel({
    final int totalRidesPublished,
    final int totalRidesAsPassenger,
    final double totalSpent,
    final double totalEarned,
    final int passengersCarried,
  }) = _$StatisticsModelImpl;

  @override
  int get totalRidesPublished;
  @override
  int get totalRidesAsPassenger;
  @override
  double get totalSpent;
  @override
  double get totalEarned;
  @override
  int get passengersCarried;

  /// Create a copy of StatisticsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsModelImplCopyWith<_$StatisticsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
