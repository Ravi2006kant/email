import 'dart:ui';

import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  TextEditingController? cont;
  TextInputType? keyboardType;
  int? length;
  String field;
  Textfield({
    super.key,
    required this.keyboardType,
    required this.field,
    this.cont,
    this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: cont,

        maxLines: length,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: field,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }
}
