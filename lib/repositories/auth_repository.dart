import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habit_app/providers/firebase_provider.dart';
import 'package:habit_app/utils/firebase_auth_error.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(firebaseAuthProvider), ref),
);

abstract class AuthRepository {
  // 新規登録をする
  Future<Either<String, User>> signUp(String email, String password);

  // ログインをする
  Future<Either<String, User>> login(String email, String password);

  // ログアウトをする
  Future<T> logout<T>({
    required T Function() onSuccess,
    required T Function() onError,
  });

  // パスワードを変更する
  Future<T> passwordReset<T>({
    required String email,
    required T Function() onSuccess,
    required T Function() onError,
  });

  // 退会する
  Future<T> deletedUser<T>({
    required T Function() onSuccess,
    required T Function() onError,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  final Ref ref; // 他のプロバイダーを読むのに使う

  AuthRepositoryImpl(this.auth, this.ref);

  @override
  Future<Either<String, User>> signUp(String email, String password) async {
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
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      var message = FirebaseAuthErrorExt.fromCode(e.code).message;
      return left(message);
    }
  }

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      var message = FirebaseAuthErrorExt.fromCode(e.code).message;
      return left(message);
    }
  }

  @override
  Future<T> logout<T>({
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    try {
      await auth.signOut();
      return onSuccess();
    } catch (_) {
      return onError();
    }
  }

  @override
  Future<T> passwordReset<T>({
    required String email,
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return onSuccess();
    } catch (_) {
      return onError();
    }
  }

  @override
  Future<T> deletedUser<T>({
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
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
      return onSuccess();
    } catch (e) {
      return onError();
    }
  }
}
