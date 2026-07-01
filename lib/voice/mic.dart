import 'package:flutter/material.dart';

class Mic extends StatelessWidget {
  const Mic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
      child: Icon(Icons.mic, color: Colors.white, size: 60),
    );
  }
}
