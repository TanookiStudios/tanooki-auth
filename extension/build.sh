#!/bin/bash
# Packs the extension for each store into the repo's dist/ folder:
#   Tanooki-Auth-<version>-chrome.zip, -edge.zip (same as Chrome), -firefox.zip
# The source folder loads unpacked in Chrome, Edge and Firefox as is; the zips only drop the keys
# each store would warn about. Safari is built from extension-safari/ in Xcode instead.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dist="$here/../dist"
version="$(node -p "require('$here/manifest.json').version")"
files=(manifest.json _locales sw.js content.js popup.html popup.js lookalike.js login.js link.js qrcode.js qrcode.LICENSE jsqr.js jsqr.LICENSE icons)
mkdir -p "$dist"

pack() { # pack <name> <node expression that edits manifest m>
  local tmp out="$dist/Tanooki-Auth-$version-$1.zip"
  tmp="$(mktemp -d)"
  (cd "$here" && cp -R "${files[@]}" "$tmp/")
  node -e "const fs=require('fs');const f='$tmp/manifest.json';const m=JSON.parse(fs.readFileSync(f));$2;fs.writeFileSync(f,JSON.stringify(m,null,2)+'\n')"
  rm -f "$out"
  (cd "$tmp" && zip -qrX "$out" .)
  rm -rf "$tmp"
  echo "$out"
}

chromium='delete m.browser_specific_settings; delete m.background.scripts'
pack chrome "$chromium"
pack edge "$chromium"
pack firefox 'delete m.background.service_worker'
