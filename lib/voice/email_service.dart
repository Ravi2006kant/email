// import 'package:url_launcher/url_launcher.dart';

// class EmailService {
//   static Future<void> composeEmail(
//     String email, {
//     String subject = "",
//     String body = "",
//   }) async {
//     final Uri uri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {
//         if (subject.isNotEmpty) 'subject': subject,
//         if (body.isNotEmpty) 'body': body,
//       },
//     );

//     if (!await launchUrl(
//       uri,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not push intent update to system layout');
//     }
//   }
// }