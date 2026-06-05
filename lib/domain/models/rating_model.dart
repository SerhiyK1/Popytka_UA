import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
abstract class RatingModel with _$RatingModel {
  const factory RatingModel({
    required String id,
    required String rideId,
    required String raterId,
    required String ratedId,
    required double rating,
    String? comment,
    required DateTime createdAt,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);
}
