import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/models/habit/habit_model.dart';
import 'package:habit_app/providers/firebase_provider.dart';
import 'package:habit_app/screens/create_habit_screen.dart';
import 'package:habit_app/screens/home_screen.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late FakeFirebaseFirestore fakeFirestore;
  const uid = '123';

  setUp(() {
    mockUser = MockUser(
      email: 'test@example.com',
      uid: uid,
    );

    // モックのFirebaseAuthとFirestoreのセットアップ
    mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
    fakeFirestore = FakeFirebaseFirestore();
  });
  testWidgets('habit setting button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateHabitScreen(),
      ),
    );

    // テキストフィールドに目標を入力
    final textFieldFinder = find.byType(TextFormField);
    await tester.enterText(textFieldFinder, '本を1ページ読む');

    // ボタンを探してタップ
    final buttonFinder = find.text('決定する');
    await tester.tap(buttonFinder);
  });

  testWidgets('habit update button', (WidgetTester tester) async {
    final habitData = HabitModel(
      id: 'habit1',
      userId: uid,
      title: 'test',
      startDate: DateTime.now(),
      currentStreak: 5,
      completedFlg: 0, // 未完了の習慣
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
      deleted: 0,
    );

    // FakeFirestoreにドキュメントを追加
    await fakeFirestore
        .collection('habits')
        .doc('habit1')
        .set(habitData.toJson());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
          firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final finder = find.byType(InkWell);
    await tester.tap(finder);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
  });
}
