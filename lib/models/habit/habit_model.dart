import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:habit_app/utils/timestamp_converter.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    required String user_id,
    required String title,
    required DateTime start_date,
    required int current_streak,
    required int completed_flg,
    @TimestampConverter() required DateTime created_at,
    @TimestampConverter() required DateTime updated_at,
    @TimestampConverter() required DateTime? deleted_at,
    required int deleted,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}
