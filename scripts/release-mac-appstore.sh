#!/bin/bash
# Builds Tanooki Auth for the Mac App Store, packages a signed .pkg in dist/, uploads it to
# App Store Connect (the same app record as iPhone, universal purchase) and waits until the
# API shows the macOS build. It never submits for review.
# Bump the build number in app/pubspec.yaml (the part after +) first; Apple rejects repeats.
# Needs, in the login keychain: "Apple Distribution" and "3rd Party Mac Developer Installer"
# certificates for team NPT8NXJ7C8; and ~/.tanooki-auth-signing/asc.env (App Store Connect key).
# The Mac App Store provisioning profile is fetched (or made once) through the API.
# `--no-upload` stops after the .pkg is built and checked.
set -euo pipefail
UPLOAD=1; [ "${1:-}" = "--no-upload" ] && UPLOAD=0
set -a; . "$HOME/.tanooki-auth-signing/asc.env"; set +a
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API() { local out; out=$(node "$ROOT/scripts/asc-api.mjs" "$@") || { echo "App Store Connect API $1 $2 failed: $out" >&2; return 1; }; printf "%s\n" "$out" | tail -n +2; }
APP_ID=6828230444; BUNDLE_RES=D3SUC4SN48; TEAM=NPT8NXJ7C8
cd "$ROOT/app"

ident() { security find-identity -v $2 | awk -F'"' -v p="$1" 'index($2, p) == 1 && $2 ~ /\('"$TEAM"'\)/ {print $2; exit}'; }
SIGN=$(ident "Apple Distribution: " "-p codesigning")
PKG_SIGN=$(ident "3rd Party Mac Developer Installer: " "")
[ -n "$SIGN" ] || { echo "No Apple Distribution certificate for $TEAM in the keychain" >&2; exit 1; }
[ -n "$PKG_SIGN" ] || { echo "No 3rd Party Mac Developer Installer certificate for $TEAM in the keychain" >&2; exit 1; }

# The API's id for our Apple Distribution certificate, matched by serial number.
SERIAL=$(security find-certificate -c "$SIGN" -p | openssl x509 -noout -serial | cut -d= -f2)
CERT_ID=$(API GET "/v1/certificates?filter[certificateType]=DISTRIBUTION&limit=200" |
  SERIAL="$SERIAL" node -e 'const d=JSON.parse(require("fs").readFileSync(0));const c=d.data.find(c=>c.attributes.serialNumber.toUpperCase()===process.env.SERIAL.toUpperCase());if(!c)process.exit(1);console.log(c.id)') ||
  { echo "Apple Distribution certificate $SERIAL isn't on the developer account" >&2; exit 1; }

