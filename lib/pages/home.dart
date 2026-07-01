import 'package:email/components/fields.dart';
import 'package:email/components/textfield.dart';
import 'package:email/services/google_auth_service.dart';
import 'package:email/services/gmail_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GoogleAuthService auth = GoogleAuthService();

  final TextEditingController senderCont = TextEditingController();
  final TextEditingController receiverCont = TextEditingController();
  final TextEditingController subjectCont = TextEditingController();
  final TextEditingController bodyCont = TextEditingController();

  @override
  void dispose() {
    senderCont.dispose();
    receiverCont.dispose();
    subjectCont.dispose();
    bodyCont.dispose();
    super.dispose();
  }

  Future<void> sendEmail() async {
    final user = await auth.signIn();

    if (user == null) {
      print("Login cancelled");
      return;
    }

    final client = await auth.getClient();

    if (client == null) {
      print("Client error");
      return;
    }

    final gmailService = GmailService(client);

    await gmailService.sendEmail(
      receiver: receiverCont.text.trim(),
      subject: subjectCont.text.trim(),
      body: bodyCont.text.trim(),
    );

    print("Email sent successfully");
  }

  ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.purpleAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Email App",
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
                      field: "Enter Your Email",
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

              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purpleAccent,
                child: Icon(Icons.mic, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}