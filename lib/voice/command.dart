// import 'dart:developer';
// import 'package:voicein/services/accessibility_command_service.dart';
// import 'package:voicein/services/app_launcher_service.dart';
// import 'package:voicein/services/email_service.dart';

// class Command {
//   static Future<void> process(String command) async {
//     final originalCommand = command.trim();
//     command = originalCommand.toLowerCase();

//     log("HEARD COMMAND = $command", name: "VOICEIN");

//     if (command.contains("send email")) {
//       final emailRegex = RegExp(r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}');
//       final match = emailRegex.firstMatch(command);

//       if (match != null) {
//         String email = match.group(0)!;
//         log("OPENING GMAIL FOR: $email", name: "VOICEIN");

//         // 1. Start listening in the background BEFORE leaving Flutter
//         await AccessibilityCommandService.startBackgroundEmailListening();
//         await Future.delayed(const Duration(milliseconds: 400));

//         // 2. Open Gmail (The "To" field will be filled)
//         await EmailService.composeEmail(email, subject: "", body: "");
//       }
//       return;
//     }

//     if (command.contains("open gmail")) {
//       await ApplauncherService.openGmail();
//       return;
//     }
//   }
// }