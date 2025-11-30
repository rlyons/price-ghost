import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keepa_service.dart';

final keepaServiceProvider = Provider<KeepaService>((ref) {
  // In production, read from environment or secure storage
  const apiKey = String.fromEnvironment('KEEPA_API_KEY', defaultValue: 'PLACEHOLDER');
  return KeepaService(apiKey: apiKey);
});
