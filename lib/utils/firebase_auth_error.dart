enum FirebaseAuthError {
  invalidLoginCredentials,
  userDisabled,
  requiresRecentLogin,
  emailAlreadyInUse,
  invalidEmail,
  tooManyRequests,
  expiredActionCode,
  unknown,
}

extension FirebaseAuthErrorExt on FirebaseAuthError {
  /// 表示用メッセージ取得
  String get message => _messages[this]!;

  /// 表示用メッセージ一覧
  static final _messages = {
    FirebaseAuthError.invalidLoginCredentials:
        'メールアドレスまたはパスワードが間違っているか、指定されたユーザーは登録されていません。',
    FirebaseAuthError.userDisabled: '指定されたユーザーは無効化されています。',
    FirebaseAuthError.requiresRecentLogin:
        'アカウント削除などのセキュアな操作を行うにはログインによる再認証が必要です。',
    FirebaseAuthError.emailAlreadyInUse: '既に利用されているメールアドレスです。',
    FirebaseAuthError.invalidEmail: '不正なメールアドレスです。',
    FirebaseAuthError.tooManyRequests: 'アクセスが集中しています。少し時間を置いてから再度お試しください。',
    FirebaseAuthError.expiredActionCode:
        'メールアドレスリンクの期限が切れています。再度認証メールを送信してください。',
    FirebaseAuthError.unknown: '予期しないエラーが発生しました。',
  };

  static FirebaseAuthError fromCode(String code) {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return FirebaseAuthError.invalidLoginCredentials;
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
      default:
        return FirebaseAuthError.unknown;
    }
  }
}
