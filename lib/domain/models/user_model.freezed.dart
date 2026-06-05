// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError; // 'rider' or 'driver'
  String? get fcmToken => throw _privateConstructorUsedError;
  List<CarModel> get cars => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get numberOfRatings => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String phone,
    String name,
    String? photoUrl,
    String role,
    String? fcmToken,
    List<CarModel> cars,
    double averageRating,
    int numberOfRatings,
    double balance,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? role = null,
    Object? fcmToken = freezed,
    Object? cars = null,
    Object? averageRating = null,
    Object? numberOfRatings = null,
    Object? balance = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            fcmToken: freezed == fcmToken
                ? _value.fcmToken
                : fcmToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            cars: null == cars
                ? _value.cars
                : cars // ignore: cast_nullable_to_non_nullable
                      as List<CarModel>,
            averageRating: null == averageRating
                ? _value.averageRating
                : averageRating // ignore: cast_nullable_to_non_nullable
                      as double,
            numberOfRatings: null == numberOfRatings
                ? _value.numberOfRatings
                : numberOfRatings // ignore: cast_nullable_to_non_nullable
                      as int,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String phone,
    String name,
    String? photoUrl,
    String role,
    String? fcmToken,
    List<CarModel> cars,
    double averageRating,
    int numberOfRatings,
    double balance,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? phone = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? role = null,
    Object? fcmToken = freezed,
    Object? cars = null,
    Object? averageRating = null,
    Object? numberOfRatings = null,
    Object? balance = null,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        fcmToken: freezed == fcmToken
            ? _value.fcmToken
            : fcmToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        cars: null == cars
            ? _value._cars
            : cars // ignore: cast_nullable_to_non_nullable
                  as List<CarModel>,
        averageRating: null == averageRating
            ? _value.averageRating
            : averageRating // ignore: cast_nullable_to_non_nullable
                  as double,
        numberOfRatings: null == numberOfRatings
            ? _value.numberOfRatings
            : numberOfRatings // ignore: cast_nullable_to_non_nullable
                  as int,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.phone,
    required this.name,
    this.photoUrl,
    this.role = 'rider',
    this.fcmToken,
    final List<CarModel> cars = const [],
    this.averageRating = 0.0,
    this.numberOfRatings = 0,
    this.balance = 0.0,
  }) : _cars = cars;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String phone;
  @override
  final String name;
  @override
  final String? photoUrl;
  @override
  @JsonKey()
  final String role;
  // 'rider' or 'driver'
  @override
  final String? fcmToken;
  final List<CarModel> _cars;
  @override
  @JsonKey()
  List<CarModel> get cars {
    if (_cars is EqualUnmodifiableListView) return _cars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cars);
  }

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int numberOfRatings;
  @override
  @JsonKey()
  final double balance;

  @override
  String toString() {
    return 'UserModel(id: $id, phone: $phone, name: $name, photoUrl: $photoUrl, role: $role, fcmToken: $fcmToken, cars: $cars, averageRating: $averageRating, numberOfRatings: $numberOfRatings, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            const DeepCollectionEquality().equals(other._cars, _cars) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.numberOfRatings, numberOfRatings) ||
                other.numberOfRatings == numberOfRatings) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    phone,
    name,
    photoUrl,
    role,
    fcmToken,
    const DeepCollectionEquality().hash(_cars),
    averageRating,
    numberOfRatings,
    balance,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String phone,
    required final String name,
    final String? photoUrl,
    final String role,
    final String? fcmToken,
    final List<CarModel> cars,
    final double averageRating,
    final int numberOfRatings,
    final double balance,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get phone;
  @override
  String get name;
  @override
  String? get photoUrl;
  @override
  String get role; // 'rider' or 'driver'
  @override
  String? get fcmToken;
  @override
  List<CarModel> get cars;
  @override
  double get averageRating;
  @override
  int get numberOfRatings;
  @override
  double get balance;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
