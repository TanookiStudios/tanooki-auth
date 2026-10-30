#!/bin/bash
# Packages "Tanooki Auth.alfredworkflow" (a zip Alfred opens on double-click) next to this script,
# or at the path given as the first argument.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
stage="$(mktemp -d)"
trap 'rm -rf "$stage"' EXIT
plutil -lint "$here/info.plist" >/dev/null
cp "$here/info.plist" "$here/tanooki.mjs" "$stage/"
cp "$here/../shared/bridge.mjs" "$stage/"
cp "$here/../../extension/icons/icon128.png" "$stage/icon.png"
out="${1:-$here/Tanooki Auth.alfredworkflow}"  # optional output path (the tests build into a temp folder)
rm -f "$out"
(cd "$stage" && zip -qX "$out" info.plist tanooki.mjs bridge.mjs icon.png)
echo "$out"
