import 'dart:convert';

import 'totp.dart';

enum OtpType { totp, hotp }

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
  })  : domains = domains ?? [],
        tags = tags ?? [],
        recoveryCodes = recoveryCodes ?? [],
        createdAt = createdAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now().toUtc();

  final String id;
  final OtpType type;
  String issuer;
  String label;
  final String secret; // base32
  final OtpAlgorithm algorithm;
  final int digits;
  final int period;
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

  bool get trashed => deletedAt != null;

  String codeAt(DateTime now) {
    final key = base32Decode(secret);
    return type == OtpType.hotp
        ? hotp(key, counter, digits: digits, algorithm: algorithm)
        : totp(key, now.millisecondsSinceEpoch ~/ 1000,
            period: period, digits: digits, algorithm: algorithm);
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

/// Home list order: favorites first, then (if [recentFirst]) most recently used, else the user's order.
List<Account> homeOrder(Iterable<Account> accounts, {bool recentFirst = false}) {
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
      final r = recent(a, b);
      return r != 0 ? r : pos[a]!.compareTo(pos[b]!);
    });
}
