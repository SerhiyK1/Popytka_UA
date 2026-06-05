// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      rideId: json['rideId'] as String,
      userId: json['userId'] as String,
      seats: (json['seats'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'userId': instance.userId,
      'seats': instance.seats,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
    };
