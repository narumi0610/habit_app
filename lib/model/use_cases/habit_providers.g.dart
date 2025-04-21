// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getCurrentHabitHash() => r'c4bbd1d6cd2753d9065638f7197bf0fb2eb7cd64';

/// See also [getCurrentHabit].
@ProviderFor(getCurrentHabit)
final getCurrentHabitProvider = AutoDisposeFutureProvider<HabitModel?>.internal(
  getCurrentHabit,
  name: r'getCurrentHabitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCurrentHabitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCurrentHabitRef = AutoDisposeFutureProviderRef<HabitModel?>;
String _$updateHabitDaysHash() => r'dbdefa9ed78e2d93f5ec0a6c953c86eb2dcea90d';

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

/// See also [updateHabitDays].
@ProviderFor(updateHabitDays)
const updateHabitDaysProvider = UpdateHabitDaysFamily();

/// See also [updateHabitDays].
class UpdateHabitDaysFamily extends Family<AsyncValue<AsyncValue<void>>> {
  /// See also [updateHabitDays].
  const UpdateHabitDaysFamily();

  /// See also [updateHabitDays].
  UpdateHabitDaysProvider call({
    required String habitId,
    required int currentStreak,
  }) {
    return UpdateHabitDaysProvider(
      habitId: habitId,
      currentStreak: currentStreak,
    );
  }

  @override
  UpdateHabitDaysProvider getProviderOverride(
    covariant UpdateHabitDaysProvider provider,
  ) {
    return call(
      habitId: provider.habitId,
      currentStreak: provider.currentStreak,
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
  String? get name => r'updateHabitDaysProvider';
}

/// See also [updateHabitDays].
class UpdateHabitDaysProvider
    extends AutoDisposeFutureProvider<AsyncValue<void>> {
  /// See also [updateHabitDays].
  UpdateHabitDaysProvider({
    required String habitId,
    required int currentStreak,
  }) : this._internal(
          (ref) => updateHabitDays(
            ref as UpdateHabitDaysRef,
            habitId: habitId,
            currentStreak: currentStreak,
          ),
          from: updateHabitDaysProvider,
          name: r'updateHabitDaysProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateHabitDaysHash,
          dependencies: UpdateHabitDaysFamily._dependencies,
          allTransitiveDependencies:
              UpdateHabitDaysFamily._allTransitiveDependencies,
          habitId: habitId,
          currentStreak: currentStreak,
        );

  UpdateHabitDaysProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitId,
    required this.currentStreak,
  }) : super.internal();

  final String habitId;
  final int currentStreak;

  @override
  Override overrideWith(
    FutureOr<AsyncValue<void>> Function(UpdateHabitDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UpdateHabitDaysProvider._internal(
        (ref) => create(ref as UpdateHabitDaysRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitId: habitId,
        currentStreak: currentStreak,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AsyncValue<void>> createElement() {
    return _UpdateHabitDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpdateHabitDaysProvider &&
        other.habitId == habitId &&
        other.currentStreak == currentStreak;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitId.hashCode);
    hash = _SystemHash.combine(hash, currentStreak.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpdateHabitDaysRef on AutoDisposeFutureProviderRef<AsyncValue<void>> {
  /// The parameter `habitId` of this provider.
  String get habitId;

  /// The parameter `currentStreak` of this provider.
  int get currentStreak;
}

class _UpdateHabitDaysProviderElement
    extends AutoDisposeFutureProviderElement<AsyncValue<void>>
    with UpdateHabitDaysRef {
  _UpdateHabitDaysProviderElement(super.provider);

  @override
  String get habitId => (origin as UpdateHabitDaysProvider).habitId;
  @override
  int get currentStreak => (origin as UpdateHabitDaysProvider).currentStreak;
}

String _$createHabitHash() => r'baa32c41f8dfe2575fb296d50030432429ba42c7';

/// See also [createHabit].
@ProviderFor(createHabit)
const createHabitProvider = CreateHabitFamily();

/// See also [createHabit].
class CreateHabitFamily extends Family<AsyncValue<AsyncValue<void>>> {
  /// See also [createHabit].
  const CreateHabitFamily();

  /// See also [createHabit].
  CreateHabitProvider call({
    required String form,
  }) {
    return CreateHabitProvider(
      form: form,
    );
  }

  @override
  CreateHabitProvider getProviderOverride(
    covariant CreateHabitProvider provider,
  ) {
    return call(
      form: provider.form,
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
  String? get name => r'createHabitProvider';
}

/// See also [createHabit].
class CreateHabitProvider extends AutoDisposeFutureProvider<AsyncValue<void>> {
  /// See also [createHabit].
  CreateHabitProvider({
    required String form,
  }) : this._internal(
          (ref) => createHabit(
            ref as CreateHabitRef,
            form: form,
          ),
          from: createHabitProvider,
          name: r'createHabitProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createHabitHash,
          dependencies: CreateHabitFamily._dependencies,
          allTransitiveDependencies:
              CreateHabitFamily._allTransitiveDependencies,
          form: form,
        );

  CreateHabitProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.form,
  }) : super.internal();

  final String form;

  @override
  Override overrideWith(
    FutureOr<AsyncValue<void>> Function(CreateHabitRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateHabitProvider._internal(
        (ref) => create(ref as CreateHabitRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        form: form,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AsyncValue<void>> createElement() {
    return _CreateHabitProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateHabitProvider && other.form == form;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, form.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateHabitRef on AutoDisposeFutureProviderRef<AsyncValue<void>> {
  /// The parameter `form` of this provider.
  String get form;
}

class _CreateHabitProviderElement
    extends AutoDisposeFutureProviderElement<AsyncValue<void>>
    with CreateHabitRef {
  _CreateHabitProviderElement(super.provider);

  @override
  String get form => (origin as CreateHabitProvider).form;
}

String _$getHabitHistoryHash() => r'03c952b497e25b93199cd43c018c4935d9d89d5c';

/// See also [getHabitHistory].
@ProviderFor(getHabitHistory)
final getHabitHistoryProvider =
    AutoDisposeFutureProvider<List<HabitModel?>>.internal(
  getHabitHistory,
  name: r'getHabitHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getHabitHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetHabitHistoryRef = AutoDisposeFutureProviderRef<List<HabitModel?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
