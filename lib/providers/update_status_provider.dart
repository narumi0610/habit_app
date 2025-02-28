import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateStatusParams {
  const UpdateStatusParams({
    required this.updatedAt,
    required this.currentStreak,
  });
  final DateTime updatedAt;
  final int currentStreak;
}

final isUpdatedTodayProvider =
    StateProvider.autoDispose.family<bool, UpdateStatusParams>((ref, param) {
  return DateTime.now().year == param.updatedAt.year &&
      DateTime.now().month == param.updatedAt.month &&
      DateTime.now().day == param.updatedAt.day &&
      param.currentStreak != 0;
});
