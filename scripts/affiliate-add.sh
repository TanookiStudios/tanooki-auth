#!/bin/bash
# Adds a creator to the affiliate program and prints their link and private stats page.
#   scripts/affiliate-add.sh "Sam Tech" samtech
# The code is 3 to 32 lowercase letters, numbers or dashes, and shows in their link.
# Send the creator both lines it prints. The stats link is private: anyone with it can see their numbers.
set -euo pipefail
TOKEN_FILE="$HOME/.tanooki-auth-signing/affiliates-admin.txt"
BASE="${PREMIUM_URL:-https://tanooki-auth-premium.kirbymail.workers.dev}"
[ $# -eq 2 ] || { echo 'Usage: scripts/affiliate-add.sh "Creator Name" code' >&2; exit 1; }
[ -r "$TOKEN_FILE" ] || { echo "No admin token at $TOKEN_FILE" >&2; exit 1; }
payload=$(python3 -c 'import json,sys; print(json.dumps({"name": sys.argv[1], "code": sys.argv[2]}))' "$1" "$2")
body=$(printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$(tr -d '\n' < "$TOKEN_FILE")" |
  curl -sS --fail-with-body -H @- --data "$payload" "$BASE/affiliates") || { echo "Adding the creator failed: $body" >&2; exit 1; }
printf '%s' "$body" | python3 -c '
import json, sys
d = json.load(sys.stdin)
print("Added %s (%s)" % (d["name"], d["code"]))
print("Their link:        " + d["link"])
print("Their stats page:  " + d["statsPage"])
'
