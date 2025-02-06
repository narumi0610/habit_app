import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:habit_app/utils/timestamp_converter.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@freezed
class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'current_streak') required int currentStreak,
    @JsonKey(name: 'completed_flg') required int completedFlg,
    @JsonKey(name: 'created_at')
    @TimestampConverter()
    required DateTime createdAt,
    @JsonKey(name: 'updated_at')
    @TimestampConverter()
    required DateTime updatedAt,
    @JsonKey(name: 'deleted_at')
    @TimestampConverter()
    required DateTime? deletedAt,
    required int deleted,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}
