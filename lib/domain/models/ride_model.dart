import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'location_model.dart';

part 'ride_model.freezed.dart';
part 'ride_model.g.dart';

@freezed
abstract class RideModel with _$RideModel {
  const factory RideModel({
    required String id,
    required String riderId,
    String? driverId,
    String? carId,
    required LocationModel fromLocation,
    required LocationModel toLocation,
    @Default([]) List<LatLng> routePoints, // Full road geometry
    @Default('pending') String status,
    required double pricePerSeat,
    required int seatsAvailable,
    required DateTime departureTime,
    required DateTime createdAt,
  }) = _RideModel;

  factory RideModel.fromJson(Map<String, dynamic> json) =>
      _$RideModelFromJson(json);
}
