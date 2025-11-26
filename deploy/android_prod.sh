#!/bin/bash
# ==============================================================================
# android_prod_shorebird.sh
#
# This script builds your Flutter app using Shorebird in release mode and
# deploys it to the Google Play Store using fastlane supply, with support
# for over-the-air updates via Shorebird.
#
# Requirements:
#   - Flutter installed and configured.
#   - Shorebird CLI installed (https://docs.shorebird.dev/guides/install)
#   - Fastlane installed (e.g., gem install fastlane -NV) and supply set up.
#   - The service_account.json file downloaded from your Google Play Console placed
#     in the root directory of your project.
#   - Proper signing configuration in your Flutter project's Android files.
#   - Shorebird project initialized (shorebird init)
#
# Usage:
#   chmod +x android_prod_shorebird.sh
#   ./android_prod_shorebird.sh [--patch-only]
#
# Options:
#   --patch-only: Only create and release a patch (no app store deployment)
#
# You can configure additional fastlane supply options (such as track, changelog, etc.)
# by modifying the supply command below.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status and fail on pipeline errors.
set -e
set -o pipefail

# Parse command line arguments
PATCH_ONLY=false
for arg in "$@"; do
  case $arg in
    --patch-only)
      PATCH_ONLY=true
      shift
      ;;
    *)
      # Unknown option
      echo "Unknown option: $arg"
      echo "Usage: $0 [--patch-only]"
      exit 1
      ;;
  esac
done

# Define the location of the service account JSON file.
# Use environment variable if set, otherwise check common secure locations
# NEVER store service_account.json in the project directory or git!
if [ -n "$SERVICE_ACCOUNT_JSON" ]; then
  # Use the environment variable if provided
  SERVICE_ACCOUNT_JSON="$SERVICE_ACCOUNT_JSON"
elif [ -f "$HOME/.secrets/lockbloom/service_account.json" ]; then
  # Check user's secure directory
  SERVICE_ACCOUNT_JSON="$HOME/.secrets/lockbloom/service_account.json"
elif [ -f "$HOME/.config/lockbloom/service_account.json" ]; then
  # Alternative secure location
  SERVICE_ACCOUNT_JSON="$HOME/.config/lockbloom/service_account.json"
else
  # Default to project root (for backward compatibility, but warn)
  SERVICE_ACCOUNT_JSON="./service_account.json"
  echo "WARNING: Using service_account.json from project root. Consider moving to a secure location."
  echo "Recommended: Store at \$HOME/.secrets/lockbloom/service_account.json"
  echo "Or set SERVICE_ACCOUNT_JSON environment variable to specify the path."
fi

PACKAGE_NAME="com.dn.lockbloom"

# Check if Shorebird CLI is installed
if ! command -v shorebird &> /dev/null; then
  echo "Error: Shorebird CLI is not installed. Please install it from https://docs.shorebird.dev/guides/install"
  exit 1
fi

# Check if this is a Shorebird project
if [ ! -f "shorebird.yaml" ]; then
  echo "Error: shorebird.yaml not found. Please run 'shorebird init' to initialize your project with Shorebird."
  exit 1
fi

# Check if the service account file exists (only needed for full deployment).
if [ "$PATCH_ONLY" = false ] && [ ! -f "$SERVICE_ACCOUNT_JSON" ]; then
  echo "Error: $SERVICE_ACCOUNT_JSON not found. Please download it from your Google Play Console and place it in the project root."
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.env"
NEW_ENV="PROD"

if [[ -f "$ENV_FILE" ]]; then
  echo "→ Updating $ENV_FILE: ENVIRONMENT=${NEW_ENV}"
  # Use sed to replace or add the ENVIRONMENT= line
  if grep -q '^ENVIRONMENT=' "$ENV_FILE"; then
    # Replace existing
    sed -i.bak -E "s/^ENVIRONMENT=.*/ENVIRONMENT=${NEW_ENV}/" "$ENV_FILE"
  else
    # Append if missing
    echo -e "\nENVIRONMENT=${NEW_ENV}" >> "$ENV_FILE"
  fi
  rm -f "${ENV_FILE}.bak"
else
  echo "→ .env not found; creating with ENVIRONMENT=${NEW_ENV}"
  echo "ENVIRONMENT=${NEW_ENV}" > "$ENV_FILE"
