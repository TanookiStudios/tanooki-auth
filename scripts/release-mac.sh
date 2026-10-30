#!/bin/bash
# Builds a Developer ID signed, notarized, stapled Tanooki Auth DMG in dist/.
# Needs: the "Developer ID Application" certificate and a notarytool keychain profile named "notarytool"
# (the same setup as Maddie's other Mac apps), plus the Developer ID provisioning profile that grants
# iCloud, saved at ~/.tanooki-auth-signing/mac-developer-id.provisionprofile (made with the App Store Connect key).
# `--probe-icloud` builds tool/icloud_probe_main.dart instead of the app, signs it the same way, runs it,
# and stops: proof the signed download can use iCloud Drive. Nothing is notarized or packaged.
set -euo pipefail
PROBE=0; [ "${1:-}" = "--probe-icloud" ] && PROBE=1
cd "$(dirname "$0")/../app"
# The signing identity is looked up from the keychain, so no name lives in this file.
ID=$(security find-identity -v -p codesigning | awk -F'"' '/Developer ID Application: .*\(NPT8NXJ7C8\)/ {print $2; exit}')
[ -n "$ID" ] || { echo "No Developer ID Application certificate for team NPT8NXJ7C8 in the keychain" >&2; exit 1; }
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/+.*//')
APP="build/macos/Build/Products/Release/Tanooki Auth.app"
OUT="../dist"; DMG="$OUT/Tanooki-Auth-$VERSION-mac.dmg"

PROFILE="$HOME/.tanooki-auth-signing/mac-developer-id.provisionprofile"
[ -f "$PROFILE" ] || { echo "Missing $PROFILE (the iCloud permission file for the Mac download)" >&2; exit 1; }

if [ $PROBE = 1 ]; then flutter build macos --release -t tool/icloud_probe_main.dart; else flutter build macos --release; fi
cp "$PROFILE" "$APP/Contents/embedded.provisionprofile"
# Re-sign everything for distribution: hardened runtime, timestamp, no debug entitlements.
find "$APP/Contents/Frameworks" -depth \( -name "*.framework" -o -name "*.dylib" \) -print0 |
  xargs -0 -I{} codesign --force --options runtime --timestamp --sign "$ID" {}
codesign --force --options runtime --timestamp --entitlements macos/Runner/DeveloperID.entitlements --sign "$ID" "$APP"
codesign --verify --deep --strict "$APP"
if codesign -d --entitlements - "$APP" 2>/dev/null | grep -q get-task-allow; then echo "debug entitlement leaked into release" >&2; exit 1; fi
if [ $PROBE = 1 ]; then
  "$APP/Contents/MacOS/Tanooki Auth" & PID=$!
  ( sleep 60; kill $PID 2>/dev/null ) & WATCH=$!
  set +e; wait $PID; CODE=$?; set -e; kill $WATCH 2>/dev/null || true
  rm -rf "$APP"  # the probe must never be mistaken for the real app
  [ $CODE = 0 ] && echo "iCloud probe passed" || { echo "iCloud probe failed (exit $CODE)" >&2; exit 1; }
  exit 0
fi

mkdir -p "$OUT"; STAGE=$(mktemp -d)
ditto "$APP" "$STAGE/Tanooki Auth.app"
ln -s /Applications "$STAGE/Applications"
rm -f "$DMG"
hdiutil create -volname "Tanooki Auth" -srcfolder "$STAGE" -format UDZO -ov "$DMG" >/dev/null
codesign --force --timestamp --sign "$ID" "$DMG"
# Notarize with the "notarytool" keychain profile if there is one, else the App Store Connect API key.
if [ -f "$HOME/.tanooki-auth-signing/asc.env" ] && ! security find-generic-password -s "com.apple.gke.notary.tool" >/dev/null 2>&1; then
  set -a; . "$HOME/.tanooki-auth-signing/asc.env"; set +a
  xcrun notarytool submit "$DMG" --key "$ASC_KEY_PATH" --key-id "$ASC_KEY_ID" --issuer "$ASC_ISSUER_ID" --wait
else
  xcrun notarytool submit "$DMG" --keychain-profile notarytool --wait
fi
xcrun stapler staple "$DMG"
spctl -a -t open --context context:primary-signature -v "$DMG"
echo "Built $DMG"
