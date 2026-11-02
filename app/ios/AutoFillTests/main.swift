import Foundation

// Built and run by scripts/check-native-totp.sh together with ../Shared/TOTP.swift and ../Shared/AutoFill.swift.
var failed = 0, checks = 0
func check(_ ok: Bool, _ what: String) {
  checks += 1
  if !ok { print("FAIL \(what)"); failed += 1 }
}

// The exact shape app/lib/core/widget_share.dart autofillAccounts sends.
let json = """
[{"id":"1","type":"totp","issuer":"GitHub","label":"me","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha1","digits":6,"period":30,"domains":["github.com"]},
 {"id":"2","type":"steam","issuer":"Steam","label":"gamer","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha1","digits":5,"period":30,"domains":[]},
 {"id":"3","type":"totp","issuer":"Bank of Example","label":"","secret":"GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ","algorithm":"sha256","digits":8,"period":60,"domains":["example.com"],"requireAuth":true},
 {"id":"4","type":"totp","issuer":"Discord","label":"","secret":"not base32!","algorithm":"sha1","digits":6,"period":30,"domains":[]}]
"""
let accounts = try! JSONDecoder().decode([AutoFillAccount].self, from: Data(json.utf8))
let (github, steam, bank, discord) = (accounts[0], accounts[1], accounts[2], accounts[3])
check(accounts.count == 4 && bank.requireAuth == true && github.requireAuth == nil, "decodes the app's JSON")

// Codes: same as the RFC 6238 seed in SharedTests, and Steam's letters.
let t59 = Date(timeIntervalSince1970: 59)
check(github.code(at: t59) == "287082", "TOTP code: got \(github.code(at: t59) ?? "nil")")
check(steam.code(at: t59) == "PV9M4", "Steam code: got \(steam.code(at: t59) ?? "nil")")
check(steam.code(at: Date(timeIntervalSince1970: 1234567890)) == "VHHQY", "Steam code later")
check(bank.code(at: Date(timeIntervalSince1970: 59))?.count == 8, "8 digits, 60 s, SHA-256")
check(discord.code(at: t59) == nil, "a broken secret gives no code rather than a wrong one")

// Websites.
check(AutoFillMatch.matches(github, site: "github.com"), "own domain")
check(AutoFillMatch.matches(github, site: "https://www.GitHub.com/login?x=1"), "URL with www, case and path")
check(AutoFillMatch.matches(github, site: "accounts.github.com"), "subdomain")
check(!AutoFillMatch.matches(github, site: "notgithub.com"), "a lookalike domain must not match")
check(!AutoFillMatch.matches(github, site: "github.com.evil.io"), "github.com as a prefix must not match")
check(!AutoFillMatch.matches(github, site: ""), "empty site")
check(AutoFillMatch.matches(steam, site: "store.steampowered.com") == false, "no domains: Steam's name isn't steampowered")
check(AutoFillMatch.matches(steam, site: "steam.com"), "no domains: falls back to the service name")
check(AutoFillMatch.matches(discord, site: "https://discord.com/login"), "no domains: Discord")
check(!AutoFillMatch.matches(bank, site: "bankofexample.com"), "with domains, the name fallback is not used")

// Apps (iOS 26.2+ app ids, and the app's name squashed).
check(AutoFillMatch.matches(github, appID: "com.github.stormbreaker.prod"), "GitHub app id")
check(AutoFillMatch.matches(steam, appID: "com.valvesoftware.Steam"), "Steam app id")
check(AutoFillMatch.matches(discord, appID: AutoFillMatch.squash("Discord")), "app name")
check(!AutoFillMatch.matches(github, appID: "com.android.chrome"), "filler words never match")
check(AutoFillMatch.matches(bank, appID: "com.example.banking"), "app id holding the website's name")
check(!AutoFillMatch.matches(bank, appID: "com.app.mobile"), "filler-only overlap is not enough")

// Ranking: most specific identifier first, no repeats.
let ranked = AutoFillMatch.ranked(accounts, sites: ["accounts.github.com", "discord.com", "github.com"])
check(ranked.map(\.id) == ["1", "4"], "ranked: got \(ranked.map(\.id))")
check(AutoFillMatch.ranked(accounts, sites: []).isEmpty, "nothing asked, nothing matched")
check(github.suggestionLabel == "GitHub (me)" && discord.suggestionLabel == "Discord", "suggestion labels")

print(failed == 0 ? "Swift AutoFill: all \(checks) checks pass" : "Swift AutoFill: \(failed) of \(checks) checks FAILED")
exit(failed == 0 ? 0 : 1)
