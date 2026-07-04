import 'package:email/components/fields.dart';
import 'package:email/components/textfield.dart';
import 'package:email/services/database_service.dart';
import 'package:email/services/google_auth_service.dart';
import 'package:email/services/gmail_service.dart';

import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GoogleAuthService auth = GoogleAuthService();
  final DatabaseService db = DatabaseService();

  final TextEditingController senderCont = TextEditingController();
  final TextEditingController receiverCont = TextEditingController();
  final TextEditingController subjectCont = TextEditingController();
  final TextEditingController bodyCont = TextEditingController();

  final SpeechToText stx = SpeechToText();

  String inputedText = "Voice Show Here..";

  @override
  void initState() {
    super.initState();
    speechinit();
    db.connect();
  }

  Future<void> speechinit() async {
    bool available = await stx.initialize(
      onStatus: (status) {
        print("STATUS: $status");
      },
      onError: (error) {
        print("ERROR: $error");
      },
    );

    print("Speech available: $available");
  }

  Future<void> speechlisten() async {
    await stx.listen(
      onResult: (result) {
        setState(() {
          inputedText = result.recognizedWords;
        });

        processCommand(result.recognizedWords);

        if (result.finalResult) {
          stx.stop();
        }
      },
    );
  }

  // Cleans spoken emails by removing spaces and replacing "at" / "dot"
  String cleanEmail(String email) {
    return email
        .toLowerCase()
        .replaceAll(" at ", "@")
        .replaceAll(" dot ", ".")
        .replaceAll(" ", "");
  }

  void processCommand(String command) {
    String text = command.toLowerCase();

    int senderIndex = text.indexOf("sender");
    int receiverIndex = text.indexOf("receiver");
    int subjectIndex = text.indexOf("subject");
    int bodyIndex = text.indexOf("body");

    // Sender
    if (senderIndex != -1 && receiverIndex != -1) {
      String sender = command
          .substring(senderIndex + "sender".length, receiverIndex)
          .trim();

      senderCont.text = cleanEmail(sender);
    }

    // Receiver
    if (receiverIndex != -1 && subjectIndex != -1) {
      String receiver = command
          .substring(receiverIndex + "receiver".length, subjectIndex)
          .trim();

      receiverCont.text = cleanEmail(receiver);
    }

    // Subject
    if (subjectIndex != -1 && bodyIndex != -1) {
      subjectCont.text = command
          .substring(subjectIndex + "subject".length, bodyIndex)
          .trim();
    }

    // Body
    if (bodyIndex != -1) {
      bodyCont.text = command.substring(bodyIndex + "body".length).trim();
    }
  }

  @override
  void dispose() {
    senderCont.dispose();
    receiverCont.dispose();
    subjectCont.dispose();
    bodyCont.dispose();
    super.dispose();
  }

  void msg(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> sendEmail() async {
    final user = await auth.signIn();

    if (user == null) {
      msg("user not found");
      return;
    }

    // Instantly refresh the UI to show the authenticated Google account
    setState(() {
      senderCont.text = user.email;
    });

    final client = await auth.getClient();

    if (client == null) {
      msg("user not found");
      return;
    }

    final gmailService = GmailService(client);

    await gmailService.sendEmail(
      receiver: receiverCont.text.trim(),
      subject: subjectCont.text.trim(),
      body: bodyCont.text.trim(),
    );

    await db.insertEmail(
      sender: senderCont.text.trim(),
      receiver: receiverCont.text.trim(),
      subject: subjectCont.text.trim(),
      body: bodyCont.text.trim(),
    );

    msg("message send successfully");
  }

  ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.purpleAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sendo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),

                    Fields(txt: "Sender's Email"),
                    Textfield(
                      cont: senderCont,
                      keyboardType: TextInputType.emailAddress,
                      field: "Google account will appear here",
                      readOnly: true, // Requires readOnly support in textfield.dart
                    ),

                    Fields(txt: "Receiver's Email"),
                    Textfield(
                      cont: receiverCont,
                      keyboardType: TextInputType.emailAddress,
                      field: "Enter Receiver's Email",
                    ),

                    Fields(txt: "Subject"),
                    Textfield(
                      cont: subjectCont,
                      keyboardType: TextInputType.text,
                      field: "Enter Subject",
                    ),

                    Fields(txt: "Body"),
                    Textfield(
                      length: 4,
                      cont: bodyCont,
                      keyboardType: TextInputType.text,
                      field: "Enter body",
                    ),

                    const SizedBox(height: 5),

                    Center(
                      child: ElevatedButton.icon(
                        style: style,
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: sendEmail,
                        label: const Text(
                          "Send",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purpleAccent,
                child: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () => speechlisten(),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
