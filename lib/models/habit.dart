import 'dart:convert';

class Habit {
  final String id;
  final String title;
  final DateTime startDate;
  final int currentStreak;
  final bool isCompleted;

  Habit({
    required this.id,
    required this.title,
    required this.startDate,
    required this.currentStreak,
    required this.isCompleted,
  });

  // JSONマップからHabitオブジェクトを作成するための名前付きコンストラクタ
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      currentStreak: json['currentStreak'],
      isCompleted: json['isCompleted'],
    );
  }

  // HabitオブジェクトをJSONマップに変換するメソッド
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'currentStreak': currentStreak,
      'isCompleted': isCompleted,
    };
  }

  // JSON文字列から習慣オブジェクトを作成するヘルパーメソッドです。
  static Habit fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return Habit.fromJson(jsonMap);
  }

  // HabitオブジェクトをJSON文字列に変換するヘルパーメソッドです。
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // 開始日に30日足して終了日を算出する
  DateTime getEndDate() {
    return startDate.add(Duration(days: 30));
  }
}
