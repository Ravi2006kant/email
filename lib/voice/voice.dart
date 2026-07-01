// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:voicein/component/mic.dart';
// import 'package:voicein/services/command.dart';

// class Voice extends StatefulWidget {
//   const Voice({super.key});

//   @override
//   State<Voice> createState() => _VoiceState();
// }

// class _VoiceState extends State<Voice> {
//   final SpeechToText stx = SpeechToText();
//   String inputedText = "Voice Show Here..";

//   @override
//   void initState() {
//     super.initState();
//     speechinit();
//   }

//   Future<void> speechinit() async {
//     await stx.initialize();
//   }

//   Future<void> speechlisten() async {
//     await stx.listen(
//       onResult: (result) async {
//         setState(() {
//           inputedText = result.recognizedWords;
//         });

//         if (result.finalResult) {
//           final command = result.recognizedWords.toLowerCase();

//           // Stop mic to process command
//           await stx.stop();
//           await Future.delayed(const Duration(milliseconds: 300));
          
//           // Send to command processor directly (No boolean checks needed)
//           await Command.process(command);
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Voice Assistant", style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: Colors.pink,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (stx.isListening) {
//                   stx.stop();
//                 } else {
//                   speechlisten();
//                 }
//               },
//               child: const Mic(),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               "Tap To Speak",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 inputedText,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }