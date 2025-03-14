#!/bin/sh

# スクリプトが失敗した場合にエラーを返す
set -e

# スクリプトの実行ディレクトリをリポジトリのルートに変更
cd $CI_PRIMARY_REPOSITORY_PATH

# 指定されたFVMのバージョンを取得
FLUTTER_VERSION=$(cat .fvm/fvm_config.json | grep "flutter" | cut -d '"' -f 4)

# Flutterのリポジトリをクローン
git clone https://github.com/flutter/flutter.git --depth 1 -b $FLUTTER_VERSION $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Flutterのバージョンを表示
flutter --version

# FlutterのiOS用アーティファクトをインストール
flutter precache --ios

# .env ファイルを作成
if [ ! -f .env ]; then
  echo "GEMINI_API_KEY=${GEMINI_API_KEY}" > .env
  echo ".env ファイルを作成しました。"
else
  echo ".env ファイルは既に存在します。"
fi

# Flutterの依存関係をインストール
flutter pub get

# CocoaPodsをインストール
HOMEBREW_NO_AUTO_UPDATE=1 # Homebrewの自動更新を無効化
brew install cocoapods

# CocoaPodsの依存関係をインストール
cd ios && pod install

# リポジトリのルートに戻る
cd $CI_PRIMARY_REPOSITORY_PATH

# ディレクトリの内容を表示
echo "ディレクトリの内容を表示"
ls -la

# pubspec.yamlの内容を表示
echo "pubspec.yamlの内容を表示"
cat pubspec.yaml

echo "ビルド開始"
# dart-defineを使用してAPIキーを渡す
flutter build ios --release --no-codesign

exit 0