import 'package:flutter/material.dart';

class Fields extends StatelessWidget {
  String txt;
  Fields({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(txt, style: TextStyle(fontSize: 15, fontWeight: .w600)),
    );
  }
}
