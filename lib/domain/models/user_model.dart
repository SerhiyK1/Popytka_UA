import 'package:freezed_annotation/freezed_annotation.dart';

import 'car_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    required String name,
    String? photoUrl,
    @Default('rider') String role, // 'rider' or 'driver'
    String? fcmToken,
    @Default([]) List<CarModel> cars,
    @Default(0.0) double averageRating,
    @Default(0) int numberOfRatings,
    @Default(0.0) double balance,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
