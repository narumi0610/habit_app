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
      final user = ref.read(firebaseAuthProvider).currentUser;
      if (user == null) {
        logger.e('ユーザー情報が取得できませんでした');
        throw Exception('ユーザーが認証されていません');
      }

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
              userId: user.uid,
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
  Future<List<HabitModel?>> getHabitHistory() async {
    final user = ref.read(firebaseAuthProvider).currentUser;
    try {
      if (user == null) {
        return [null];
      }
      final habitSnap = await ref
          .read(firebaseFirestoreProvider)
          .collection('habits')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('created_at', descending: true)
          .withConverter<HabitModel>(
            fromFirestore: (snapshots, _) {
              final data = snapshots.data();
              if (data == null) {
                logger.e('データが取得できませんでした');
                throw Exception('データが取得できませんでした');
              }

              return HabitModel.fromJson(data);
            },
            toFirestore: (task, _) => task.toJson(),
          )
          .get();

      final finishTaskList = habitSnap.docs.map((e) => e.data()).toList();

      return finishTaskList;
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
    try {
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
            fromFirestore: (snapshots, _) {
              final data = snapshots.data();
              if (data == null) {
                logger.e('データが取得できませんでした');
                throw Exception('データが取得できませんでした');
              }
              return HabitModel.fromJson(data);
            },
            toFirestore: (task, _) => task.toJson(),
          )
          .get();

      final currentHabit = habitSnap.docs.map((e) => e.data()).toList();
      return currentHabit.isNotEmpty ? currentHabit[0] : null;
    } catch (e, stackTrace) {
      await _handleError(e, stackTrace);
      throw Exception('習慣の取得に失敗しました。もう一度お試しください。');
    }
  }
}
