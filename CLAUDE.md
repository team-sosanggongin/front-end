# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter mobile app ("platform") for 소상공인 (small business owners) platform. Currently in early MVP stage focused on push notification infrastructure. The app connects to a Spring Boot backend API.

## Common Commands

```bash
# Run the app
flutter run

# Get dependencies
flutter pub get

# Run code generation (Riverpod generators)
dart run build_runner build --delete-conflicting-outputs

# Run all tests
flutter test

# Run a single test file
flutter test test/services/notification/notification_test.dart

# Analyze code
flutter analyze
```

## Architecture

- **State Management**: Riverpod (with code generation via `riverpod_generator` + `build_runner`)
- **Routing**: GoRouter, defined in `lib/core/router/router.dart`
- **HTTP Client**: Dio (not `http` package)
- **Push Notifications**: Firebase Cloud Messaging (FCM)

### Environment Configuration

`lib/utils/env_config.dart` defines four environments via `AppEnv` enum:
- `local` — mock mode, no server calls
- `localApi` — local Spring Boot server at `10.0.2.2:8080` (Android emulator localhost)
- `stg` / `prod` — staging and production servers

Environment is set manually in `main.dart`. When `AppEnv.local`, `DeviceTokenService` skips HTTP calls.

### Notification Service Layer

`lib/services/notification/` uses a provider pattern with dependency injection:
- `PushProvider` — abstract interface for push services
- `FcmPushProvider` — Firebase implementation
- `DeviceTokenService` — syncs FCM token to Spring Boot backend via Dio
- `PushNotificationHandler` — orchestrates initialization: permissions → topic subscription → token sync → listeners
- `notification_providers.dart` — Riverpod provider wiring

Tests use `FakePushProvider` implementing `PushProvider` to test logic without Firebase dependencies.

## Key Conventions

- Package name: `platform` (imports use `package:platform/...`)
- Android namespace: `com.example.platform`
- Dart SDK: `^3.11.1`
- Generated files (`*.g.dart`, `*.freezed.dart`) are gitignored — run `build_runner` after changing annotated code
- Korean is used in comments and log messages throughout the codebase
