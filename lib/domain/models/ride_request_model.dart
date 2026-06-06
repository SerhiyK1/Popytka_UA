import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'ride_request_model.freezed.dart';
part 'ride_request_model.g.dart';

@freezed
abstract class RideRequestModel with _$RideRequestModel {
  const factory RideRequestModel({
    required String id,
    required String userId,
    required String fromCity,
    required String toCity,
    required DateTime departureTime,
    required int seatsRequired,
    @Default('pending') String status, // 'pending', 'matched', 'cancelled'
    required DateTime createdAt,
  }) = _RideRequestModel;

  factory RideRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RideRequestModelFromJson(json);
}
