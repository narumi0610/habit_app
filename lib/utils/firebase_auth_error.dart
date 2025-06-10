enum FirebaseAuthError {
  invalidCredentials,
  userDisabled,
  requiresRecentLogin,
  emailAlreadyInUse,
  invalidEmail,
  tooManyRequests,
  expiredActionCode,
  invalidActionCode,
  unknown,
}

extension FirebaseAuthErrorExt on FirebaseAuthError {
  /// 表示用メッセージ取得
  String get message => _getMessage();

  String _getMessage() {
    const defaultMessage = '予期しないエラーが発生しました。';
    return _messages[this] ?? defaultMessage;
  }

  /// 表示用メッセージ一覧
  static final _messages = {
    FirebaseAuthError.invalidCredentials:
        'メールアドレスまたはパスワードが間違っているか、指定されたユーザーは登録されていません。',
    FirebaseAuthError.userDisabled: '指定されたユーザーは無効化されています。',
    FirebaseAuthError.requiresRecentLogin:
        'アカウント削除などのセキュアな操作を行うにはログインによる再認証が必要です。',
    FirebaseAuthError.emailAlreadyInUse: '既に利用されているメールアドレスです。',
    FirebaseAuthError.invalidEmail: '不正なメールアドレスです。',
    FirebaseAuthError.tooManyRequests: 'アクセスが集中しています。少し時間を置いてから再度お試しください。',
    FirebaseAuthError.expiredActionCode:
        'メールアドレスリンクの期限が切れています。再度認証メールを送信してください。',
    FirebaseAuthError.invalidActionCode:
        'メールリンクが無効です。リンクが壊れているか、既に使用されている可能性があります。',
    FirebaseAuthError.unknown: '予期しないエラーが発生しました。',
  };

  static FirebaseAuthError fromCode(String code) {
    switch (code) {
      case 'invalid-credential':
        return FirebaseAuthError.invalidCredentials;
      case 'user-disabled':
        return FirebaseAuthError.userDisabled;
      case 'requires-recent-login':
        return FirebaseAuthError.requiresRecentLogin;
      case 'email-already-in-use':
        return FirebaseAuthError.emailAlreadyInUse;
      case 'invalid-email':
        return FirebaseAuthError.invalidEmail;
      case 'too-many-requests':
        return FirebaseAuthError.tooManyRequests;
      case 'expired-action-code':
        return FirebaseAuthError.expiredActionCode;
      case 'invalid-action-code':
        return FirebaseAuthError.invalidActionCode;
      default:
        return FirebaseAuthError.unknown;
    }
  }
}
