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

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading(); //非同期処理中にローディング状態にする
    try {
      final response = await repository.login(email, password);
      state = AsyncValue.data(response);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.signUp(email, password);
      state = AsyncData(response);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await repository.logout();
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
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

  Future<void> deletedUser() async {
    state = const AsyncValue.loading();
    try {
      await repository.deletedUser();
      state = const AsyncValue.data(null);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }
}
