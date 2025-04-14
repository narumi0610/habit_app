// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gemini_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$geminiHash() => r'251b3ed71b3d0049cd1d2349c861d7a68161f364';

/// Gemini APIのクライアントを提供するプロバイダー
/// 環境変数からAPIキーを取得し、GenerativeModelを返す
///
/// Copied from [gemini].
@ProviderFor(gemini)
final geminiProvider = AutoDisposeProvider<GenerativeModel>.internal(
  gemini,
  name: r'geminiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$geminiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeminiRef = AutoDisposeProviderRef<GenerativeModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
