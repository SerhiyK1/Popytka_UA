// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) {
  return _RatingModel.fromJson(json);
}

/// @nodoc
mixin _$RatingModel {
  String get id => throw _privateConstructorUsedError;
  String get rideId => throw _privateConstructorUsedError;
  String get raterId => throw _privateConstructorUsedError;
  String get ratedId => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RatingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingModelCopyWith<RatingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingModelCopyWith<$Res> {
  factory $RatingModelCopyWith(
    RatingModel value,
    $Res Function(RatingModel) then,
  ) = _$RatingModelCopyWithImpl<$Res, RatingModel>;
  @useResult
  $Res call({
    String id,
    String rideId,
    String raterId,
    String ratedId,
    double rating,
    String? comment,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RatingModelCopyWithImpl<$Res, $Val extends RatingModel>
    implements $RatingModelCopyWith<$Res> {
  _$RatingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rideId = null,
    Object? raterId = null,
    Object? ratedId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            rideId: null == rideId
                ? _value.rideId
                : rideId // ignore: cast_nullable_to_non_nullable
                      as String,
            raterId: null == raterId
                ? _value.raterId
                : raterId // ignore: cast_nullable_to_non_nullable
                      as String,
            ratedId: null == ratedId
                ? _value.ratedId
                : ratedId // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$RatingModelImplCopyWith<$Res>
    implements $RatingModelCopyWith<$Res> {
  factory _$$RatingModelImplCopyWith(
    _$RatingModelImpl value,
    $Res Function(_$RatingModelImpl) then,
  ) = __$$RatingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String rideId,
    String raterId,
    String ratedId,
    double rating,
    String? comment,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RatingModelImplCopyWithImpl<$Res>
    extends _$RatingModelCopyWithImpl<$Res, _$RatingModelImpl>
    implements _$$RatingModelImplCopyWith<$Res> {
  __$$RatingModelImplCopyWithImpl(
    _$RatingModelImpl _value,
    $Res Function(_$RatingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rideId = null,
    Object? raterId = null,
    Object? ratedId = null,
    Object? rating = null,
    Object? comment = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$RatingModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        rideId: null == rideId
            ? _value.rideId
            : rideId // ignore: cast_nullable_to_non_nullable
                  as String,
        raterId: null == raterId
            ? _value.raterId
            : raterId // ignore: cast_nullable_to_non_nullable
                  as String,
        ratedId: null == ratedId
            ? _value.ratedId
            : ratedId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$RatingModelImpl implements _RatingModel {
  const _$RatingModelImpl({
    required this.id,
    required this.rideId,
    required this.raterId,
    required this.ratedId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory _$RatingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String rideId;
  @override
  final String raterId;
  @override
  final String ratedId;
  @override
  final double rating;
  @override
  final String? comment;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RatingModel(id: $id, rideId: $rideId, raterId: $raterId, ratedId: $ratedId, rating: $rating, comment: $comment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rideId, rideId) || other.rideId == rideId) &&
            (identical(other.raterId, raterId) || other.raterId == raterId) &&
            (identical(other.ratedId, ratedId) || other.ratedId == ratedId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    rideId,
    raterId,
    ratedId,
    rating,
    comment,
    createdAt,
  );

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      __$$RatingModelImplCopyWithImpl<_$RatingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingModelImplToJson(this);
  }
}

abstract class _RatingModel implements RatingModel {
  const factory _RatingModel({
    required final String id,
    required final String rideId,
    required final String raterId,
    required final String ratedId,
    required final double rating,
    final String? comment,
    required final DateTime createdAt,
  }) = _$RatingModelImpl;

  factory _RatingModel.fromJson(Map<String, dynamic> json) =
      _$RatingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get rideId;
  @override
  String get raterId;
  @override
  String get ratedId;
  @override
  double get rating;
  @override
  String? get comment;
  @override
  DateTime get createdAt;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
