#!/bin/bash
# Runs e2e.cjs while the real Tanooki Auth app is open: copies extension/ and the committed app/
# into a temp folder with the bridge ports moved from 4198x/4199x to 5198x/5199x, so the test
# never talks to the real app. Usage (repo root): extension/test/isolated.sh
# ENGINE=firefox extension/test/isolated.sh runs it in Firefox.
# SCRIPT=phone-e2e.cjs extension/test/isolated.sh runs the "Use my phone" test instead (no app reachable).
set -euo pipefail
root="$(cd "$(dirname "$0")/../.." && pwd)"
tmp="$(mktemp -d)"
shift_ports() { sed -i '' 's/4198\([4-9]\)/5198\1/g; s/4199\([0-3]\)/5199\1/g' "$@"; }
cp -R "$root/extension" "$tmp/extension"
shift_ports "$tmp/extension/sw.js"
git -C "$root" archive HEAD app | tar -x -C "$tmp"
shift_ports "$tmp/app/lib/bridge/server.dart"
if [ "${ENGINE:-}" = firefox ]; then
  # Stand-in for the bridge change Firefox needs (accept moz-extension:// origins), in the temp copy only.
  python3 - "$tmp/app/lib/bridge/server.dart" <<'PY'
import sys
p = sys.argv[1]; s = open(p).read()
if '(moz|' in s: sys.exit(0)  # the bridge accepts Firefox itself since Phase C
old = "r'^chrome-extension://[a-p]{32}$'"
assert old in s, 'origin check not found in server.dart; update isolated.sh'
s = s.replace(old, "r'^(chrome-extension://[a-p]{32}|moz-extension://[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})$'")
open(p, 'w').write(s)
PY
fi
(cd "$tmp/app" && flutter pub get >/dev/null)
EXT_DIR="$tmp/extension" APP_DIR="$tmp/app" BRIDGE_PORT=51984 NODE_PATH="${NODE_PATH:-$(npm root -g)}" \
  node "$root/extension/test/${SCRIPT:-e2e.cjs}" "$@"
