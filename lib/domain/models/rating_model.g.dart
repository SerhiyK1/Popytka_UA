// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingModelImpl _$$RatingModelImplFromJson(Map<String, dynamic> json) =>
    _$RatingModelImpl(
      id: json['id'] as String,
      rideId: json['rideId'] as String,
      raterId: json['raterId'] as String,
      ratedId: json['ratedId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RatingModelImplToJson(_$RatingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rideId': instance.rideId,
      'raterId': instance.raterId,
      'ratedId': instance.ratedId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
    };
