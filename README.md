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
- **プログラミング言語 / 主なライブラリなど**
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
- **静的解析（Linter）**
  - very_good_analysis: ^7.0.0 を導入し、コーディングルールを統一
- **認証管理**
  - Firebase Authentication(v5.4.2): ユーザーの認証管理
- **サーバーレス**
  - Cloud Functions: サーバーレス環境で退会処理を自動化
- **DB**
  - Cloud Firestore(v5.6.3): 習慣データの管理
- **API**
  - Gemini API: gemini-1.5-flash-latestモデル。応援メッセージの生成に使用
- **エディタなど**
  - Notion: タスクの管理
  - ChatGPT: サポート
  - Cursor,VSCode: エディタ

## 環境変数の設定について

本プロジェクトでは、APIキーなどの機密情報を `.env` ファイルで管理しています。  
セキュリティ上の理由から `.env` はGitリポジトリには含めておらず、代わりに `.env.sample` を同梱しています。

### 手順：

1. リポジトリ内の `.env.sample` をコピーして `.env` ファイルを作成します。
2. GEMINI_API_KEY を [Gemini API](https://aistudio.google.com/app/apikey) から取得し、.env に記述してください。

## CI/CD

ハビスターでは、以下のCI/CDパイプラインを導入しており、リリース作業を自動化・効率化しています。

### GitHub Actions（Android向け CI）
テスト・ビルド・APK配布を自動化しています。

- `main` ブランチへの push / PR 時に以下を自動実行：
  - Flutterのセットアップ（FVM対応）
  - `.env` ファイルの生成（APIキーを注入）
  - コードのリントチェックとテスト実行
  - Androidアプリ（APK）のビルド
  - ビルド成果物（APK）をアーティファクトとして保存（7日間）

### Xcode Cloud（iOS向け CD）
iOSビルドからTestFlight配信までを自動化しています。

- `main` ブランチへの push をトリガーに以下を自動実行：
  - Flutter環境のセットアップ（FVMでバージョン指定）
  - `.env` 生成と依存関係のインストール（Flutter / CocoaPods）
  - iOSアプリのリリースビルド
  - TestFlightへの自動アップロード

## アーキテクチャ：軽量DDD

このアプリは、**Presentation → Domain → Infrastructure** の3層構成による**軽量DDDアーキテクチャ**を採用しています。

### Presentation層（lib/presentation）

UIの実装をしています

- `screens/`: 画面の実装
- `widgets/`: 共通で使用するウィジェット

### Domain層（lib/model）

アプリが扱うビジネスロジックとデータ構造を定義

- `entities/`: 不変データ構造
- `use_cases/`: ビジネスロジック、状態管理

### Infrastructure層（lib/model）

外部サービスとのやりとり（DB/APIなど）

- `repositories/`: 外部サービス（Firestore、Gemini APIなど）とのやりとりを担当

## テスト

本アプリでは、以下の方針で自動テストを実施しています。

### テストの種類
- ユニットテスト（`test/unit/`）
  - リポジトリの振る舞いを確認するテスト
- ウィジェットテスト（`test/widget/`）
  - 画面表示やユーザー操作に対する挙動を検証

## 状態管理
このアプリではRiverpod v2を使用して状態管理を行っています。

## 参考文献
### 設計
- https://peppermint-sunset-fc2.notion.site/Never-0ee09657e5744cc8bb3c99cf9cdb2cff