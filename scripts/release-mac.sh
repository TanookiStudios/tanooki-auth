#!/bin/bash
# Builds a Developer ID signed, notarized, stapled Tanooki Auth DMG in dist/.
# Needs: the "Developer ID Application" certificate and a notarytool keychain profile named "notarytool"
# (the same setup as Maddie's other Mac apps).
set -euo pipefail
cd "$(dirname "$0")/../app"
# The signing identity is looked up from the keychain, so no name lives in this file.
ID=$(security find-identity -v -p codesigning | awk -F'"' '/Developer ID Application: .*\(NPT8NXJ7C8\)/ {print $2; exit}')
[ -n "$ID" ] || { echo "No Developer ID Application certificate for team NPT8NXJ7C8 in the keychain" >&2; exit 1; }
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/+.*//')
APP="build/macos/Build/Products/Release/Tanooki Auth.app"
OUT="../dist"; DMG="$OUT/Tanooki-Auth-$VERSION-mac.dmg"

flutter build macos --release
# Re-sign everything for distribution: hardened runtime, timestamp, no debug entitlements.
find "$APP/Contents/Frameworks" -depth \( -name "*.framework" -o -name "*.dylib" \) -print0 |
  xargs -0 -I{} codesign --force --options runtime --timestamp --sign "$ID" {}
codesign --force --options runtime --timestamp --entitlements macos/Runner/Release.entitlements --sign "$ID" "$APP"
codesign --verify --deep --strict "$APP"
if codesign -d --entitlements - "$APP" 2>/dev/null | grep -q get-task-allow; then echo "debug entitlement leaked into release" >&2; exit 1; fi

mkdir -p "$OUT"; STAGE=$(mktemp -d)
ditto "$APP" "$STAGE/Tanooki Auth.app"
ln -s /Applications "$STAGE/Applications"
rm -f "$DMG"
hdiutil create -volname "Tanooki Auth" -srcfolder "$STAGE" -format UDZO -ov "$DMG" >/dev/null
codesign --force --timestamp --sign "$ID" "$DMG"
xcrun notarytool submit "$DMG" --keychain-profile notarytool --wait
xcrun stapler staple "$DMG"
spctl -a -t open --context context:primary-signature -v "$DMG"
echo "Built $DMG"
