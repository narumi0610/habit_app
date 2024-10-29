import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/firebase_provider.dart';
import 'package:habit_app/repositories/habit_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'habit_repository_test.mocks.dart';

@GenerateMocks([HabitRepository])
void main() {
  test('createHabit is called successfully', () async {
    final mockHabitRepository = MockHabitRepository();

    // モックメソッドが呼ばれたときの動作を設定
    when(mockHabitRepository.createHabit(title: 'test'))
        .thenAnswer((_) async {});

    // テスト対象のメソッドを呼び出す
    await mockHabitRepository.createHabit(title: 'test');

    // モックメソッドが呼び出されたかを確認
    verify(mockHabitRepository.createHabit(title: 'test')).called(1);
  });

  test('createHabit fails with an exception', () async {
    final mockHabitRepository = MockHabitRepository();

    // createHabitが呼ばれたときにエラーを投げるように設定
    when(mockHabitRepository.createHabit(title: 'test'))
        .thenThrow(Exception('Failed to create habit'));

    try {
      // テスト対象のメソッドを呼び出す
      await mockHabitRepository.createHabit(title: 'test');
      // 例外をスローしないときに強制的にエラーにする
      fail('Exception was expected but not thrown');
    } catch (e) {
      // 期待される例外がスローされたか確認
      expect(e.toString(), contains('Failed to create habit'));
    }

    // モックメソッドが1回呼ばれたことを確認
    verify(mockHabitRepository.createHabit(title: 'test')).called(1);
  });

  test('getHabitHistory retrieves the habit history correctly', () async {
    // FakeFirestoreインスタンスを作成
    final fakeFirestore = FakeFirebaseFirestore();
    final fakeAuth = MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'user1',
          email: 'test@example.com',
        ),
        signedIn: true);

    // テスト用のProviderContainerを作成し、Firestoreのモックを注入
    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
        firebaseAuthProvider.overrideWithValue(fakeAuth),
      ],
    );

    final habitRepository = container.read(habitRepositoryProvider);

    // テストデータを追加
    final habitData = HabitModel(
      id: 'habit1',
      user_id: 'user1',
      title: 'test',
      start_date: DateTime.now(),
      current_streak: 5,
      completed_flg: 0,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      deleted_at: null,
      deleted: 0,
    );

    // FakeFirestoreにドキュメントを追加
    await fakeFirestore
        .collection('habits')
        .doc('habit1')
        .set(habitData.toJson());

    final snapshot = await fakeFirestore.collection('habits').get();
    expect(snapshot.docs.isNotEmpty, true); // ドキュメントが存在することを確認

    // テスト対象のメソッドを呼び出す
    final habitHistory = await habitRepository.getHabitHistory();

    // 期待されるデータと取得データが一致するか確認
    expect(habitHistory.length, 1);
    expect(habitHistory.first?.title, 'test');
    expect(habitHistory.first?.current_streak, 5);
  });

  test('getHabitHistory returns empty list when no habits are found', () async {
    // FakeFirestoreインスタンスを作成
    final fakeFirestore = FakeFirebaseFirestore();
    final fakeAuth = MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'user1',
          email: 'test@example.com',
        ),
        signedIn: true);

    // テスト用のProviderContainerを作成し、Firestoreのモックを注入
    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
        firebaseAuthProvider.overrideWithValue(fakeAuth),
      ],
    );

    addTearDown(container.dispose); // テスト終了後にリソースを解放

    // リポジトリを初期化し、Providerを経由して依存関係を渡す
    final habitRepository = container.read(habitRepositoryProvider);

    // テスト対象のメソッドを呼び出す
    final habitHistory = await habitRepository.getHabitHistory();

    // 結果が空のリストであることを確認
    expect(habitHistory.isEmpty, true);
  });

  test('updateHabitDays increments current_streak and marks habit complete',
      () async {
    final fakeFirestore = FakeFirebaseFirestore();

    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
      ],
    );
    addTearDown(container.dispose);

    final habitRepository = container.read(habitRepositoryProvider);

    // テストデータを追加
    final habitData = HabitModel(
      id: 'habit1',
      user_id: 'user1',
      title: 'Test Habit',
      start_date: DateTime.now(),
      current_streak: 29,
      completed_flg: 0,
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      deleted_at: null,
      deleted: 0,
    );

    // FakeFirestoreにドキュメントを追加
    await fakeFirestore
        .collection('habits')
        .doc('habit1')
        .set(habitData.toJson());

    // テスト対象のメソッドを呼び出す
    await habitRepository.updateHabitDays('habit1', 29);

    // Firestoreからデータを取得
    final updatedHabit =
        await fakeFirestore.collection('habits').doc('habit1').get();
    final updatedData = updatedHabit.data();

    expect(updatedData?['current_streak'], 30);
    expect(updatedData?['completed_flg'], 1);
  });

  test('updateHabitDays throws exception when Firestore update fails',
      () async {
    // FakeFirestoreインスタンスを作成
    final fakeFirestore = FakeFirebaseFirestore();

    // テスト用のProviderContainerを作成し、Firestoreのモックを注入
    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
      ],
    );
    addTearDown(container.dispose); // テスト終了後にリソースを解放

    // リポジトリを初期化し、Providerを経由して依存関係を渡す
    final habitRepository = container.read(habitRepositoryProvider);

    // 手動で例外をスローするように、テストを設定
    try {
      await habitRepository.updateHabitDays('habit1', 5);
      fail('Exception was expected but not thrown');
    } catch (e) {
      expect(e.toString(), contains('Some requested document was not found'));
    }
  });

  test('getCurrentHabit retrieves the current active habit', () async {
    final fakeFirestore = FakeFirebaseFirestore();
    final fakeAuth = MockFirebaseAuth(
        mockUser: MockUser(
          uid: 'user1',
          email: 'test@example.com',
        ),
        signedIn: true);

    final container = ProviderContainer(
      overrides: [
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
        firebaseAuthProvider.overrideWithValue(fakeAuth),
      ],
    );
    addTearDown(container.dispose);

    final habitRepository = container.read(habitRepositoryProvider);

    final habitData = HabitModel(
      id: 'habit1',
      user_id: 'user1',
      title: 'test',
      start_date: DateTime.now(),
      current_streak: 5,
      completed_flg: 0, // 未完了の習慣
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      deleted_at: null,
      deleted: 0,
    );

    // FakeFirestoreにドキュメントを追加
    await fakeFirestore
        .collection('habits')
        .doc('habit1')
        .set(habitData.toJson());

    final currentHabit = await habitRepository.getCurrentHabit();

    expect(currentHabit?.title, 'test');
    expect(currentHabit?.current_streak, 5);
  });
}
