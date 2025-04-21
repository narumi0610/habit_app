import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/entities/habit/habit_model.dart';
import 'package:habit_app/model/use_cases/firebase_provider.dart';
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

  Future<void> _handleError(Object? e, StackTrace stackTrace) async {
    if (e is FirebaseException) {
      logger.e('Firebaseエラー: ${e.message}', error: e, stackTrace: stackTrace);
      Error.throwWithStackTrace(e, stackTrace);
    } else if (e is PlatformException) {
      logger.e('プラットフォームエラー: ${e.message}', error: e, stackTrace: stackTrace);
      Error.throwWithStackTrace(e, stackTrace);
    } else {
      logger.e('予期しないエラー: $e', error: e, stackTrace: stackTrace);
      throw Exception('予期しないエラーが発生しました。');
    }
  }

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
    } catch (e, stackTrace) {
      await _handleError(e, stackTrace);
      throw Exception('目標の作成に失敗しました。もう一度お試しください。');
    }
  }

  @override
  Future<List<HabitModel?>> getHabitHistory({int? limit}) async {
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    try {
      if (uid == null) {
        return [null];
      }

      var query = ref
          .read(firebaseFirestoreProvider)
          .collection('habits')
          .where('user_id', isEqualTo: uid)
          .orderBy('created_at', descending: true)
          .withConverter<HabitModel>(
            fromFirestore: (snapshots, _) =>
                HabitModel.fromJson(snapshots.data()!),
            toFirestore: (task, _) => task.toJson(),
          );

      // limitが指定されている場合は制限を追加
      if (limit != null) {
        query = query.limit(limit);
      }

      final habitSnap = await query.get();
      return habitSnap.docs.map((doc) => doc.data()).toList();
    } catch (e, stackTrace) {
      await _handleError(e, stackTrace);
      throw Exception('履歴の取得に失敗しました。もう一度お試しください。');
    }
  }

  @override
  Future<void> updateHabitDays(String habitId, int currentStreak) async {
    try {
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
    } catch (e, stackTrace) {
      await _handleError(e, stackTrace);
      throw Exception('習慣の更新に失敗しました。もう一度お試しください。');
    }
  }

  @override
  Future<HabitModel?> getCurrentHabit() async {
    final habits = await getHabitHistory(limit: 1);
    return habits.isEmpty ? null : habits.first;
  }
}
