import 'package:email/components/fields.dart';
import 'package:email/components/textfield.dart';
import 'package:email/services/database_service.dart';
import 'package:email/services/google_auth_service.dart';
import 'package:email/services/gmail_service.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});
// done
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

  String inputedText = "Press mic and speak...";
  dynamic _authenticatedClient;
  bool _isSignedIn = false;
  bool _isSending = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    db.connect();
    speechinit();
    // Sign in automatically when app opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _signInOnStart();
    });
  }

  Future<void> _signInOnStart() async {
    try {
      final user = await auth.signIn();
      if (user == null) {
        msg("Sign in failed. Try again.");
        return;
      }
      final client = await auth.getClient();
      setState(() {
        senderCont.text = user.email;
        _authenticatedClient = client;
        _isSignedIn = true;
      });
    } catch (e) {
      msg("Sign in error: $e");
    }
  }

  Future<void> speechinit() async {
    await stx.initialize(
      onStatus: (status) => print("STATUS: $status"),
      onError: (error) => print("ERROR: $error"),
    );
  }

  Future<void> speechlisten() async {
    // If already listening, stop
    if (_isListening) {
      await stx.stop();
      setState(() => _isListening = false);
      return;
    }

    setState(() {
      _isListening = true;
      inputedText = "Listening...";
    });

    await stx.listen(
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 15),
      partialResults: true,
      onResult: (result) async {
        setState(() {
          inputedText = result.recognizedWords;
        });

        // Auto send command
        if (result.recognizedWords.toLowerCase().contains("send email")) {
          bodyCont.text = bodyCont.text
              .replaceAll(RegExp("send email", caseSensitive: false), "")
              .trim();

          await stx.stop();

          setState(() {
            _isListening = false;
          });

          await sendEmail();
          return;
        }

        await processCommand(result.recognizedWords);
      },
    );
  }

  String cleanEmail(String email) {
    return email
        .toLowerCase()
        .replaceAll(" at ", "@")
        .replaceAll(" dot ", ".")
        .replaceAll(" ", "");
  }

  Future<void> processCommand(String command) async {
    final text = command.toLowerCase();

    final receiverIndex = text.indexOf("receiver");
    final subjectIndex = text.indexOf("subject");
    final bodyIndex = text.indexOf("body");

    // Receiver
    if (receiverIndex != -1) {
      final end = subjectIndex != -1
          ? subjectIndex
          : bodyIndex != -1
              ? bodyIndex
              : text.length;
      final receiver =
          command.substring(receiverIndex + "receiver".length, end).trim();
      receiverCont.text = cleanEmail(receiver);
    }

    // Subject
    if (subjectIndex != -1) {
      final end = bodyIndex != -1 ? bodyIndex : text.length;
      subjectCont.text =
          command.substring(subjectIndex + "subject".length, end).trim();
    }

    // Body
    if (bodyIndex != -1) {
      String body = command.substring(bodyIndex + "body".length).trim();

      body = body.replaceAll(
        RegExp("send email", caseSensitive: false),
        "",
      );

      bodyCont.text = body;
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
    // If somehow not signed in yet, retry sign in
    if (!_isSignedIn || _authenticatedClient == null) {
      msg("Not signed in yet. Trying again...");
      await _signInOnStart();
      return;
    }

    if (receiverCont.text.trim().isEmpty) {
      msg("Receiver email is empty.");
      return;
    }

    setState(() => _isSending = true);

    try {
      final gmailService = GmailService(_authenticatedClient);

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

      msg("Email sent successfully!");

      // Clear fields after send (sender stays)
      receiverCont.clear();
      subjectCont.clear();
      bodyCont.clear();
      setState(() => inputedText = "Press mic and speak...");
    } catch (e) {
      msg("Failed to send: $e");
    } finally {
      setState(() => _isSending = false);
    }
  }

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
                      field: _isSignedIn ? "" : "Signing in...",
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
                      field: "Enter Body",
                    ),

                    const SizedBox(height: 5),

                    Center(
                      child: _isSending
                          ? const CircularProgressIndicator(
                              color: Colors.purpleAccent,
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purpleAccent,
                              ),
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

              // What mic heard
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  inputedText,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              // Mic button — red when listening, purple when idle
              CircleAvatar(
                radius: 30,
                backgroundColor:
                    _isListening ? Colors.red : Colors.purpleAccent,
                child: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: speechlisten,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
