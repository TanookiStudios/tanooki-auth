#!/bin/bash
# Prints the feedback people sent from the app (newest last).
#   scripts/feedback.sh            readable list
#   scripts/feedback.sh --json     raw JSON
# Reads the admin token from ~/.tanooki-auth-signing/feedback-admin.txt (set on the worker as FEEDBACK_ADMIN).
set -euo pipefail
TOKEN_FILE="$HOME/.tanooki-auth-signing/feedback-admin.txt"
URL="${FEEDBACK_URL:-https://tanooki-auth-premium.kirbymail.workers.dev}/feedback/list"
[ -r "$TOKEN_FILE" ] || { echo "No admin token at $TOKEN_FILE" >&2; exit 1; }

# The token goes in through a header file on stdin, so it never shows up in the process list.
body=$(printf 'Authorization: Bearer %s\n' "$(tr -d '\n' < "$TOKEN_FILE")" |
  curl -sS --fail-with-body -H @- "$URL") || { echo "Feedback request failed: $body" >&2; exit 1; }

if [ "${1:-}" = "--json" ]; then echo "$body"; exit 0; fi
printf '%s' "$body" | python3 -c '
import json, sys
entries = json.load(sys.stdin)["entries"]
for e in entries:
    who = "  from " + e["contact"] if e.get("contact") else ""
    print("--- %s  %s %s%s" % (e["at"], e["platform"], e["appVersion"], who))
    print(e["message"])
print("\n%d message(s)" % len(entries))
'
