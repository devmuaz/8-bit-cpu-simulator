import 'package:flutter/material.dart';

import 'cpu_board.dart';

void main() {
  runApp(const CPUSimulatorApp());
}

class CPUSimulatorApp extends StatelessWidget {
  const CPUSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '8-bit CPU Simulator',
      theme: ThemeData(
        fontFamily: 'GoogleSansCode',
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
        brightness: Brightness.dark,
      ),
      home: const _App(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    const requiredWidth = 1400;
    const requiredHeight = 900;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if (width < requiredWidth || height < requiredHeight) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Please, run the app in a full screen mode!\n'
            'Required size: (width: ${requiredWidth}px, height: ${requiredHeight}px)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return const CPUBoard();
  }
}
