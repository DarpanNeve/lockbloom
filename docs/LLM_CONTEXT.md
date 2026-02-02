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

## Recent Updates

- **Professional UI Redesign**:
  - Overhauled **Splash, Auth, Home, Vault, Settings, Password Detail, and Premium** views for a consistent, premium aesthetic.
  - Updated `ThemeService` with refined typography, card themes, and input styles.
  - Standardized specific UI components like `PasswordEntryCard` and `PasswordGeneratorCard`.
  - Implemented sticky headers and improved scrolling layouts (Slivers) where appropriate.
  - Finalized localization for all buttons, labels, and action sheets.
- **NDK**: Updated to version `29.0.14206865`.
- **Tooling**: Detected `fvm` usage in the environment.
- **iOS Deployment Target**: Increased to `15.0` to support latest Firebase Analytics dependencies.
- **Face ID Permission**: Added `NSFaceIDUsageDescription` to `Info.plist` to enable Face ID and prevent fallback to device passcode.
- **UI Optimization**: Optimized `PasswordDetailView` specifically reducing card padding and font sizes for a denser information display.
- **Card Redesign**: Overhauled `PasswordDetailView` with "Digital Pass" aesthetic and `PasswordEntryCard` (list view) with a sleek, compact design.
- **Card Functionality**: Restored website URL display and "Copy Username" action button to the list card while preserving the new compact layout.

## Current Task Context

The application has undergone a comprehensive visual redesign to meet APEX standards. All core screens now feature a professional, polished look with proper localization and theming. The code has been validated via `fvm flutter analyze`.
