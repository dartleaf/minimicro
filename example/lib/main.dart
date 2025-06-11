// create a minimalist Flutter app that displays a simple text widget
import 'package:flutter/material.dart';
import 'package:minimicro/widgets/minimicro.dart';

void main() {
  runApp(const MiniMicroApp());
}

class MiniMicroApp extends StatelessWidget {
  const MiniMicroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiniMicro',
      theme: ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark),
      home: Scaffold(
        appBar: AppBar(title: const Text('MiniMicro Display')),
        body: Container(
          color: Colors.white,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: MiniMicro()),
          ),
        ),
      ),
    );
  }
}
