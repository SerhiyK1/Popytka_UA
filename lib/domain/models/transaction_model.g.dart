// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  type: json['type'] as String,
  rideId: json['rideId'] as String?,
  status: json['status'] as String? ?? 'completed',
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'amount': instance.amount,
  'createdAt': instance.createdAt.toIso8601String(),
  'type': instance.type,
  'rideId': instance.rideId,
  'status': instance.status,
};
