// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiServiceHash() => r'c6b286afc800cce66c872442f35c8e9d3cf7e4f5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$GeminiService
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final String habitName;
  late final int currentStreak;
  late final String? lastCompletion;

  FutureOr<String> build({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  });
}

/// Gemini APIを使用して習慣に関する応援メッセージを生成する
/// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
///
/// Copied from [GeminiService].
@ProviderFor(GeminiService)
const geminiServiceProvider = GeminiServiceFamily();

/// Gemini APIを使用して習慣に関する応援メッセージを生成する
/// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
///
/// Copied from [GeminiService].
class GeminiServiceFamily extends Family<AsyncValue<String>> {
  /// Gemini APIを使用して習慣に関する応援メッセージを生成する
  /// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
  ///
  /// Copied from [GeminiService].
  const GeminiServiceFamily();

  /// Gemini APIを使用して習慣に関する応援メッセージを生成する
  /// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
  ///
  /// Copied from [GeminiService].
  GeminiServiceProvider call({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  }) {
    return GeminiServiceProvider(
      habitName: habitName,
      currentStreak: currentStreak,
      lastCompletion: lastCompletion,
    );
  }

  @override
  GeminiServiceProvider getProviderOverride(
    covariant GeminiServiceProvider provider,
  ) {
    return call(
      habitName: provider.habitName,
      currentStreak: provider.currentStreak,
      lastCompletion: provider.lastCompletion,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'geminiServiceProvider';
}

/// Gemini APIを使用して習慣に関する応援メッセージを生成する
/// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
///
/// Copied from [GeminiService].
class GeminiServiceProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GeminiService, String> {
  /// Gemini APIを使用して習慣に関する応援メッセージを生成する
  /// ビジネスロジックを実装し、リポジトリを使用してデータを取得する
  ///
  /// Copied from [GeminiService].
  GeminiServiceProvider({
    required String habitName,
    required int currentStreak,
    String? lastCompletion,
  }) : this._internal(
          () => GeminiService()
            ..habitName = habitName
            ..currentStreak = currentStreak
            ..lastCompletion = lastCompletion,
          from: geminiServiceProvider,
          name: r'geminiServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$geminiServiceHash,
          dependencies: GeminiServiceFamily._dependencies,
          allTransitiveDependencies:
              GeminiServiceFamily._allTransitiveDependencies,
          habitName: habitName,
          currentStreak: currentStreak,
          lastCompletion: lastCompletion,
        );

  GeminiServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitName,
    required this.currentStreak,
    required this.lastCompletion,
  }) : super.internal();

  final String habitName;
  final int currentStreak;
  final String? lastCompletion;

  @override
  FutureOr<String> runNotifierBuild(
    covariant GeminiService notifier,
  ) {
    return notifier.build(
      habitName: habitName,
      currentStreak: currentStreak,
      lastCompletion: lastCompletion,
    );
  }

  @override
  Override overrideWith(GeminiService Function() create) {
    return ProviderOverride(
      origin: this,
      override: GeminiServiceProvider._internal(
        () => create()
          ..habitName = habitName
          ..currentStreak = currentStreak
          ..lastCompletion = lastCompletion,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitName: habitName,
        currentStreak: currentStreak,
        lastCompletion: lastCompletion,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GeminiService, String>
      createElement() {
    return _GeminiServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GeminiServiceProvider &&
        other.habitName == habitName &&
        other.currentStreak == currentStreak &&
        other.lastCompletion == lastCompletion;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitName.hashCode);
    hash = _SystemHash.combine(hash, currentStreak.hashCode);
    hash = _SystemHash.combine(hash, lastCompletion.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GeminiServiceRef on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `habitName` of this provider.
  String get habitName;

  /// The parameter `currentStreak` of this provider.
  int get currentStreak;

  /// The parameter `lastCompletion` of this provider.
  String? get lastCompletion;
}

class _GeminiServiceProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GeminiService, String>
    with GeminiServiceRef {
  _GeminiServiceProviderElement(super.provider);

  @override
  String get habitName => (origin as GeminiServiceProvider).habitName;
  @override
  int get currentStreak => (origin as GeminiServiceProvider).currentStreak;
  @override
  String? get lastCompletion =>
      (origin as GeminiServiceProvider).lastCompletion;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
