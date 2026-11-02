import Foundation

// Which favorite the Apple Watch Smart Stack widget shows and how relevant it says it is. Built and run by
// scripts/check-native-totp.sh together with ../Shared/TOTP.swift and ../Shared/FavoriteStore.swift.
var failed = 0
func check(_ ok: Bool, _ what: String) {
  if !ok { print("FAIL \(what)"); failed += 1 }
}

func fav(_ issuer: String, chosen: Bool = false) -> Favorite {
  var f = Favorite(issuer: issuer, label: "me", secret: "JBSWY3DPEHPK3PXP", algorithm: "sha1", digits: 6, period: 30, type: nil)
  if chosen { f.complication = true }
  return f
}

let now = Date(timeIntervalSince1970: 1_800_000_000)
let list = [fav("GitHub"), fav("Bank", chosen: true), fav("Steam")]

// Nothing copied: the watch face favorite, at its score; without one, the first.
var p = SmartStack.pick(list, copied: nil, now: now)
check(p.favorite?.issuer == "Bank" && p.boostedUntil == nil, "chosen favorite when nothing was copied")
check(SmartStack.score(p.favorite, boostedUntil: nil, at: now).score == SmartStack.chosenScore, "chosen score")
p = SmartStack.pick([fav("GitHub"), fav("Steam")], copied: nil, now: now)
check(p.favorite?.issuer == "GitHub", "first favorite without a chosen one")
check(SmartStack.score(p.favorite, boostedUntil: nil, at: now).score == SmartStack.otherScore, "other score")

// Just copied on the iPhone: that one, on top until the boost ends, then back to normal.
let copied = FavoriteStore.Copied(key: fav("Steam").key, at: now.addingTimeInterval(-30))
p = SmartStack.pick(list, copied: copied, now: now)
check(p.favorite?.issuer == "Steam", "copied favorite wins")
check(p.boostedUntil == copied.at + SmartStack.boost, "boost ends \(SmartStack.boost) s after the copy")
let s = SmartStack.score(p.favorite, boostedUntil: p.boostedUntil, at: now)
check(s.score == SmartStack.copiedScore && abs(s.duration - (SmartStack.boost - 30)) < 0.001, "copied score lasts the rest of the boost")
check(SmartStack.score(p.favorite, boostedUntil: p.boostedUntil, at: p.boostedUntil!).score == SmartStack.otherScore, "score drops when the boost ends")

// Too old, from the future, or not a favorite the watch has: ignored.
check(SmartStack.pick(list, copied: .init(key: copied.key, at: now.addingTimeInterval(-SmartStack.boost)), now: now).favorite?.issuer == "Bank", "old copy ignored")
check(SmartStack.pick(list, copied: .init(key: copied.key, at: now.addingTimeInterval(60)), now: now).favorite?.issuer == "Bank", "future copy ignored")
check(SmartStack.pick(list, copied: .init(key: "Elsewhere\nme", at: now), now: now).favorite?.issuer == "Bank", "unknown copy ignored")

// Emptied list (decoy open, sharing off): nothing to show, and no claim to the top of the stack.
p = SmartStack.pick([], copied: copied, now: now)
check(p.favorite == nil && SmartStack.score(nil, boostedUntil: nil, at: now).score == SmartStack.emptyScore, "empty list shows nothing")

print(failed == 0 ? "Smart Stack: all checks pass" : "Smart Stack: \(failed) checks FAILED")
exit(failed == 0 ? 0 : 1)
