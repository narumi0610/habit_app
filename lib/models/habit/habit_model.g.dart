// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HabitModelImpl _$$HabitModelImplFromJson(Map<String, dynamic> json) =>
    _$HabitModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      currentStreak: (json['current_streak'] as num).toInt(),
      completedFlg: (json['completed_flg'] as num).toInt(),
      createdAt:
          const TimestampConverter().fromJson(json['created_at'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updated_at'] as Timestamp),
      deletedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['deleted_at'], const TimestampConverter().fromJson),
      deleted: (json['deleted'] as num).toInt(),
    );

Map<String, dynamic> _$$HabitModelImplToJson(_$HabitModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'start_date': instance.startDate.toIso8601String(),
      'current_streak': instance.currentStreak,
      'completed_flg': instance.completedFlg,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'updated_at': const TimestampConverter().toJson(instance.updatedAt),
      'deleted_at': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.deletedAt, const TimestampConverter().toJson),
      'deleted': instance.deleted,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
