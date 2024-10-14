// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) {
  return _HabitModel.fromJson(json);
}

/// @nodoc
mixin _$HabitModel {
  String get id => throw _privateConstructorUsedError;
  String get user_id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  DateTime get start_date => throw _privateConstructorUsedError;
  int get current_streak => throw _privateConstructorUsedError;
  int get completed_flg => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get created_at => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updated_at => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get deleted_at => throw _privateConstructorUsedError;
  int get deleted => throw _privateConstructorUsedError;

  /// Serializes this HabitModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HabitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitModelCopyWith<HabitModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitModelCopyWith<$Res> {
  factory $HabitModelCopyWith(
          HabitModel value, $Res Function(HabitModel) then) =
      _$HabitModelCopyWithImpl<$Res, HabitModel>;
  @useResult
  $Res call(
      {String id,
      String user_id,
      String title,
      DateTime start_date,
      int current_streak,
      int completed_flg,
      @TimestampConverter() DateTime created_at,
      @TimestampConverter() DateTime updated_at,
      @TimestampConverter() DateTime? deleted_at,
      int deleted});
}

/// @nodoc
class _$HabitModelCopyWithImpl<$Res, $Val extends HabitModel>
    implements $HabitModelCopyWith<$Res> {
  _$HabitModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HabitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? title = null,
    Object? start_date = null,
    Object? current_streak = null,
    Object? completed_flg = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? deleted_at = freezed,
    Object? deleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start_date: null == start_date
          ? _value.start_date
          : start_date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      current_streak: null == current_streak
          ? _value.current_streak
          : current_streak // ignore: cast_nullable_to_non_nullable
              as int,
      completed_flg: null == completed_flg
          ? _value.completed_flg
          : completed_flg // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitModelImplCopyWith<$Res>
    implements $HabitModelCopyWith<$Res> {
  factory _$$HabitModelImplCopyWith(
          _$HabitModelImpl value, $Res Function(_$HabitModelImpl) then) =
      __$$HabitModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String user_id,
      String title,
      DateTime start_date,
      int current_streak,
      int completed_flg,
      @TimestampConverter() DateTime created_at,
      @TimestampConverter() DateTime updated_at,
      @TimestampConverter() DateTime? deleted_at,
      int deleted});
}

/// @nodoc
class __$$HabitModelImplCopyWithImpl<$Res>
    extends _$HabitModelCopyWithImpl<$Res, _$HabitModelImpl>
    implements _$$HabitModelImplCopyWith<$Res> {
  __$$HabitModelImplCopyWithImpl(
      _$HabitModelImpl _value, $Res Function(_$HabitModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HabitModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user_id = null,
    Object? title = null,
    Object? start_date = null,
    Object? current_streak = null,
    Object? completed_flg = null,
    Object? created_at = null,
    Object? updated_at = null,
    Object? deleted_at = freezed,
    Object? deleted = null,
  }) {
    return _then(_$HabitModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user_id: null == user_id
          ? _value.user_id
          : user_id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      start_date: null == start_date
          ? _value.start_date
          : start_date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      current_streak: null == current_streak
          ? _value.current_streak
          : current_streak // ignore: cast_nullable_to_non_nullable
              as int,
      completed_flg: null == completed_flg
          ? _value.completed_flg
          : completed_flg // ignore: cast_nullable_to_non_nullable
              as int,
      created_at: null == created_at
          ? _value.created_at
          : created_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated_at: null == updated_at
          ? _value.updated_at
          : updated_at // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deleted_at: freezed == deleted_at
          ? _value.deleted_at
          : deleted_at // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deleted: null == deleted
          ? _value.deleted
          : deleted // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HabitModelImpl implements _HabitModel {
  const _$HabitModelImpl(
      {required this.id,
      required this.user_id,
      required this.title,
      required this.start_date,
      required this.current_streak,
      required this.completed_flg,
      @TimestampConverter() required this.created_at,
      @TimestampConverter() required this.updated_at,
      @TimestampConverter() required this.deleted_at,
      required this.deleted});

  factory _$HabitModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HabitModelImplFromJson(json);

  @override
  final String id;
  @override
  final String user_id;
  @override
  final String title;
  @override
  final DateTime start_date;
  @override
  final int current_streak;
  @override
  final int completed_flg;
  @override
  @TimestampConverter()
  final DateTime created_at;
  @override
  @TimestampConverter()
  final DateTime updated_at;
  @override
  @TimestampConverter()
  final DateTime? deleted_at;
  @override
  final int deleted;

  @override
  String toString() {
    return 'HabitModel(id: $id, user_id: $user_id, title: $title, start_date: $start_date, current_streak: $current_streak, completed_flg: $completed_flg, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, deleted: $deleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user_id, user_id) || other.user_id == user_id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.start_date, start_date) ||
                other.start_date == start_date) &&
            (identical(other.current_streak, current_streak) ||
                other.current_streak == current_streak) &&
            (identical(other.completed_flg, completed_flg) ||
                other.completed_flg == completed_flg) &&
            (identical(other.created_at, created_at) ||
                other.created_at == created_at) &&
            (identical(other.updated_at, updated_at) ||
                other.updated_at == updated_at) &&
            (identical(other.deleted_at, deleted_at) ||
                other.deleted_at == deleted_at) &&
            (identical(other.deleted, deleted) || other.deleted == deleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      user_id,
      title,
      start_date,
      current_streak,
      completed_flg,
      created_at,
      updated_at,
      deleted_at,
      deleted);

  /// Create a copy of HabitModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitModelImplCopyWith<_$HabitModelImpl> get copyWith =>
      __$$HabitModelImplCopyWithImpl<_$HabitModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HabitModelImplToJson(
      this,
    );
  }
}

abstract class _HabitModel implements HabitModel {
  const factory _HabitModel(
      {required final String id,
      required final String user_id,
      required final String title,
      required final DateTime start_date,
      required final int current_streak,
      required final int completed_flg,
      @TimestampConverter() required final DateTime created_at,
      @TimestampConverter() required final DateTime updated_at,
      @TimestampConverter() required final DateTime? deleted_at,
      required final int deleted}) = _$HabitModelImpl;

  factory _HabitModel.fromJson(Map<String, dynamic> json) =
      _$HabitModelImpl.fromJson;

  @override
  String get id;
  @override
  String get user_id;
  @override
  String get title;
  @override
  DateTime get start_date;
  @override
  int get current_streak;
  @override
  int get completed_flg;
  @override
  @TimestampConverter()
  DateTime get created_at;
  @override
  @TimestampConverter()
  DateTime get updated_at;
  @override
  @TimestampConverter()
  DateTime? get deleted_at;
  @override
  int get deleted;

  /// Create a copy of HabitModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitModelImplCopyWith<_$HabitModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
