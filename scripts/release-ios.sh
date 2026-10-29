#!/bin/bash
# Archives Tanooki Auth for iOS and uploads it to App Store Connect / TestFlight.
# Bump the build number in app/pubspec.yaml (the part after +) first; Apple rejects repeats.
# Uses an App Store Connect API key, since Xcode has no account signed in. Its details live outside
# the repo in ~/.tanooki-auth-signing/asc.env, which sets ASC_KEY_PATH, ASC_KEY_ID and ASC_ISSUER_ID.
set -euo pipefail
source "$HOME/.tanooki-auth-signing/asc.env"
cd "$(dirname "$0")/../app"
AUTH=(-allowProvisioningUpdates -authenticationKeyPath "$ASC_KEY_PATH"
      -authenticationKeyID "$ASC_KEY_ID" -authenticationKeyIssuerID "$ASC_ISSUER_ID")
ARCHIVE=build/ios/TanookiAuth.xcarchive
flutter build ios --config-only --release
rm -rf "$ARCHIVE" build/ios/export
(cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release \
  -destination generic/platform=iOS -archivePath "../$ARCHIVE" "${AUTH[@]}" archive)
xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportOptionsPlist ios/ExportOptions.plist \
  -exportPath build/ios/export "${AUTH[@]}"
