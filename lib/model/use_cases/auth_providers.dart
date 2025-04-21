import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> sendSignInLinkToEmail({
    required String email,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(
      () => repository.sendSignInLinkToEmail(email),
    );

    state = const AsyncValue.data(null);

    result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }

  Future<String?> signInWithEmailLink({
    required String emailLink,
  }) async {
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(
      () => repository.signInWithEmailLink(emailLink),
    );

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

    state = const AsyncValue.data(null);
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

    state = const AsyncValue.data(null);

    return result.when(
      data: (_) => null,
      error: (error, stack) => error.toString(),
      loading: () => null,
    );
  }
}

// ユーザーの認証状態を監視する
final userStateProvider = StreamProvider<(User?, bool)>((ref) {
  return FirebaseAuth.instance.userChanges().map((user) {
    return (user, user?.emailVerified ?? false);
  });
});
