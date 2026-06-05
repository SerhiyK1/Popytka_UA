// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CarModel _$CarModelFromJson(Map<String, dynamic> json) {
  return _CarModel.fromJson(json);
}

/// @nodoc
mixin _$CarModel {
  String get id => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  String get year => throw _privateConstructorUsedError;
  String get plate => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;

  /// Serializes this CarModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarModelCopyWith<CarModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarModelCopyWith<$Res> {
  factory $CarModelCopyWith(CarModel value, $Res Function(CarModel) then) =
      _$CarModelCopyWithImpl<$Res, CarModel>;
  @useResult
  $Res call({
    String id,
    String brand,
    String model,
    String year,
    String plate,
    String color,
    List<String> photos,
  });
}

/// @nodoc
class _$CarModelCopyWithImpl<$Res, $Val extends CarModel>
    implements $CarModelCopyWith<$Res> {
  _$CarModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? year = null,
    Object? plate = null,
    Object? color = null,
    Object? photos = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            brand: null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String,
            model: null == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                      as String,
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as String,
            plate: null == plate
                ? _value.plate
                : plate // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CarModelImplCopyWith<$Res>
    implements $CarModelCopyWith<$Res> {
  factory _$$CarModelImplCopyWith(
    _$CarModelImpl value,
    $Res Function(_$CarModelImpl) then,
  ) = __$$CarModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String brand,
    String model,
    String year,
    String plate,
    String color,
    List<String> photos,
  });
}

/// @nodoc
class __$$CarModelImplCopyWithImpl<$Res>
    extends _$CarModelCopyWithImpl<$Res, _$CarModelImpl>
    implements _$$CarModelImplCopyWith<$Res> {
  __$$CarModelImplCopyWithImpl(
    _$CarModelImpl _value,
    $Res Function(_$CarModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? brand = null,
    Object? model = null,
    Object? year = null,
    Object? plate = null,
    Object? color = null,
    Object? photos = null,
  }) {
    return _then(
      _$CarModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        brand: null == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String,
        model: null == model
            ? _value.model
            : model // ignore: cast_nullable_to_non_nullable
                  as String,
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as String,
        plate: null == plate
            ? _value.plate
            : plate // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CarModelImpl implements _CarModel {
  const _$CarModelImpl({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.plate,
    required this.color,
    final List<String> photos = const [],
  }) : _photos = photos;

  factory _$CarModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarModelImplFromJson(json);

  @override
  final String id;
  @override
  final String brand;
  @override
  final String model;
  @override
  final String year;
  @override
  final String plate;
  @override
  final String color;
  final List<String> _photos;
  @override
  @JsonKey()
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  String toString() {
    return 'CarModel(id: $id, brand: $brand, model: $model, year: $year, plate: $plate, color: $color, photos: $photos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.plate, plate) || other.plate == plate) &&
            (identical(other.color, color) || other.color == color) &&
            const DeepCollectionEquality().equals(other._photos, _photos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    brand,
    model,
    year,
    plate,
    color,
    const DeepCollectionEquality().hash(_photos),
  );

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      __$$CarModelImplCopyWithImpl<_$CarModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarModelImplToJson(this);
  }
}

abstract class _CarModel implements CarModel {
  const factory _CarModel({
    required final String id,
    required final String brand,
    required final String model,
    required final String year,
    required final String plate,
    required final String color,
    final List<String> photos,
  }) = _$CarModelImpl;

  factory _CarModel.fromJson(Map<String, dynamic> json) =
      _$CarModelImpl.fromJson;

  @override
  String get id;
  @override
  String get brand;
  @override
  String get model;
  @override
  String get year;
  @override
  String get plate;
  @override
  String get color;
  @override
  List<String> get photos;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
