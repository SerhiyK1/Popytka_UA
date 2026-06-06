// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RideRequestModelImpl _$$RideRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$RideRequestModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  fromCity: json['fromCity'] as String,
  toCity: json['toCity'] as String,
  departureTime: DateTime.parse(json['departureTime'] as String),
  seatsRequired: (json['seatsRequired'] as num).toInt(),
  status: json['status'] as String? ?? 'pending',
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$RideRequestModelImplToJson(
  _$RideRequestModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'fromCity': instance.fromCity,
  'toCity': instance.toCity,
  'departureTime': instance.departureTime.toIso8601String(),
  'seatsRequired': instance.seatsRequired,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};
