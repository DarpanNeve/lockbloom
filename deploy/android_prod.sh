#!/bin/bash
# ==============================================================================
# android_prod.sh
#
# This script builds your Flutter app in release mode and deploys it to the
# Google Play Store using fastlane supply.
#
# Requirements:
#   - Flutter installed and configured.
#   - Fastlane installed (e.g., gem install fastlane -NV) and supply set up.
#   - The service_account.json file downloaded from your Google Play Console placed
#     in the root directory of your project.
#   - Proper signing configuration in your Flutter project's Android files.
#
# Usage:
#   chmod +x android_prod.sh
#   ./android_prod.sh
#
# You can configure additional fastlane supply options (such as track, changelog, etc.)
# by modifying the supply command below.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status and fail on pipeline errors.
set -e
set -o pipefail

# Define the location of the service account JSON file.
SERVICE_ACCOUNT_JSON="./service_account.json"
PACKAGE_NAME="com.dn.lockbloom"
# Check if the service account file exists.
if [ ! -f "$SERVICE_ACCOUNT_JSON" ]; then
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
# 3) Export for subsequent commands
# ──────────────────────────────────────────────────────────────────────────────
export ENVIRONMENT="$NEW_ENV"
echo "→ Using ENVIRONMENT=$ENVIRONMENT"

# 4) Update version before build
update_version

echo "=== Getting Flutter packages ==="
flutter pub get

echo "=== Building Android App Bundle (AAB) ==="
flutter build appbundle --release

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

echo "=== Deployment process completed successfully. ==="
