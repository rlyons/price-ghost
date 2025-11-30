import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  String? _latestBarcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price Ghost')),
      body: Column(
        children: [
          // Placeholder camera area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: Text(
                  'Camera preview placeholder',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Simulate a barcode scan
                    setState(() {
                      _latestBarcode = '0123456789012';
                    });
                  },
                  child: const Text('Simulate Scan'),
                ),
                const SizedBox(height: 12.0),
                if (_latestBarcode != null)
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.qr_code),
                      title: Text('Scanned: $_latestBarcode'),
                      subtitle: const Text('Tap to view details'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
