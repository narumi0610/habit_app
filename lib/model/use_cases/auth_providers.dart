import 'package:habit_app/model/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository repository;

  @override
  FutureOr<void> build() {
    repository = ref.watch(authRepositoryProvider);
  }

  Future<String?> sendSignInLinkToEmail({
    required String email,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final errorMessage = await repository.sendSignInLinkToEmail(email);
      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      return null;
    });

    state = result;
    return result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }

  Future<String?> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final errorMessage =
          await repository.signInWithEmailLink(email, emailLink);
      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      return null;
    });

    state = result;
    return result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }

  Future<String?> logout() async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final errorMessage = await repository.logout();
      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      return null;
    });

    state = result;
    return result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }

  Future<String?> deletedUser() async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      final errorMessage = await repository.deletedUser();
      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      return null;
    });

    state = result;
    return result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }
}
