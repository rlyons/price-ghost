import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'product_lookup_service.dart';
import '../models/product_info.dart';

class BarcodeLookupService implements ProductLookupService {
  final http.Client _httpClient;

  BarcodeLookupService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  @override
  String get serviceName => 'Barcode Lookup';

  @override
  bool get isAvailable {
    try {
      final key = dotenv.env['BARCODE_LOOKUP_KEY'];
      return key != null && key.isNotEmpty && key != 'PLACEHOLDER';
    } catch (e) {
      // dotenv not initialized, assume not available
      return false;
    }
  }

  @override
  Future<ProductInfo?> lookup(String ean) async {
    if (!isAvailable) return null;

    final key = dotenv.env['BARCODE_LOOKUP_KEY'];
    if (key == null) return null;

    try {
      final url = Uri.parse('https://api.barcodelookup.com/v3/products')
          .replace(queryParameters: {
        'barcode': ean,
        'key': key,
      });

      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseResponse(ean, data);
      }
    } catch (e) {
      // Log error but don't throw - fallback services should fail gracefully
      // Barcode Lookup failed: $e
    }

    return null;
  }

  ProductInfo? _parseResponse(String ean, Map<String, dynamic> data) {
    final products = data['products'] as List<dynamic>?;
    if (products == null || products.isEmpty) return null;

    final product = products.first as Map<String, dynamic>;
    final title = product['product_name'] as String?;
    final brand = product['brand'] as String?;
    final category = product['category'] as String?;

    // Barcode Lookup may provide pricing information
    final stores = product['stores'] as List<dynamic>?;
    double? currentPrice;
    if (stores != null && stores.isNotEmpty) {
      final store = stores.first as Map<String, dynamic>;
      final priceStr = store['price'] as String?;
      if (priceStr != null) {
        currentPrice = double.tryParse(priceStr.replaceAll('\$', ''));
      }
    }

    final displayTitle = title ?? '${brand ?? 'Unknown'} ${category ?? 'Product'}';

    // Create approximate price history - most fallback services don't have historical data
    final prices90 = List<double>.filled(90, currentPrice ?? 0.0);

    return ProductInfo(
      ean: ean,
      title: displayTitle,
      currentPrice: currentPrice ?? 0.0,
      prices90: prices90,
      allTimeLow: currentPrice ?? 0.0, // Use current price as ATL if available
    );
  }
}