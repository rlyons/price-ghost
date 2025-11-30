import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'product_lookup_service.dart';
import '../models/product_info.dart';

class UPCitemdbService implements ProductLookupService {
  final http.Client _httpClient;

  UPCitemdbService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  String get serviceName => 'UPCitemdb';

  @override
  bool get isAvailable {
    try {
      final key = dotenv.env['UPCITEMDB_KEY'];
      return key != null && key.isNotEmpty && key != 'PLACEHOLDER';
    } catch (e) {
      // dotenv not initialized, assume not available
      return false;
    }
  }

  @override
  Future<ProductInfo?> lookup(String ean) async {
    if (!isAvailable) return null;

    final key = dotenv.env['UPCITEMDB_KEY'];
    if (key == null) return null;

    try {
      final url = Uri.parse('https://api.upcitemdb.com/prod/trial/lookup')
          .replace(queryParameters: {
        'upc': ean,
      });

      final response = await _httpClient.get(url, headers: {
        'user_key': key,
        'key_type': '3scale',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseResponse(ean, data);
      }
    } catch (e) {
      // Log error but don't throw - fallback services should fail gracefully
      // UPCitemdb lookup failed: $e
    }

    return null;
  }

  ProductInfo? _parseResponse(String ean, Map<String, dynamic> data) {
    final items = data['items'] as List<dynamic>?;
    if (items == null || items.isEmpty) return null;

    final item = items.first as Map<String, dynamic>;
    final title = item['title'] as String?;
    final brand = item['brand'] as String?;
    final model = item['model'] as String?;

    // UPCitemdb doesn't provide pricing, so we'll create a basic ProductInfo
    // with placeholder pricing that indicates it's from a fallback service
    final displayTitle = title ?? '${brand ?? 'Unknown'} ${model ?? 'Product'}';

    // Create approximate price history - fallback services typically don't have historical data
    final prices90 = List<double>.filled(90, 0.0); // Placeholder prices

    return ProductInfo(
      ean: ean,
      title: displayTitle,
      currentPrice: 0.0, // Unknown price from fallback
      prices90: prices90,
      allTimeLow: 0.0, // Unknown ATL from fallback
    );
  }
}