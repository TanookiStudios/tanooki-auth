#!/bin/bash
# Checks the widget/watch/AutoFill code generators (Swift for iPhone/Apple Watch, Kotlin for Android/Wear OS)
# against the RFC 6238 Appendix B test vectors, plus AutoFill's website and app matching and the watch Smart Stack's pick. Exits non-zero if either is wrong.
set -euo pipefail
cd "$(dirname "$0")/../app"
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
swiftc -O ios/Shared/TOTP.swift ios/SharedTests/main.swift -o "$out/totpcheck"
"$out/totpcheck"
swiftc -O ios/Shared/TOTP.swift ios/Shared/AutoFill.swift ios/AutoFillTests/main.swift -o "$out/autofillcheck"
swiftc -O ios/Shared/TOTP.swift ios/Shared/FavoriteStore.swift ios/SmartStackTests/main.swift -o "$out/smartstackcheck"
"$out/smartstackcheck"
"$out/autofillcheck"
export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17}"
d=build/wear/test-results/testDebugUnitTest
rm -f "$d"/TEST-*.xml # so a build that never ran the tests can't pass on an old result
(cd android && ./gradlew -q :wear:testDebugUnitTest --rerun-tasks 2>&1 | grep -v -e 'Kotlin Gradle Plugin' -e 'migrate your app' -e 'applies the Kotlin' -e '^$' || true)
for t in TotpTest AutofillTest; do
  r=$d/TEST-com.tanookistudios.shared.$t.xml
  [ -f "$r" ] && grep -q 'failures="0" errors="0"' "$r" || { echo "Kotlin $t: FAILED (see $r)"; exit 1; }
  echo "Kotlin $t: $(grep -o 'tests="[0-9]*"' "$r" | head -1) all pass"
done
