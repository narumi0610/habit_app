# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This Flutter app uses a lightweight Domain-Driven Design (DDD) architecture:

- **Presentation Layer** (`lib/presentation/`): UI screens and components
- **Domain Layer**: 
  - `lib/model/entities/`: Domain entities (habit, notification settings)
  - `lib/model/use_cases/`: Use cases/providers for business logic
- **Data Layer**:
  - `lib/model/repositories/`: Repository interfaces and implementations
  - `lib/model/services/`: External services (Gemini API)

State management is handled by Riverpod throughout the application.

## Commands

### Development Setup
```bash
# Install dependencies
flutter pub get

# Generate code (Freezed models, Riverpod providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Create .env file with:
echo "GEMINI_API_KEY=your_api_key" > .env
```

### Building
```bash
# Development build
flutter build apk --flavor staging --dart-define=PRODUCTION=false

# Production build
flutter build apk --flavor production --dart-define=PRODUCTION=true --release

# iOS production build
flutter build ios --flavor production --dart-define=PRODUCTION=true --release
```

### Testing & Quality
```bash
# Run linter
flutter analyze

# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_repository_test.dart

# Clean build artifacts
flutter clean
```

## Key Dependencies

- **State Management**: `flutter_riverpod` with code generation
- **Models**: `freezed` for immutable data classes
- **Firebase**: Authentication, Firestore database
- **AI**: `google_generative_ai` for Gemini API integration
- **Notifications**: `flutter_local_notifications`, `workmanager`
- **Widgets**: `home_widget` for iOS/Android home screen widgets

## Environment Configuration

The app uses flavor-based environments (staging/production):
- Requires `.env` file with `GEMINI_API_KEY`
- Firebase configs: `firebase_options_staging.dart` and `firebase_options_production.dart`
- Android: Configured through build flavors in `android/app/build.gradle`
- iOS: Configured through schemes in Xcode

## Widget Implementation

- **Android**: Kotlin-based widget in `android/app/src/main/kotlin/`
- **iOS**: Swift-based widget in `ios/habit_app/`
- Both platforms use `home_widget` package for Flutter-native communication

## Firebase Functions

JavaScript-based Cloud Functions in `functions/` directory handle automated user deletion.