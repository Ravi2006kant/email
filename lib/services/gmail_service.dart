import 'dart:convert';
import 'package:googleapis/gmail/v1.dart';
import 'package:http/http.dart' as http;

class GmailService {
  final http.Client client;

  GmailService(this.client);

  Future<void> sendEmail({
    required String receiver,
    required String subject,
    required String body,
  }) async {
    final gmail = GmailApi(client);

    // Step 1: Create raw email string (RFC 2822 format)
    final emailString = '''
To: $receiver
Subject: $subject
Content-Type: text/plain; charset="UTF-8"

$body
''';

    // Step 2: Encode email in base64URL format
    final encodedEmail =
        base64Url.encode(utf8.encode(emailString)).replaceAll('=', '');

    // Step 3: Create Gmail message
    final message = Message()..raw = encodedEmail;

    // Step 4: Send email
    await gmail.users.messages.send(message, 'me');
  }
}