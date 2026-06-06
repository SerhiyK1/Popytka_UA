// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RideModelImpl _$$RideModelImplFromJson(Map<String, dynamic> json) =>
    _$RideModelImpl(
      id: json['id'] as String,
      riderId: json['riderId'] as String,
      driverId: json['driverId'] as String?,
      carId: json['carId'] as String?,
      fromLocation: LocationModel.fromJson(
        json['fromLocation'] as Map<String, dynamic>,
      ),
      toLocation: LocationModel.fromJson(
        json['toLocation'] as Map<String, dynamic>,
      ),
      routePoints:
          (json['routePoints'] as List<dynamic>?)
              ?.map((e) => LatLng.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'pending',
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      seatsAvailable: (json['seatsAvailable'] as num).toInt(),
      departureTime: DateTime.parse(json['departureTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RideModelImplToJson(_$RideModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'riderId': instance.riderId,
      'driverId': instance.driverId,
      'carId': instance.carId,
      'fromLocation': instance.fromLocation,
      'toLocation': instance.toLocation,
      'routePoints': instance.routePoints,
      'status': instance.status,
      'pricePerSeat': instance.pricePerSeat,
      'seatsAvailable': instance.seatsAvailable,
      'departureTime': instance.departureTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
