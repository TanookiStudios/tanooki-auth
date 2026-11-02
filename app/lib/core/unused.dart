import 'account.dart';

/// How long an account can go without a copied code before "Accounts you never use" lists it.
const unusedMonths = 6;

/// When [a] was last used: its last copied code, or (never used) when it was added.
DateTime lastTouched(Account a) => a.lastUsedAt ?? a.createdAt;

/// Accounts not used in [unusedMonths] months or more, oldest first. Never-used accounts count from the day they
/// were added, so something added last week isn't listed just because it hasn't been needed yet.
List<Account> unusedAccounts(Iterable<Account> accounts, DateTime now) {
  final local = now.toLocal();
  final cutoff = DateTime(local.year, local.month - unusedMonths, local.day, local.hour, local.minute);
  return accounts.where((a) => !a.trashed && !lastTouched(a).isAfter(cutoff)).toList()
    ..sort((a, b) => lastTouched(a).compareTo(lastTouched(b)));
}
