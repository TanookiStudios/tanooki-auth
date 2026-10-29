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
  })  : domains = domains ?? [],
        createdAt = createdAt ?? DateTime.now().toUtc();

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
      };

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
      );
}