fi

# ──────────────────────────────────────────────────────────────────────────────
# Function to update the version in pubspec.yaml by incrementing the build number by 1.
# Note: For patches, we might not want to increment the version number.
# ──────────────────────────────────────────────────────────────────────────────
update_version() {
  echo "----------------------------------------"
  echo "Updating version in pubspec.yaml..."
  echo "----------------------------------------"

  if [ ! -f "pubspec.yaml" ]; then
    echo "Error: pubspec.yaml not found!"
    exit 1
  fi

  VERSION_LINE=$(grep '^version:' pubspec.yaml || true)
  if [ -z "$VERSION_LINE" ]; then
    echo "Error: No version field found in pubspec.yaml."
    exit 1
  fi

  echo "Current version line: $VERSION_LINE"

  if [[ $VERSION_LINE =~ version:\ ([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+) ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    BUILD="${BASH_REMATCH[4]}"

    NEW_BUILD=$((BUILD + 1))
    NEW_PATCH=$((PATCH + 1))
    NEW_VERSION="${MAJOR}.${MINOR}.${NEW_PATCH}+${NEW_BUILD}"

    echo "New version will be: ${NEW_VERSION}"
    sed -i.bak "s/^version: .*/version: ${NEW_VERSION}/" pubspec.yaml
    echo "pubspec.yaml updated successfully."
  else
    echo "Error: Could not parse the version string. Ensure it is in the format: MAJOR.MINOR.PATCH+BUILD"
    exit 1
  fi
}

# ──────────────────────────────────────────────────────────────────────────────
# Function to create and deploy a Shorebird patch
# ──────────────────────────────────────────────────────────────────────────────
create_patch() {
  echo "=== Creating Shorebird Patch ==="

  # Get Flutter packages
  echo "Getting Flutter packages..."
  flutter pub get

  # Create and release patch
  echo "Creating Shorebird patch for Android..."
  shorebird patch android --release-version="$(grep '^version:' pubspec.yaml | sed 's/version: //')" --flutter-version 3.38.1

  echo "=== Patch created and deployed successfully ==="
}

# ──────────────────────────────────────────────────────────────────────────────
# Function for full app store deployment
# ──────────────────────────────────────────────────────────────────────────────
full_deployment() {
  # Export for subsequent commands
  export ENVIRONMENT="$NEW_ENV"
  echo "→ Using ENVIRONMENT=$ENVIRONMENT"

  # Update version before build (for full releases)
  update_version

  echo "=== Getting Flutter packages ==="
  flutter pub get

  echo "=== Building Android App Bundle (AAB) with Shorebird ==="
  # Use Shorebird release command instead of flutter build appbundle
  shorebird release android --flutter-version 3.38.1

  # Define the expected path to the built App Bundle.
  APP_BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"

  if [ ! -f "$APP_BUNDLE_PATH" ]; then
    echo "Error: App bundle not found at $APP_BUNDLE_PATH"
    exit 1
  fi

  echo "App bundle successfully built at $APP_BUNDLE_PATH"

  # Check if fastlane is installed.
  if ! command -v fastlane &> /dev/null; then
    echo "Error: fastlane is not installed. Install fastlane using 'sudo gem install fastlane -NV'"
    exit 1
  fi

  echo "=== Deploying to Google Play Store via fastlane supply ==="
  # Deploy the app bundle.
  # Adjust the --track value as needed (e.g., alpha, beta, production)
  fastlane supply \
    --package_name "$PACKAGE_NAME" \
    --aab "$APP_BUNDLE_PATH" \
    --json_key "$SERVICE_ACCOUNT_JSON" \
    --track production \
    --skip_upload_images \
    --skip_upload_screenshots

  echo "=== Full deployment process completed successfully ==="
}

# ──────────────────────────────────────────────────────────────────────────────
# Main execution logic
# ──────────────────────────────────────────────────────────────────────────────

if [ "$PATCH_ONLY" = true ]; then
  echo "=== Running in PATCH-ONLY mode ==="
  create_patch
else
  echo "=== Running FULL DEPLOYMENT mode ==="
  full_deployment
fi

echo "=== Script execution completed successfully ==="