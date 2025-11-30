import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../providers/keepa_provider.dart';
import '../providers/product_provider.dart';
import 'watchlist_screen.dart';
import '../screens/product_detail_screen.dart';
import '../widgets/scan_brackets.dart';
import '../widgets/glass_card.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  String? _latestBarcode;
  late final MobileScannerController _cameraController;
  bool _processing = false;
  bool _autoFlash = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController(formats: [BarcodeFormat.ean13, BarcodeFormat.ean8, BarcodeFormat.upcA, BarcodeFormat.upcE]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Ghost'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WatchlistScreen())),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                  MobileScanner(
                  controller: _cameraController,
                  fit: BoxFit.cover,
                  onDetect: (barcode, args) async {
                    if (_processing) return;
                    final code = barcode.rawValue;
                    if (code == null) return;
                    setState(() {
                      _processing = true;
                      _latestBarcode = code;
                    });
                    // If auto flash enabled, try to enable torch while processing
                    bool turnedOnForScan = false;
                    if (_autoFlash && !_torchOn) {
                      await _cameraController.toggleTorch();
                      turnedOnForScan = true;
                      setState(() {
                        _torchOn = true;
                      });
                    }

                    HapticFeedback.mediumImpact();

                    try {
                      final productAsync = ref.read(productFutureProvider(code).future);
                      final product = await productAsync;
                      if (!mounted) return;
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                    } catch (e) {
                      // ignore errors for now — could show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lookup failed: $e')));
                    } finally {
                      setState(() {
                        _processing = false;
                      });
                      if (turnedOnForScan) {
                        await _cameraController.toggleTorch();
                        setState(() {
                          _torchOn = false;
                        });
                      }
                    }
                  },
                ),
                // Overlay UI
                Positioned(
                  left: 0,
                  right: 0,
                  top: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
                            onPressed: () async {
                              await _cameraController.toggleTorch();
                              setState(() => _torchOn = !_torchOn);
                            },
                          ),
                          IconButton(
                            color: _autoFlash ? Colors.amber : Colors.white,
                            icon: const Icon(Icons.flash_auto),
                            onPressed: () => setState(() => _autoFlash = !_autoFlash),
                          ),
                        ],
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.photo_library),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gallery import not implemented'))),
                      )
                    ],
                  ),
                ),
                // scanning brackets
                Center(child: const ScanBrackets()),
                // Scan area rectangle
                Center(
                  child: Container(
                    width: 260,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white54, width: 2)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (kDebugMode)
                  ElevatedButton(
                    onPressed: () async {
                      // Simulate a barcode scan
                      const code = '0123456789012';
                      setState(() {
                        _latestBarcode = code;
                        _processing = true;
                      });
                      try {
                        final product = await ref.read(productFutureProvider(code).future);
                        if (!mounted) return;
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                      } catch (_) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lookup failed')));
                      } finally {
                        setState(() {
                          _processing = false;
                        });
                      }
                    },
                    child: const Text('Simulate Scan'),
                  ),
                const SizedBox(height: 12.0),
                if (_latestBarcode != null)
                  Center(
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.qr_code),
                        title: Text('Scanned: $_latestBarcode'),
                        subtitle: const Text('Tap to view details'),
                        onTap: () async {
                        final code = _latestBarcode!;
                        setState(() => _processing = true);
                        try {
                          final product = await ref.read(productFutureProvider(code).future);
                          if (!mounted) return;
                          await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lookup failed: $e')));
                        } finally {
                          setState(() => _processing = false);
                        }
                      },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
