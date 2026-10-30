import 'dart:convert';

import 'totp.dart';
import '../l10n/l10n.dart';

/// steam: Steam Guard's 5-character codes (time-based, own alphabet).
enum OtpType { totp, hotp, steam }

class Account {
  Account({
    required this.id,
    this.type = OtpType.totp,
    this.issuer = '',
    this.label = '',
    required this.secret,
    this.algorithm = OtpAlgorithm.sha1,
    this.digits = 6,
    this.period = 30,
    this.counter = 0,
    List<String>? domains,
    DateTime? createdAt,
    this.order = 0,
    this.favorite = false,
    List<String>? tags,
    this.notes = '',
    List<RecoveryCode>? recoveryCodes,
    this.lastUsedAt,
    this.iconDomain,
    this.deletedAt,
    DateTime? updatedAt,
    this.folder,
    this.color,
    this.emoji,
    this.requireAuth = false,
    this.travelHidden = false,
  })  : domains = domains ?? [],
        tags = tags ?? [],
        recoveryCodes = recoveryCodes ?? [],
        createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now().toUtc();

  final String id;
  OtpType type;
  String issuer;
  String label;
  final String secret; // base32
  OtpAlgorithm algorithm;
  int digits;
  int period;
  int counter;
  final List<String> domains;
  final DateTime createdAt;
  int order;
  bool favorite;
  final List<String> tags;
  String notes;
  final List<RecoveryCode> recoveryCodes;
  DateTime? lastUsedAt;
  /// Overrides which website's logo to show; otherwise the first of [domains].
  String? iconDomain;
  /// Set when moved to Trash. Trashed accounts are hidden everywhere except the Trash screen.
  DateTime? deletedAt;
  /// Last change to anything that syncs. Stamped by [Vault.save]; sync keeps whichever copy is newest.
  DateTime updatedAt;
  /// The one folder this account sits in on the home list, or null.
  String? folder;
  /// The account's own color (0xAARRGGBB) and emoji, shown on its avatar, widgets and the watch.
  int? color;
  String? emoji;
  bool requireAuth;
  bool travelHidden;

  bool get trashed => deletedAt != null;

  /// Codes that change with the clock (TOTP and Steam), as opposed to counter-based HOTP.
  bool get timeBased => type != OtpType.hotp;

  String codeAt(DateTime now) {
    final key = base32Decode(secret);
    final unix = now.millisecondsSinceEpoch ~/ 1000;
    return switch (type) {
      OtpType.hotp => hotp(key, counter, digits: digits, algorithm: algorithm),
      OtpType.steam => steamCode(key, unix, period: period),
      OtpType.totp => totp(key, unix, period: period, digits: digits, algorithm: algorithm),
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'issuer': issuer,
        'label': label,
        'secret': secret,
        'algorithm': algorithm.name,
        'digits': digits,
        'period': period,
        'counter': counter,
        'domains': domains,
        'createdAt': createdAt.toIso8601String(),
        'order': order,
        'favorite': favorite,
        'tags': tags,
        'notes': notes,
        'recoveryCodes': [for (final r in recoveryCodes) r.toJson()],
        'lastUsedAt': lastUsedAt?.toIso8601String(),
        'iconDomain': iconDomain,
        'deletedAt': deletedAt?.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'folder': folder,
        'color': color,
        'emoji': emoji,
        'requireAuth': requireAuth,
        'travelHidden': travelHidden,
      };

  /// Everything a sync merge compares: the JSON minus per-device details (list position, last used)
  /// and the timestamp itself.
  String get syncContent => jsonEncode(toJson()
    ..remove('order')
    ..remove('lastUsedAt')
    ..remove('updatedAt'));

  factory Account.fromJson(Map<String, dynamic> j) => Account(
        id: j['id'] as String,
        type: OtpType.values.byName(j['type'] as String),
        issuer: j['issuer'] as String,
        label: j['label'] as String,
        secret: j['secret'] as String,
        algorithm: OtpAlgorithm.values.byName(j['algorithm'] as String),
        digits: j['digits'] as int,
        period: j['period'] as int,
        counter: j['counter'] as int,
        domains: (j['domains'] as List).cast<String>().toList(),
        createdAt: DateTime.parse(j['createdAt'] as String),
        order: j['order'] as int,
        // Everything below was added after 0.1.0; old vaults and backups don't have it.
        favorite: j['favorite'] as bool? ?? false,
        tags: (j['tags'] as List?)?.cast<String>().toList(),
        notes: j['notes'] as String? ?? '',
        recoveryCodes: [
          for (final r in (j['recoveryCodes'] as List?) ?? const []) RecoveryCode.fromJson(r as Map<String, dynamic>),
        ],
        lastUsedAt: _date(j['lastUsedAt']),
        iconDomain: j['iconDomain'] as String?,
        deletedAt: _date(j['deletedAt']),
        updatedAt: _date(j['updatedAt']) ?? DateTime.parse(j['createdAt'] as String),
        // Added in Phase A (2026-10-30).
        folder: j['folder'] as String?,
        color: (j['color'] as num?)?.toInt(),
        emoji: j['emoji'] as String?,
        requireAuth: j['requireAuth'] as bool? ?? false,
        travelHidden: j['travelHidden'] as bool? ?? false,
      );
}

DateTime? _date(Object? s) => s == null ? null : DateTime.parse(s as String);

/// One backup code a website gave out when 2FA was turned on. Each works once.
class RecoveryCode {
  RecoveryCode(this.code, {this.used = false});
  final String code;
  bool used;

