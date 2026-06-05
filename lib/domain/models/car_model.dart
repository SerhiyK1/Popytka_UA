import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_model.freezed.dart';
part 'car_model.g.dart';

@freezed
abstract class CarModel with _$CarModel {
  const factory CarModel({
    required String id,
    required String brand,
    required String model,
    required String year,
    required String plate,
    required String color,
    @Default([]) List<String> photos,
  }) = _CarModel;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);
}
