#!/bin/bash
# Monthly affiliate payout report: who to pay, how much, and the Stripe checkouts behind it.
#   scripts/affiliates-report.sh            last month (the usual one to pay out)
#   scripts/affiliates-report.sh 2026-11    a given month
#   scripts/affiliates-report.sh --json     raw JSON (with or after a month)
# Amounts are what the buyer paid after any discount, before tax. Refunds are not subtracted: check Stripe for
# refunds on the listed checkouts before paying.
# Reads the admin token from ~/.tanooki-auth-signing/affiliates-admin.txt (set on the worker as AFFILIATES_ADMIN).
set -euo pipefail
TOKEN_FILE="$HOME/.tanooki-auth-signing/affiliates-admin.txt"
BASE="${PREMIUM_URL:-https://tanooki-auth-premium.kirbymail.workers.dev}"
[ -r "$TOKEN_FILE" ] || { echo "No admin token at $TOKEN_FILE" >&2; exit 1; }
MONTH=$(date -v-1m +%Y-%m 2>/dev/null || date -d 'last month' +%Y-%m)
JSON=no
for a in "$@"; do case "$a" in --json) JSON=yes ;; *) MONTH="$a" ;; esac; done

body=$(printf 'Authorization: Bearer %s\n' "$(tr -d '\n' < "$TOKEN_FILE")" |
  curl -sS --fail-with-body -H @- "$BASE/affiliates/report?month=$MONTH") || { echo "Affiliate report failed: $body" >&2; exit 1; }

if [ "$JSON" = yes ]; then echo "$body"; exit 0; fi
printf '%s' "$body" | python3 -c '
import json, sys
d = json.load(sys.stdin)
usd = lambda c: "$%.2f" % (c / 100)
print("Affiliate payouts for %s (%d%% of each sale)\n" % (d["month"], round(d["share"] * 100)))
total = 0
for a in sorted(d["affiliates"], key=lambda a: -a["owed"]):
    total += a["owed"]
    print("%-28s %3d sale(s)  revenue %9s  PAY %9s" % ("%s (%s)" % (a["name"], a["code"]), a["sales"], usd(a["revenue"]), usd(a["owed"])))
    for s in a["sessions"]: print("    %s  %s %s" % (s["session"], usd(s["amount"]), s["currency"].upper()))
print("\nTotal to pay: %s" % usd(total))
'
