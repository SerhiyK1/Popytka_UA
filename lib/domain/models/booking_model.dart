import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

@freezed
abstract class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String rideId,
    required String userId,
    required int seats,
    required double totalPrice,
    required String status, // 'pended', 'confirmed', 'cancelled'
    required DateTime createdAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
