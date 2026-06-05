import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_model.freezed.dart';

@freezed
abstract class StatisticsModel with _$StatisticsModel {
  const factory StatisticsModel({
    @Default(0) int totalRidesPublished,
    @Default(0) int totalRidesAsPassenger,
    @Default(0.0) double totalSpent,
    @Default(0.0) double totalEarned,
    @Default(0) int passengersCarried,
  }) = _StatisticsModel;
}
