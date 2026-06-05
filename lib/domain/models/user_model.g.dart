// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] as String? ?? 'rider',
      fcmToken: json['fcmToken'] as String?,
      cars:
          (json['cars'] as List<dynamic>?)
              ?.map((e) => CarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      numberOfRatings: (json['numberOfRatings'] as num?)?.toInt() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'photoUrl': instance.photoUrl,
      'role': instance.role,
      'fcmToken': instance.fcmToken,
      'cars': instance.cars,
      'averageRating': instance.averageRating,
      'numberOfRatings': instance.numberOfRatings,
      'balance': instance.balance,
    };
