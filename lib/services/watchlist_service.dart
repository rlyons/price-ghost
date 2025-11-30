import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WatchlistService {
  static const _key = 'price_ghost_watchlist';

  Future<List<String>> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List<dynamic> json = jsonDecode(raw);
    return json.cast<String>();
  }

  Future<void> addToWatchlist(String ean) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadWatchlist();
    if (!list.contains(ean)) list.add(ean);
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> removeFromWatchlist(String ean) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadWatchlist();
    list.remove(ean);
    await prefs.setString(_key, jsonEncode(list));
  }
}
