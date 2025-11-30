import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

final supabaseServiceProvider = FutureProvider<SupabaseService?>((ref) async {
  const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const key = String.fromEnvironment('SUPABASE_KEY', defaultValue: '');
  if (url.isEmpty || key.isEmpty) return null;
  try {
    final svc = await SupabaseService.initialize(url: url, anonKey: key);
    return svc;
  } catch (_) {
    return null;
  }
});
