import 'package:flutter/services.dart';

class AccessibilityCommandService {
  static const MethodChannel _channel = MethodChannel('voicein/accessibility');

  static Future<void> fillEmail({
    String? to,
    String? subject,
    String? body,
  }) async {
    await _channel.invokeMethod('fillEmail', {
      'to': to ?? '',
      'subject': subject ?? '',
      'body': body ?? '',
    });
  }

  static Future<void> startBackgroundEmailListening() async {
    await _channel.invokeMethod('startBackgroundEmailListening');
  }

  static Future<void> stopBackgroundEmailListening() async {
    await _channel.invokeMethod('stopBackgroundEmailListening');
  }
}
