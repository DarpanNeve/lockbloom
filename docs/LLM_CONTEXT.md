# LockBloom Project Context

## Overview

LockBloom is a secure password management application built with Flutter. It focuses on privacy, security, and a premium user experience (APEX protocol).

## Architecture

- **Framework**: Flutter
- **State Management**: GetX
- **Localization**: GetX Translations
- **Theme**: Custom AppTheme with Light/Dark modes
- **Architecture**: MVC/Clean Architecture (Modules, Controllers, Views, Repositories)

## Core Features

1.  **Password Management**: Add, View, Edit, Delete passwords.
2.  **Encryption**: Local encryption for data storage.
3.  **Authentication**: Biometric and PIN support.
4.  **Premium Features**: Unlocked via in-app purchases (RevenueCat).
5.  **Offline First**: Data stored locally.

## Design Philosophy (APEX)

- **Zero Compromises**: Production-grade quality.
- **Craft, Don't Code**: Elegant, self-documenting code.
- **Visual Excellence**: Animations, safe areas, responsive design.
- **Accessibility**: WCAG AA compliance (semantics, contrast).

## Current Task Context

- **Fix**: Navigation button overlap in bottom sheets (Add Password, Filter).
- **Localization**: Implement missing translations for Premium, Add Password, and Filter screens.
- **Cleanup**: Ensure no hardcoded strings remain in these modules.

## Recent Updates

- **NDK**: Updated to version `29.0.14206865` in `android/app/build.gradle.kts`.
- **Troubleshooting**: Performed deep clean (Project clean + Gradle cache clean) to resolve artifact transformation errors.
