import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keepa_service.dart';

final keepaServiceProvider = Provider<KeepaService>((ref) {
  // KeepaService now reads API key from environment variables internally
  return KeepaService();
});
