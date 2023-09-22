import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:habit_app/providers/firebase_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(firebaseAuthProvider), ref),
);

abstract class AuthRepository {
  // 新規登録をする
  Future<Either<String, User>> signUp(String email, String password);

  // ログインをする
  Future<Either<String, User>> login(String email, String password);
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
      return right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return left(e.message ?? '新規登録に失敗しました');
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
      return left(e.message ?? 'ログインに失敗しました');
    }
  }
}