# Reuse the active Mac App Store profile for this app (it must include our certificate), else make one.
PROFILE="$ROOT/app/build/macos/appstore.provisionprofile"; mkdir -p "$(dirname "$PROFILE")"
PROFILE_ID=$(API GET "/v1/profiles?filter[profileType]=MAC_APP_STORE&filter[profileState]=ACTIVE&fields[profiles]=bundleId,certificates&include=bundleId,certificates&fields[bundleIds]=identifier&fields[certificates]=serialNumber&limit=200" |
  CERT_ID="$CERT_ID" BUNDLE_RES="$BUNDLE_RES" node -e '
  const d=JSON.parse(require("fs").readFileSync(0));
  const p=d.data.find(p=>p.relationships.bundleId.data.id===process.env.BUNDLE_RES&&
    p.relationships.certificates.data.some(c=>c.id===process.env.CERT_ID));
  if(p)console.log(p.id)')
if [ -z "$PROFILE_ID" ]; then
  echo "Making a Mac App Store provisioning profile"
  BODY=$(printf '{"data":{"type":"profiles","attributes":{"name":"Tanooki Auth Mac App Store","profileType":"MAC_APP_STORE"},"relationships":{"bundleId":{"data":{"type":"bundleIds","id":"%s"}},"certificates":{"data":[{"type":"certificates","id":"%s"}]}}}}' "$BUNDLE_RES" "$CERT_ID")
  PROFILE_ID=$(API POST /v1/profiles "$BODY" | node -e 'console.log(JSON.parse(require("fs").readFileSync(0)).data.id)')
fi
API GET "/v1/profiles/$PROFILE_ID?fields[profiles]=profileContent" |
  node -e 'process.stdout.write(Buffer.from(JSON.parse(require("fs").readFileSync(0)).data.attributes.profileContent,"base64"))' > "$PROFILE"
security cms -D -i "$PROFILE" | grep -q "iCloud.com.tanookistudios.auth" || { echo "The profile doesn't grant the iCloud container" >&2; exit 1; }

flutter build macos --release
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //; s/+.*//')
BUILD=$(grep '^version:' pubspec.yaml | sed 's/.*+//')
SRC="build/macos/Build/Products/Release/Tanooki Auth.app"
APP="build/macos/appstore/Tanooki Auth.app"
rm -rf "$(dirname "$APP")"; mkdir -p "$(dirname "$APP")"; ditto "$SRC" "$APP"
# Store-only Info.plist keys (same answers as the iPhone app), added here so the Developer ID build is untouched.
/usr/libexec/PlistBuddy -c "Add :LSApplicationCategoryType string public.app-category.utilities" "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Add :ITSAppUsesNonExemptEncryption bool false" "$APP/Contents/Info.plist"
cp "$PROFILE" "$APP/Contents/embedded.provisionprofile"
find "$APP/Contents/Frameworks" -depth \( -name "*.framework" -o -name "*.dylib" \) -print0 |
  xargs -0 -I{} codesign --force --timestamp --sign "$SIGN" {}
# DeveloperID.entitlements is the sandbox set plus iCloud, which is exactly what the store build needs too.
codesign --force --timestamp --entitlements macos/Runner/DeveloperID.entitlements --sign "$SIGN" "$APP"
codesign --verify --deep --strict "$APP"
ENT=$(codesign -d --entitlements - --xml "$APP" 2>/dev/null)
if printf "%s" "$ENT" | grep -q get-task-allow; then echo "debug entitlement leaked into release" >&2; exit 1; fi
printf "%s" "$ENT" | grep -q app-sandbox && printf "%s" "$ENT" | grep -q iCloud.com.tanookistudios.auth ||
  { echo "Store build is missing the sandbox or iCloud entitlement" >&2; exit 1; }

mkdir -p "$ROOT/dist"; PKG="$ROOT/dist/Tanooki-Auth-$VERSION-$BUILD-macappstore.pkg"
rm -f "$PKG"
productbuild --component "$APP" /Applications --sign "$PKG_SIGN" "$PKG"
pkgutil --check-signature "$PKG" | grep -q "3rd Party Mac Developer Installer" || { echo ".pkg isn't installer-signed" >&2; exit 1; }
echo "Built $PKG"
[ $UPLOAD = 1 ] || exit 0

xcrun altool --validate-app -f "$PKG" -t macos --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID" --p8-file-path "$ASC_KEY_PATH"
xcrun altool --upload-app -f "$PKG" -t macos --apiKey "$ASC_KEY_ID" --apiIssuer "$ASC_ISSUER_ID" --p8-file-path "$ASC_KEY_PATH"

# Upload accepted is not the same as the build existing: poll the API until the macOS build shows up.
for i in $(seq 1 60); do
  STATE=$(API GET "/v1/builds?filter[app]=$APP_ID&filter[version]=$BUILD&filter[preReleaseVersion.platform]=MAC_OS&filter[preReleaseVersion.version]=$VERSION&fields[builds]=version,processingState" |
    node -e 'const d=JSON.parse(require("fs").readFileSync(0)).data;console.log(d[0]?`${d[0].id} ${d[0].attributes.processingState}`:"")')
  if [ -n "$STATE" ]; then
    echo "macOS build $VERSION ($BUILD): $STATE"
    case "$STATE" in *VALID) exit 0;; *FAILED|*INVALID) exit 1;; esac
  fi
  sleep 30
done
echo "The macOS build didn't reach VALID in 30 minutes (last: ${STATE:-not listed yet})" >&2; exit 1
