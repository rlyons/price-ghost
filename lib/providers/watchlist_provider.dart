import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import '../services/watchlist_service.dart';
import 'supabase_provider.dart';

final watchlistServiceProvider = Provider<WatchlistService>((ref) {
  final supabaseAsync = ref.watch(supabaseServiceProvider);
  final supabase = supabaseAsync.maybeWhen(data: (s) => s, orElse: () => null);
  return WatchlistService(supabaseService: supabase);
});

final watchlistProvider = StateNotifierProvider<WatchlistNotifier, List<String>>(create: (ref) {
  final service = ref.read(watchlistServiceProvider);
  return WatchlistNotifier(service);
});

class WatchlistNotifier extends StateNotifier<List<String>> {
  final WatchlistService service;

  WatchlistNotifier(this.service) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await service.loadWatchlist();
  }

  Future<void> add(String ean) async {
    await service.addToWatchlist(ean);
    state = await service.loadWatchlist();
  }

  Future<void> remove(String ean) async {
    await service.removeFromWatchlist(ean);
    state = await service.loadWatchlist();
  }
}
