import 'package:habit_app/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository repository;

  @override
  FutureOr<void> build() {
    repository = ref.read(authRepositoryProvider);
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final errorMessage = await repository.login(email, password);
      if (errorMessage != null) {
        state = AsyncValue.error(errorMessage, StackTrace.current);

        return errorMessage;
      } else {
        state = const AsyncValue.data(null);
        return null;
      }
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      return error.toString();
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final errorMessage = await repository.signUp(email, password);
      if (errorMessage != null) {
        state = AsyncValue.error(errorMessage, StackTrace.current);

        return errorMessage;
      } else {
        state = AsyncValue.data(null);
        return null;
      }
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      return error.toString();
    }
  }

  Future<String?> logout() async {
    state = const AsyncValue.loading();
    try {
      final errorMessage = await repository.logout();
      state = const AsyncValue.data(null);
      return errorMessage;
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      return error.toString();
    }
  }

  Future<void> passwordReset({required String email}) async {
    state = const AsyncValue.loading();
    try {
      await repository.passwordReset(email: email);
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<String?> deletedUser() async {
    state = const AsyncValue.loading();
    try {
      final errorMessage = await repository.deletedUser();
      state = const AsyncValue.data(null);
      return errorMessage;
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
      return error.toString();
    }
  }
}
