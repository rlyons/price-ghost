import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/scanner_screen.dart';

void main() {
  runApp(const ProviderScope(child: PriceGhostApp()));
}

class PriceGhostApp extends StatelessWidget {
  const PriceGhostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Ghost',
      theme: ThemeData(brightness: Brightness.dark),
      home: const ScannerScreen(),
    );
  }
}
