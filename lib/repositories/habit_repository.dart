import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/firebase_provider.dart';

final habitRepositoryProvider = Provider<HabitRepository>(
  (ref) => HabitRepositoryImpl(ref),
);

abstract class HabitRepository {
  // 習慣の目標を作成する
  Future<T> createHabit<T>({
    required String title,
    required T Function() onSuccess,
    required T Function() onError,
  });

  // 習慣の履歴を取得する
  Future<List<HabitModel>> getHabitHistory();

  // 習慣の日数を更新する
  Future<void> updateHabitDays(String habitId, int currentStreak);
}

class HabitRepositoryImpl implements HabitRepository {
  final Ref ref;

  HabitRepositoryImpl(this.ref);

  @override
  Future<T> createHabit<T>({
    required String title,
    required T Function() onSuccess,
    required T Function() onError,
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
          .set(HabitModel(
                  id: habitId,
                  user_id: uid,
                  title: title,
                  start_date: DateTime.now(),
                  current_streak: 0,
                  completed_flg: 0,
                  created_at: DateTime.now(),
                  updated_at: DateTime.now(),
                  deleted_at: null,
                  deleted: 0)
              .toJson());
      return onSuccess();
    } catch (_) {
      return onError();
    }
  }

  @override
  Future<List<HabitModel>> getHabitHistory() async {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
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
      'current_streak': currentStreak,
      'updated_at': DateTime.now(),
    });
  }
}