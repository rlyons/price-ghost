import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';

class WatchlistService {
  static const _key = 'price_ghost_watchlist';
  final SupabaseService? supabaseService;

  WatchlistService({this.supabaseService});

  Future<List<String>> loadWatchlist({String? userId}) async {
    if (supabaseService != null) {
      try {
        return await supabaseService!.fetchWatchlist(userId: userId);
      } catch (_) {
        // fallback to local
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> json = jsonDecode(raw);
    return json.cast<String>();
  }

  Future<void> addToWatchlist(String ean, {String? userId}) async {
    if (supabaseService != null) {
      try {
        await supabaseService!.addWatch(ean, userId: userId);
        return;
      } catch (_) {
        // fallback to local storage
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final list = await loadWatchlist();
    if (!list.contains(ean)) list.add(ean);
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> removeFromWatchlist(String ean, {String? userId}) async {
    if (supabaseService != null) {
      try {
        await supabaseService!.removeWatch(ean, userId: userId);
        return;
      } catch (_) {
        // fallback to local
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final list = await loadWatchlist();
    list.remove(ean);
    await prefs.setString(_key, jsonEncode(list));
  }
}
