import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService._(this._client);

  /// Initialize Supabase using the provided URL and anonKey.
  static Future<SupabaseService> initialize({required String url, required String anonKey}) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    final client = Supabase.instance.client;
    return SupabaseService._(client);
  }

  Future<void> addWatch(String ean, {String? userId}) async {
    final res = await _client.from('watches').insert({
      'ean': ean,
      'user_id': userId,
      'created_at': DateTime.now().toIso8601String(),
    }).execute();
    if (res.error != null) {
      throw Exception('Supabase addWatch failed: ${res.error!.message}');
    }
  }

  Future<void> removeWatch(String ean, {String? userId}) async {
    var query = _client.from('watches').delete();
    query = query.eq('ean', ean);
    if (userId != null) query = query.eq('user_id', userId);
    final res = await query.execute();
    if (res.error != null) {
      throw Exception('Supabase removeWatch failed: ${res.error!.message}');
    }
  }

  Future<List<String>> fetchWatchlist({String? userId}) async {
    var query = _client.from('watches').select('ean');
    if (userId != null) query = query.eq('user_id', userId);
    final res = await query.execute();
    if (res.error != null) return [];
    final data = res.data as List<dynamic>? ?? [];
    return data.map((e) => e['ean'] as String).toList();
  }
}
