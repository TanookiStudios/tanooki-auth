#!/bin/zsh
# Uploads the public installers in dist/ to the website's R2 bucket, after checking the page
# links each one with its current SHA-256. Then deploy the page: cd site && npx wrangler deploy
set -euo pipefail
cd "${0:A:h}/.."
page=site/public/index.html
files=(dist/*-mac.dmg dist/*-windows-setup.exe dist/*-android.apk dist/*-extension.zip)
for f in $files; do
  name=${f:t}
  sum=$(shasum -a 256 "$f" | cut -d' ' -f1)
  grep -q "download/$name" $page || { echo "index.html does not link $name"; exit 1; }
  grep -q "$sum" $page || { echo "index.html has the wrong SHA-256 for $name (now $sum)"; exit 1; }
done
for f in $files; do
  (cd site && npx wrangler r2 object put "tanooki-auth-downloads/${f:t}" --file "../$f" --remote)
done
