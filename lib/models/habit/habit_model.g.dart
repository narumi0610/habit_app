// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HabitModel _$$_HabitModelFromJson(Map<String, dynamic> json) =>
    _$_HabitModel(
      id: json['id'] as String,
      user_id: json['user_id'] as String,
      title: json['title'] as String,
      start_date: DateTime.parse(json['start_date'] as String),
      current_streak: json['current_streak'] as int,
      completed_flg: json['completed_flg'] as int,
      created_at:
          const TimestampConverter().fromJson(json['created_at'] as Timestamp),
      updated_at:
          const TimestampConverter().fromJson(json['updated_at'] as Timestamp),
      deleted_at: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['deleted_at'], const TimestampConverter().fromJson),
      deleted: json['deleted'] as int,
    );

Map<String, dynamic> _$$_HabitModelToJson(_$_HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'title': instance.title,
      'start_date': instance.start_date.toIso8601String(),
      'current_streak': instance.current_streak,
      'completed_flg': instance.completed_flg,
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'updated_at': const TimestampConverter().toJson(instance.updated_at),
      'deleted_at': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.deleted_at, const TimestampConverter().toJson),
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
