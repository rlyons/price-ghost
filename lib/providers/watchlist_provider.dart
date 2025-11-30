import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/watchlist_service.dart';
import 'supabase_provider.dart';

final watchlistServiceProvider = Provider<WatchlistService>((ref) {
  final supabaseAsync = ref.watch(supabaseServiceProvider);
  final supabase = supabaseAsync.maybeWhen(data: (s) => s, orElse: () => null);
  return WatchlistService(supabaseService: supabase);
});

final watchlistProvider = NotifierProvider<WatchlistNotifier, List<String>>(WatchlistNotifier.new);

class WatchlistNotifier extends Notifier<List<String>> {
  late final WatchlistService service;

  @override
  List<String> build() {
    service = ref.read(watchlistServiceProvider);
    _load();
    return [];
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
