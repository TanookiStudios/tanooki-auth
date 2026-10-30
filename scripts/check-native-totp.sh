#!/bin/bash
# Checks the widget/watch code generators (Swift for iPhone/Apple Watch, Kotlin for Android/Wear OS)
# against the RFC 6238 Appendix B test vectors. Exits non-zero if either is wrong.
set -euo pipefail
cd "$(dirname "$0")/../app"
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
swiftc -O ios/Shared/TOTP.swift ios/SharedTests/main.swift -o "$out/totpcheck"
"$out/totpcheck"
export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17}"
r=build/wear/test-results/testDebugUnitTest/TEST-com.tanookistudios.shared.TotpTest.xml
rm -f "$r" # so a build that never ran the tests can't pass on an old result
(cd android && ./gradlew -q :wear:testDebugUnitTest --rerun-tasks 2>&1 | grep -v -e 'Kotlin Gradle Plugin' -e 'migrate your app' -e 'applies the Kotlin' -e '^$' || true)
[ -f "$r" ] && grep -q 'failures="0" errors="0"' "$r" || { echo "Kotlin TOTP: FAILED (see $r)"; exit 1; }
echo "Kotlin TOTP: $(grep -o 'tests="[0-9]*"' "$r" | head -1) all pass"
