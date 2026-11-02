#!/bin/bash
# Prints the confirmed newsletter subscribers' email addresses, one per line (ready to paste into an email tool).
#   scripts/subscribers.sh          one address per line
#   scripts/subscribers.sh --json   raw JSON, with the date each one confirmed
# Reads the admin token from ~/.tanooki-auth-signing/subscribers-admin.txt (set on the worker as SUBSCRIBERS_ADMIN).
set -euo pipefail
TOKEN_FILE="$HOME/.tanooki-auth-signing/subscribers-admin.txt"
URL="${PREMIUM_URL:-https://tanooki-auth-premium.kirbymail.workers.dev}/subscribers/export"
[ -r "$TOKEN_FILE" ] || { echo "No admin token at $TOKEN_FILE" >&2; exit 1; }

# The token goes in through a header file on stdin, so it never shows up in the process list.
body=$(printf 'Authorization: Bearer %s\n' "$(tr -d '\n' < "$TOKEN_FILE")" |
  curl -sS --fail-with-body -H @- "$URL") || { echo "Subscriber export failed: $body" >&2; exit 1; }

if [ "${1:-}" = "--json" ]; then echo "$body"; exit 0; fi
printf '%s' "$body" | python3 -c '
import json, sys
d = json.load(sys.stdin)
for s in d["subscribers"]: print(s["email"])
print("%d confirmed subscriber(s)" % d["count"], file=sys.stderr)
'
