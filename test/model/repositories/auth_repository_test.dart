import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/model/repositories/auth_repository.dart';
import 'package:habit_app/model/use_cases/firebase_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([AuthRepository])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late ProviderContainer container;
  late AuthRepository authRepository;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    mockUser = MockUser(
      email: 'test@example.com',
      uid: '123',
    );

    // モックのFirebaseAuthとFirestoreのセットアップ
    mockFirebaseAuth = MockFirebaseAuth(mockUser: mockUser);
    fakeFirestore = FakeFirebaseFirestore();

    // ProviderContainerのセットアップ
    container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
        firebaseFirestoreProvider.overrideWithValue(fakeFirestore),
      ],
    );

    authRepository = container.read(authRepositoryProvider);
  });
  group('AuthRepository Tests', () {
    test('signUp success', () async {
      // モックユーザーのサインアップ動作のテスト
      await authRepository.signUp('test@example.com', 'password');
      // サインアップ成功の確認
      expect(mockFirebaseAuth.currentUser, isNotNull);
      expect(mockFirebaseAuth.currentUser!.email, 'test@example.com');
    });

    test('login success', () async {
      // モックユーザーのログイン動作のテスト
      await authRepository.login('test@example.com', 'password');

      // ログイン成功の確認
      expect(mockFirebaseAuth.currentUser, isNotNull);
      expect(mockFirebaseAuth.currentUser!.email, 'test@example.com');
    });

    test('logout success', () async {
      // ログアウト動作のテスト
      await authRepository.logout();

      // ログアウト成功の確認
      expect(mockFirebaseAuth.currentUser, isNull);
    });
  });
}
