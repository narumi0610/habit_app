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

# Flutterの依存関係をインストール
flutter pub get

# CocoaPodsをインストール
HOMEBREW_NO_AUTO_UPDATE=1 # Homebrewの自動更新を無効化
brew install cocoapods

# CocoaPodsの依存関係をインストール
cd ios && pod install

# dart-defineを使用してAPIキーを渡す
flutter build ios --config-only --dart-define=GEMINI_API_KEY=${GEMINI_API_KEY}


exit 0