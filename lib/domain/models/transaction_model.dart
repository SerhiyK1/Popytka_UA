import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required String userId,
    required double amount,
    required DateTime createdAt,
    required String type, // 'ride_payment', 'topup', 'withdrawal'
    String? rideId,
    @Default('completed') String status, // 'completed', 'pending', 'failed'
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}
