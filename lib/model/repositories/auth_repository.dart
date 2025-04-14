import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/model/repositories/shared_preferences_repository.dart';
import 'package:habit_app/model/use_cases/firebase_provider.dart';
import 'package:habit_app/utils/firebase_auth_error.dart';
import 'package:habit_app/utils/global_const.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(firebaseAuthProvider), ref),
);

abstract class AuthRepository {
  // 新規登録をする
  Future<String?> sendSignInLinkToEmail(String email);

  // メールリンクでサインインする
  Future<String?> signInWithEmailLink(String emailLink);

  // ログアウトをする
  Future<String?> logout();

  // 退会する
  Future<String?> deletedUser();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.auth, this.ref);
  final FirebaseAuth auth;
  final Ref ref; // 他のプロバイダーを読むのに使う
  final logger = Logger();

  @override
  Future<String?> sendSignInLinkToEmail(String email) async {
    try {
      // メールリンクの設定
      final actionCodeSettings = ActionCodeSettings(
        // リンクをクリックした時の遷移先URL
        url: GlobalConst.actionCodeUrl,
        handleCodeInApp: true,
        iOSBundleId: GlobalConst.iOSBundleId,
        androidPackageName: GlobalConst.androidPackageName,
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      // メールリンクを送信
      await auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      // メールアドレスを保存
      final sharedPreferences =
          ref.read(sharedPreferencesRepositoryProvider.notifier);
      await sharedPreferences.setEmailForSignIn(email);

      return null;
    } on FirebaseAuthException catch (e) {
      final message = FirebaseAuthErrorExt.fromCode(e.code).message;
      logger.e('新規登録に失敗しました$e');

      return message;
    }
  }

  @override
  Future<String?> signInWithEmailLink(String emailLink) async {
    try {
      final sharedPreferences =
          ref.read(sharedPreferencesRepositoryProvider.notifier);

      final email = await sharedPreferences.getEmailForSignIn();
      if (email == null) {
        logger.e('メールアドレスが取得できませんでした');
        return 'メールアドレスが取得できませんでした';
      }

      // メールリンクでサインイン
      final userCredential = await auth.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      // ユーザー情報を取得
      final user = userCredential.user;
      if (user == null) {
        logger.e('ユーザー情報が取得できませんでした');
        return 'ユーザー情報が取得できませんでした';
      }

      await ref
          .read(firebaseFirestoreProvider)
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'id': user.uid,
          'email': user.email,
          'updated_at': DateTime.now(),
          'created_at': DateTime.now(),
        },
      );

      // メールアドレスを削除
      await sharedPreferences.removeEmailForSignIn();
      return null;
    } on FirebaseAuthException catch (e) {
      final message = FirebaseAuthErrorExt.fromCode(e.code).message;
      logger.e('メールリンク認証に失敗しました$e');
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
    } catch (e) {
      logger.e('ログアウトに失敗しました$e');
      return 'ログアウトに失敗しました。再度お試しください。';
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
      logger.e('退会に失敗しました$e');
      return '退会処理に失敗しました。再度お試しください。';
    }
  }
}
