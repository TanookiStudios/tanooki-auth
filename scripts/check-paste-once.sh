#!/bin/bash
# Checks the Mac "Clear after one paste" code (app/macos/Runner/PasteOnce.swift) for real, across two
# processes: the first paste gets the code, a second paste a moment later gets nothing. Then checks the
# check itself: a plain copy must still be there on the second paste. Uses a private named pasteboard, so
# your own clipboard is never touched. Exits non-zero on any failure.
set -euo pipefail
cd "$(dirname "$0")/../app"
out=$(mktemp -d)
trap 'kill $(jobs -p) 2>/dev/null || true; rm -rf "$out"' EXIT
swiftc -O macos/Runner/PasteOnce.swift macos/PasteOnceCheck/main.swift -o "$out/pastecheck"

run() { # $1 = once|plain; prints first and second read
  local name="com.tanookistudios.auth.pastecheck.$$.$1"
  "$out/pastecheck" serve "$name" 123456 $([ "$1" = plain ] && echo plain) > "$out/serve.log" &
  for _ in $(seq 50); do grep -q ready "$out/serve.log" 2>/dev/null && break; sleep 0.1; done
  local first second
  first=$("$out/pastecheck" read "$name")
  sleep 1.5
  second=$("$out/pastecheck" read "$name")
  wait
  echo "$first $second"
}

once=$(run once)
[ "$once" = "123456 <empty>" ] || { echo "Paste once: FAILED (first, second paste: $once)"; exit 1; }
plain=$(run plain)
[ "$plain" = "123456 123456" ] || { echo "Paste once check is broken: a plain copy read '$plain'"; exit 1; }
echo "Paste once: first paste got the code, second got nothing (plain copy still there: check can fail)"
