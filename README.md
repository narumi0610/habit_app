# ハビスター - AIが応援してくれる習慣サポートアプリ

## 概要
ハビスターは、ユーザーが目標達成までの進捗を視覚化し、AIの応援メッセージでモチベーションを維持しながら日々の習慣を管理するためのアプリです。

- iOS : [AppStore](https://apps.apple.com/jp/app/%E3%83%8F%E3%83%93%E3%82%B9%E3%82%BF%E3%83%BC/id6692625184?platform=iphone)
- Android : クローズドテスト中
## 主な機能
- 毎日1回のタップで目標を達成（1日1回のみ）
- AIが応援:その日の目標が達成されたらAIから応援メッセージが送られる
- 指定した時間で通知がくる
- iPhoneやAndroidのウィジェットから継続日数を確認
- 30回のタップで目標を達成、進捗が視覚化される
- 達成した目標の履歴を確認


## スクリーンショット
### Android
<img src="https://github.com/narumi0610/habit_app/blob/main/images/android_home_screen.png?raw=true" width="300">
<img src="https://github.com/narumi0610/habit_app/blob/main/images/android_widget.png?raw=true" width="300">

### iOS
<img src="https://github.com/narumi0610/habit_app/blob/main/images/ios_home_screen.png?raw=true" width="300">
<img src="https://github.com/narumi0610/habit_app/blob/main/images/ios_widget.png?raw=true" width="300">
<img width="314" alt="スクリーンショット 2025-03-05 15 31 39" src="https://github.com/user-attachments/assets/da67a7d0-993d-4d29-bd8b-197a06f7cc01" />


https://github.com/user-attachments/assets/caf8c161-0eb9-46ae-989b-2ad7db23b792


## 技術スタック
- プログラミング言語 / 主なライブラリなど
  - Flutter v3.27.3: クロスプラットフォームアプリ開発に使用
    - flutter_riverpod: ^2.1.3
    - riverpod_annotation: ^2.5.3
    - riverpod_generator: ^2.4.0
    - freezed: ^2.4.2
    - home_widget: ^0.7.0
    - flutter_local_notifications: ^17.2.4
  - Swift v6.0.3: iOSホームウィジェットのカスタムデザインに使用
  - Kotlin v2.1.10: Androidホームウィジェットのカスタムデザインに使用
  - JavaScript: Firebase Functionsの実装に使用
- 認証管理
  - Firebase Authentication(v5.4.2): ユーザーの認証管理
- サーバーレス
  - Cloud Functions: サーバーレス環境で退会処理を自動化
- DB
  - Cloud Firestore(v5.6.3): 習慣データの管理
- API
  - Gemini API: gemini-1.5-flash-latestモデル。応援メッセージの生成に使用
- CI/CD
  - GitHub Actions: テスト、リントチェック、APKアーティファクトのアップロード
- エディタなど
  - Notion: タスクの管理
  - ChatGPT: サポート
  - Cursor,VSCode: エディタ

## アーキテクチャ

このアプリはMVVMアーキテクチャに基づいて構築されています。

### Model
Model層は、データやビジネスロジックを管理します。データベースやAPIからデータを取得し、必要な処理を行います。

- ディレクトリ: `models`, `repositories`
  - `models/habit/habit_model.dart`: 習慣データを表すモデル
  - `repositories/habit_repository.dart`: 習慣データの操作を行うリポジトリ

### View
View層は、UIを担当します。画面レイアウトやUIのイベントを処理し、ViewModel層からのデータを表示します。

- ディレクトリ: `screens`
  - `screens/home_screen.dart`: ホーム画面のUI

### ViewModel
ViewModel層は、ViewとModelの間を仲介し、UIに表示するためのデータを処理します。状態管理やビジネスロジックを担当し、UIを更新する際に使用されます。

- ディレクトリ: `providers`
  - `providers/auth_providers.dart`: 認証に関する状態管理
  - `providers/habit_providers.dart`: 習慣に関する状態管理

## 状態管理
このアプリではRiverpod v2を使用して状態管理を行っています。
