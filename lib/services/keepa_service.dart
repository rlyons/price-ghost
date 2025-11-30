import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_info.dart';
import 'keepa_parser.dart';
import 'keepa_cache.dart';
import 'fallback_service.dart';

class KeepaService {
  final http.Client? _httpClient;
  late KeepaCache? _cache;
  final FallbackService? _fallbackService;
  int _retryCount = 0;
  DateTime _lastRequestTime = DateTime.now();

  KeepaService({
    http.Client? httpClient,
    KeepaCache? cache,
    FallbackService? fallbackService,
  })  : _httpClient = httpClient,
        _cache = cache,
        _fallbackService = fallbackService;

  Future<ProductInfo> fetchProductInfo(String ean) async {
    await _ensureCacheInitialized();

    // Check cache first
    final cached = _cache!.get(ean);
    if (cached != null) {
      return _createProductInfo(ean, cached.data);
    }

    String? key;
    try {
      key = dotenv.env['KEEPA_API_KEY'];
    } catch (e) {
      key = null;
    }
    if (key == null || key == 'PLACEHOLDER' || key.isEmpty) {
      // Try fallback services if available
      final fallbackResult = await _tryFallbackServices(ean);
      if (fallbackResult != null) return fallbackResult;

      // Fallback to demo data
      await Future.delayed(const Duration(milliseconds: 250));
      return _createDemoProductInfo(ean);
    }

    // Rate limiting and exponential backoff
    await _applyRateLimiting();

    try {
      final response = await _makeRequest(key, ean);
      final keepaResponse = KeepaResponse.fromJson(jsonDecode(response.body));
      final parsedData = KeepaParser.parseProductData(keepaResponse);

      if (parsedData != null) {
        // Cache successful response
        await _cache!.set(ean, parsedData);
        _retryCount = 0; // Reset retry count on success
        return _createProductInfo(ean, parsedData);
      } else {
        // Try fallback services if Keepa parsing failed
        final fallbackResult = await _tryFallbackServices(ean);
        if (fallbackResult != null) return fallbackResult;

        throw Exception('No valid product data in response');
      }
    } catch (e) {
      // Handle rate limiting with exponential backoff
      if (e.toString().contains('429') || e.toString().contains('Rate limited')) {
        await _handleRateLimit();
        // Retry once after backoff
        if (_retryCount < 1) {
          _retryCount++;
          return fetchProductInfo(ean);
        }
      }

      // Try fallback services on any error
      final fallbackResult = await _tryFallbackServices(ean);
      if (fallbackResult != null) return fallbackResult;

      // Fallback to demo data on any error
      _retryCount = 0; // Reset retry count on other errors
      return _createDemoProductInfo(ean);
    }
  }

  Future<ProductInfo?> _tryFallbackServices(String ean) async {
    if (_fallbackService == null || !_fallbackService.hasAvailableServices) {
      return null;
    }

    try {
      return await _fallbackService.lookup(ean);
    } catch (e) {
      print('Fallback service lookup failed: $e');
      return null;
    }
  }

  Future<void> _ensureCacheInitialized() async {
    if (_cache == null) {
      final prefs = await SharedPreferences.getInstance();
      _cache ??= KeepaCache(prefs);
    }
  }

  Future<void> _applyRateLimiting() async {
    const minIntervalMs = 100; // Minimum 100ms between requests
    final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime);
    final waitTime = Duration(milliseconds: minIntervalMs) - timeSinceLastRequest;

    if (waitTime > Duration.zero) {
      await Future.delayed(waitTime);
    }
    _lastRequestTime = DateTime.now();
  }

  Future<void> _handleRateLimit() async {
    // Exponential backoff: wait 2^retryCount seconds
    final backoffSeconds = pow(2, _retryCount).toInt();
    await Future.delayed(Duration(seconds: backoffSeconds));
  }

  Future<http.Response> _makeRequest(String key, String ean) async {
    final url = Uri.parse('https://api.keepa.com/product')
        .replace(queryParameters: {
      'key': key,
      'domain': '1', // US marketplace
      'ean': ean,
      'stats': '90', // Get 90 days of data
    });

    final response = await (_httpClient ?? http.Client()).get(url);
    if (response.statusCode != 200) {
      throw Exception('Keepa API request failed: ${response.statusCode}');
    }
    return response;
  }

  ProductInfo _createProductInfo(String ean, ParsedProductData data) {
    return ProductInfo(
      ean: ean,
      title: data.title,
      currentPrice: data.currentPrice,
      prices90: data.prices90,
      allTimeLow: data.allTimeLow,
    );
  }

  ProductInfo _createDemoProductInfo(String ean) {
    final prices90 = List<double>.generate(90, (i) => 100.0 + i * 0.2);
    return ProductInfo(
      ean: ean,
      title: 'Demo Product for $ean',
      currentPrice: prices90.last,
      prices90: prices90,
      allTimeLow: 80.0,
    );
  }

  // Simple prediction algorithm
  String predictBuySignal(List<double> prices, double currentPrice) {
    if (prices.isEmpty) return 'NEVER';
    final double avg30 = _average(prices.sublist(max(0, prices.length - 30)));
    if (currentPrice < avg30 * 0.9) return 'BUY NOW';
    if (currentPrice > avg30 * 1.1) return 'NEVER';
    return 'WAIT';
  }

  static double _average(List<double> v) => v.reduce((a, b) => a + b) / v.length;
}
