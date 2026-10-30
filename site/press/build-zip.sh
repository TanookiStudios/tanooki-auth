#!/bin/sh
# Builds public/press/tanooki-auth-press-kit.zip from the app icon and every screenshot. Run: sh site/press/build-zip.sh
set -eu
cd "$(dirname "$0")/../public"
out=press/tanooki-auth-press-kit.zip
rm -f "$out"
zip -X -q "$out" icon.png screens/*
# Fail loudly if an image went missing from the zip.
want=$(( $(ls screens | wc -l) + 1 ))
got=$(zipinfo -1 "$out" | wc -l)
[ "$got" -eq "$want" ] || { echo "press kit has $got files, expected $want" >&2; exit 1; }
echo "Built $out ($got files, $(du -k "$out" | cut -f1 | tr -d " ") KB)"
