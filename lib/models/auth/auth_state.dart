import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial; // アプリの初期状態

  const factory AuthState.loading() = _Loading; // データ取得中のロード状態

  const factory AuthState.unauthenticated({String? message}) =
      _UnAuth; // ユーザーの認証に失敗

  const factory AuthState.authenticated({required User user}) =
      _Auth; // ユーザーの認証に成功
}
