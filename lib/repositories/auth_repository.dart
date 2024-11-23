import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/providers/firebase_provider.dart';
import 'package:habit_app/utils/firebase_auth_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(firebaseAuthProvider), ref),
);

abstract class AuthRepository {
  // 新規登録をする
  Future<String?> signUp(String email, String password);

  // ログインをする
  Future<String?> login(String email, String password);

  // ログアウトをする
  Future<String?> logout();

  // パスワードを変更する
  Future<void> passwordReset({required String email});

  // 退会する
  Future<String?> deletedUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  final Ref ref; // 他のプロバイダーを読むのに使う

  AuthRepositoryImpl(this.auth, this.ref);

  @override
  Future<String?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(uid)
          .set(
        {
          'id': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'updated_at': DateTime.now(),
          'created_at': DateTime.now(),
        },
      );
      return null;
    } on FirebaseAuthException catch (e) {
      var message = FirebaseAuthErrorExt.fromCode(e.code).message;
      return message;
    }
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      var message = FirebaseAuthErrorExt.fromCode(e.code).message;
      return message;
    }
  }

  @override
  Future<String?> logout() async {
    try {
      await auth.signOut();
      // SharedPreferencesのインスタンスを取得
      final prefs = await SharedPreferences.getInstance();
      // ローカルデータを削除
      await prefs.clear();
      return null;
    } catch (_) {
      return "ログアウトに失敗しました";
    }
  }

  @override
  Future<void> passwordReset({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("パスワードリセットリンクの送信に失敗しました $e");
    }
  }

  @override
  Future<String?> deletedUser() async {
    try {
      final user = ref.read(firebaseAuthProvider).currentUser;
      final uid = user?.uid;
      // delete_usersコレクションに追加
      await ref
          .read(firebaseFirestoreProvider)
          .collection('delete_users')
          .doc(uid)
          .set(
        {
          'user_id': uid,
          'created_at': DateTime.now(),
        },
      );
      await FirebaseAuth.instance.signOut();
      // SharedPreferencesのインスタンスを取得
      final prefs = await SharedPreferences.getInstance();
      // ローカルデータを削除
      await prefs.clear();
      return null;
    } catch (e) {
      return "退会処理に失敗しました";
    }
  }
}
