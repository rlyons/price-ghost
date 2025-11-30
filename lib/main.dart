import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import 'screens/scanner_screen.dart';
import 'services/notification_service.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb == false) {
    // Initialize notifications / supabase here if configured
    final notifier = NotificationService();
    await notifier.init();
    final supabase = SupabaseService();
    await supabase.init();
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
