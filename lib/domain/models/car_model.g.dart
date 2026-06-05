// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarModelImpl _$$CarModelImplFromJson(Map<String, dynamic> json) =>
    _$CarModelImpl(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      plate: json['plate'] as String,
      color: json['color'] as String,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CarModelImplToJson(_$CarModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'plate': instance.plate,
      'color': instance.color,
      'photos': instance.photos,
    };
