import 'dart:math';

import 'package:email/components/fields.dart';
import 'package:email/components/textfield.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController senderCont = TextEditingController();
  final TextEditingController receiverCont = TextEditingController();
  final TextEditingController subjectCont = TextEditingController();
  final TextEditingController bodyCont = TextEditingController();

  void store() {
    String sender = senderCont.text.trim();
    String receiver = receiverCont.text.trim();
    String subject = subjectCont.text.trim();
    String body = bodyCont.text.trim();
  }

  ButtonStyle style = ElevatedButton.styleFrom(
    backgroundColor: Colors.purpleAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontWeight: .bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: .start,

                  children: [
                    SizedBox(height: 5),

                    //senders email
                    Fields(txt: "Sender's Email"),
                    Textfield(
                      cont: senderCont,
                      keyboardType: TextInputType.emailAddress,
                      field: "Enter Your Email",
                    ),

                    //receiver email
                    Fields(txt: "Receiver's Email"),
                    Textfield(
                      cont: receiverCont,
                      keyboardType: TextInputType.emailAddress,
                      field: "Enter Receiver's Email",
                    ),

                    //subject
                    Fields(txt: "Subject"),
                    Textfield(
                      cont: subjectCont,
                      keyboardType: TextInputType.text,
                      field: "Enter Subject ",
                    ),

                    //body
                    Fields(txt: "Body"),
                    Textfield(
                      length: 4,
                      cont: bodyCont,
                      keyboardType: TextInputType.text,
                      field: "Enter body",
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: ElevatedButton.icon(
                        style: style,
                        iconAlignment: .end,
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          store();
                        },
                        label: Text(
                          "Send",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.purpleAccent,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.mic, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
