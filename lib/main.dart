import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'screens/scanner_screen.dart';
import 'services/notification_service.dart';
import 'services/pricing_checker.dart';
import 'services/watchlist_service.dart';
import 'services/keepa_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb == false) {
    // Initialize notifications here; Supabase is initialized via provider if configured
    final notifier = NotificationService();
    await notifier.init();
    // Start a simple periodic in-app pricing checker for watchers if desired
    final watchlistService = WatchlistService();
    final keepa = KeepaService();
    final checker = PricingChecker(watchlistService: watchlistService, keepaService: keepa, notificationService: notifier);
    // For development, poll every 24 hours. In production, use server-side or background scheduler.
    checker.startPolling(interval: const Duration(hours: 24));
  }
  runApp(const ProviderScope(child: PriceGhostApp()));
}

class PriceGhostApp extends StatelessWidget {
  const PriceGhostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Ghost',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: const ScannerScreen(),
    );
  }
}
