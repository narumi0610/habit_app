import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/firebase_provider.dart';
import 'package:logger/logger.dart';

final habitRepositoryProvider = Provider<HabitRepository>(
  HabitRepositoryImpl.new,
);

abstract class HabitRepository {
  // 習慣の目標を作成する
  Future<void> createHabit({required String title});

  // 習慣の履歴を取得する
  Future<List<HabitModel?>> getHabitHistory();

  // 習慣の日数を更新する
  Future<void> updateHabitDays(String habitId, int currentStreak);

  // 現在の習慣を取得する
  Future<HabitModel?> getCurrentHabit();
}

class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this.ref);
  final Ref ref;
  final logger = Logger();

  @override
  Future<void> createHabit({
    required String title,
  }) async {
    try {
      final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
      final habitId =
          ref.read(firebaseFirestoreProvider).collection('habits').doc().id;

      // 習慣の目標を作成する
      await ref
          .read(firebaseFirestoreProvider)
          .collection('habits')
          .doc(habitId)
          .set(
            HabitModel(
              id: habitId,
              userId: uid,
              title: title,
              startDate: DateTime.now(),
              currentStreak: 0,
              completedFlg: 0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              deletedAt: null,
              deleted: 0,
            ).toJson(),
          );
    } catch (e) {
      logger.e(e);
      throw Exception('目標の作成に失敗しました: $e');
    }
  }

  @override
  Future<List<HabitModel?>> getHabitHistory() async {
    final user = ref.read(firebaseAuthProvider).currentUser;

    if (user == null) {
      return [null];
    }
    final habitSnap = await ref
        .read(firebaseFirestoreProvider)
        .collection('habits')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('created_at', descending: true)
        .withConverter<HabitModel>(
          fromFirestore: (snapshots, _) =>
              HabitModel.fromJson(snapshots.data()!),
          toFirestore: (task, _) => task.toJson(),
        )
        .get();

    final finishTaskList = habitSnap.docs.map((e) => e.data()).toList();

    return finishTaskList;
  }

  @override
  Future<void> updateHabitDays(String habitId, int currentStreak) async {
    await ref
        .read(firebaseFirestoreProvider)
        .collection('habits')
        .doc(habitId)
        .update({
      'current_streak': currentStreak + 1,
      'updated_at': DateTime.now(),
    });

    if (currentStreak == 29) {
      await ref
          .read(firebaseFirestoreProvider)
          .collection('habits')
          .doc(habitId)
          .update({
        'completed_flg': 1,
        'updated_at': DateTime.now(),
      });
    }
  }

  @override
  Future<HabitModel?> getCurrentHabit() async {
    final user = ref.read(firebaseAuthProvider).currentUser;

    if (user == null) {
      return null;
    }
    final uid = user.uid;
    final habitSnap = await ref
        .read(firebaseFirestoreProvider)
        .collection('habits')
        .where('user_id', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .withConverter<HabitModel>(
          fromFirestore: (snapshots, _) =>
              HabitModel.fromJson(snapshots.data()!),
          toFirestore: (task, _) => task.toJson(),
        )
        .get();

    final currentHabit = habitSnap.docs.map((e) => e.data()).toList();
    return currentHabit.isNotEmpty ? currentHabit[0] : null;
  }
}
