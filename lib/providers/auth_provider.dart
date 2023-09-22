import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/models/auth/auth_state.dart';
import 'package:habit_app/repositories/auth_repository.dart';

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
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);