  Map<String, dynamic> toJson() => {'code': code, 'used': used};
  factory RecoveryCode.fromJson(Map<String, dynamic> j) =>
      RecoveryCode(j['code'] as String, used: j['used'] as bool? ?? false);

  /// Splits pasted text into codes: one per line, or separated by spaces or commas.
  /// Strips list numbering like "1." or "1)".
  static List<RecoveryCode> parseList(String text) => [
        for (final line in text.split(RegExp(r'[\n,]')))
          for (final part in line.trim().replaceFirst(RegExp(r'^\d+[.)]\s+'), '').split(RegExp(r'\s{2,}|\t')))
            if (part.trim().isNotEmpty) RecoveryCode(part.trim()),
      ];
}

/// Ways to sort the home list (settings key [sortKey]). Custom is the user's own drag order.
const sortKey = 'sort';
Map<String, String> get sortChoices => {'custom': l10n.accountSortCustom, 'recent': l10n.accountSortRecent, 'name': l10n.accountSortName};

/// The chosen sort, falling back to the old "Recently used first" switch from before the sort setting.
String sortOf(Map<String, dynamic> settings) =>
    sortChoices.containsKey(settings[sortKey]) ? settings[sortKey] as String : (settings['recentFirst'] == true ? 'recent' : 'custom');

/// Home list order: favorites first, then by [sort]: 'recent' (most recently used), 'name' (A to Z), or the user's order.
List<Account> homeOrder(Iterable<Account> accounts, {String sort = 'custom'}) {
  final recentFirst = sort == 'recent';
  final list = accounts.where((a) => !a.trashed).toList();
  final pos = {for (var i = 0; i < list.length; i++) list[i]: i};
  int recent(Account a, Account b) {
    if (!recentFirst || a.lastUsedAt == b.lastUsedAt) return 0;
    if (a.lastUsedAt == null) return 1;
    if (b.lastUsedAt == null) return -1;
    return b.lastUsedAt!.compareTo(a.lastUsedAt!);
  }

  // List.sort isn't stable, so break ties with the original position.
  return list
    ..sort((a, b) {
      if (a.favorite != b.favorite) return a.favorite ? -1 : 1;
      final r = sort == 'name' ? _byName(a, b) : recent(a, b);
      return r != 0 ? r : pos[a]!.compareTo(pos[b]!);
    });
}

int _byName(Account a, Account b) {
  String key(Account x) => '${x.issuer.isNotEmpty ? x.issuer : x.label}\u0000${x.label}'.toLowerCase();
  return key(a).compareTo(key(b));
}
