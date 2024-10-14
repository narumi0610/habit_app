// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$setGoalHash() => r'976c3e388c6628c0b51912c83fbace9041e7331e';

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

/// See also [setGoal].
@ProviderFor(setGoal)
const setGoalProvider = SetGoalFamily();

/// See also [setGoal].
class SetGoalFamily extends Family<AsyncValue<void>> {
  /// See also [setGoal].
  const SetGoalFamily();

  /// See also [setGoal].
  SetGoalProvider call({
    required String form,
  }) {
    return SetGoalProvider(
      form: form,
    );
  }

  @override
  SetGoalProvider getProviderOverride(
    covariant SetGoalProvider provider,
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
  String? get name => r'setGoalProvider';
}

/// See also [setGoal].
class SetGoalProvider extends AutoDisposeFutureProvider<void> {
  /// See also [setGoal].
  SetGoalProvider({
    required String form,
  }) : this._internal(
          (ref) => setGoal(
            ref as SetGoalRef,
            form: form,
          ),
          from: setGoalProvider,
          name: r'setGoalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setGoalHash,
          dependencies: SetGoalFamily._dependencies,
          allTransitiveDependencies: SetGoalFamily._allTransitiveDependencies,
          form: form,
        );

  SetGoalProvider._internal(
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
    FutureOr<void> Function(SetGoalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SetGoalProvider._internal(
        (ref) => create(ref as SetGoalRef),
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
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SetGoalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SetGoalProvider && other.form == form;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, form.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SetGoalRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `form` of this provider.
  String get form;
}

class _SetGoalProviderElement extends AutoDisposeFutureProviderElement<void>
    with SetGoalRef {
  _SetGoalProviderElement(super.provider);

  @override
  String get form => (origin as SetGoalProvider).form;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
