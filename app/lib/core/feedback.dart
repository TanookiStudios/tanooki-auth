import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'store.dart' show workerUrl;

enum FeedbackResult { sent, tooLong, tooMany, offline, serverError }

/// The worker refuses bodies over 4 KB and messages over 4,000 characters.
const feedbackMaxBytes = 4096;
const feedbackMaxChars = 4000;

/// Everything feedback sends. It takes only what the person typed and, if they allow it, the app version
/// and device type: it has no way to reach the vault.
Map<String, String> feedbackBody({
  required String message,
  String contact = '',
  required bool includeDevice,
  required String appVersion,
}) =>
    {
      'message': message.trim(),
      // The worker needs both fields; "not shared" when the person unticks the box.
      'platform': includeDevice ? Platform.operatingSystem : 'not shared',
      'appVersion': includeDevice ? appVersion : 'not shared',
      if (contact.trim().isNotEmpty) 'contact': contact.trim(),
    };

/// Posts [bytes] and returns the HTTP status. Tests swap it out to see exactly what would be sent.
Future<int> Function(List<int> bytes) feedbackPost = _post;

Future<int> _post(List<int> bytes) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
  try {
    final req = await client.postUrl(Uri.parse('$workerUrl/feedback')).timeout(const Duration(seconds: 20));
    req.headers.contentType = ContentType.json;
    req.contentLength = bytes.length;
    req.add(bytes);
    final res = await req.close().timeout(const Duration(seconds: 30));
    await res.drain<void>();
    return res.statusCode;
  } finally {
    client.close();
  }
}

Future<FeedbackResult> sendFeedback(Map<String, String> body) async {
  final bytes = utf8.encode(jsonEncode(body));
  if (bytes.length > feedbackMaxBytes || body['message']!.length > feedbackMaxChars) return FeedbackResult.tooLong;
  final int status;
  try {
    status = await feedbackPost(bytes);
  } on SocketException {
    return FeedbackResult.offline;
  } on TimeoutException {
    return FeedbackResult.offline;
  } on HandshakeException {
    return FeedbackResult.offline;
  } on HttpException {
    return FeedbackResult.offline;
  }
  return switch (status) {
    200 || 201 => FeedbackResult.sent,
    413 => FeedbackResult.tooLong,
    429 => FeedbackResult.tooMany,
    _ => FeedbackResult.serverError,
  };
}
