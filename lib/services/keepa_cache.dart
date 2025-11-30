import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'keepa_parser.dart';

class CachedProductData {
  final ParsedProductData data;
  final DateTime cachedAt;

  CachedProductData({
    required this.data,
    required this.cachedAt,
  });

  bool get isExpired => DateTime.now().difference(cachedAt) > const Duration(hours: 24);

  Map<String, dynamic> toJson() => {
    'data': {
      'title': data.title,
      'currentPrice': data.currentPrice,
      'prices90': data.prices90,
      'allTimeLow': data.allTimeLow,
    },
    'cachedAt': cachedAt.toIso8601String(),
  };

  factory CachedProductData.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>;
    final data = ParsedProductData(
      title: dataJson['title'] as String,
      currentPrice: dataJson['currentPrice'] as double,
      prices90: (dataJson['prices90'] as List<dynamic>).map((e) => e as double).toList(),
      allTimeLow: dataJson['allTimeLow'] as double,
    );
    return CachedProductData(
      data: data,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );
  }
}

class KeepaCache {
  static const String _cachePrefix = 'keepa_cache_';
  final SharedPreferences _prefs;

  KeepaCache(this._prefs);

  String _getCacheKey(String ean) => '$_cachePrefix$ean';

  Future<void> set(String ean, ParsedProductData data) async {
    final cached = CachedProductData(data: data, cachedAt: DateTime.now());
    final json = jsonEncode(cached.toJson());
    await _prefs.setString(_getCacheKey(ean), json);
  }

  CachedProductData? get(String ean) {
    final key = _getCacheKey(ean);
    final jsonStr = _prefs.getString(key);
    if (jsonStr == null) return null;

    try {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final cached = CachedProductData.fromJson(json);
      if (cached.isExpired) {
        // Remove expired cache
        _prefs.remove(key);
        return null;
      }
      return cached;
    } catch (e) {
      // Remove corrupted cache
      _prefs.remove(key);
      return null;
    }
  }

  Future<void> clear() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }

  Future<void> clearExpired() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      final jsonStr = _prefs.getString(key);
      if (jsonStr != null) {
        try {
          final json = jsonDecode(jsonStr) as Map<String, dynamic>;
          final cached = CachedProductData.fromJson(json);
          if (cached.isExpired) {
            await _prefs.remove(key);
          }
        } catch (e) {
          await _prefs.remove(key);
        }
      }
    }
  }
}