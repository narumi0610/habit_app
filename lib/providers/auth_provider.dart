import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/auth/auth_state.dart';
import 'package:habit_app/repositories/auth_repository.dart';

//TODO あとで＠riverpodの使用コードに修正
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.repository) : super(const AuthState.initial());

  final AuthRepository repository;

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    final response = await repository.login(email, password);
    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (response) => AuthState.authenticated(user: response),
    );
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AuthState.loading();
    final response = await repository.signUp(email, password);
    state = response.fold(
      (error) => AuthState.unauthenticated(message: error),
      (response) => AuthState.authenticated(user: response),
    );
  }

  Future<T> logout<T>({
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    state = const AuthState.loading();
    final response =
        await repository.logout(onSuccess: onSuccess, onError: onError);
    state = const AuthState.unauthenticated();
    return response;
  }

  Future<T> passwordReset<T>({
    required String email,
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    final response = await repository.passwordReset(
      email: email,
      onSuccess: onSuccess,
      onError: onError,
    );
    return response;
  }

  Future<T> deletedUser<T>({
    required T Function() onSuccess,
    required T Function() onError,
  }) async {
    return await repository.deletedUser(
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);
