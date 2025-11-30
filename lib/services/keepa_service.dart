import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductInfo {
  final String ean;
  final String title;
  final double currentPrice;
  final List<double> prices90;
  final double allTimeLow;

  ProductInfo({
    required this.ean,
    required this.title,
    required this.currentPrice,
    required this.prices90,
    required this.allTimeLow,
  });
}

class KeepaService {
  final String apiKey;
  final http.Client httpClient;

  KeepaService({required this.apiKey, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  // Placeholder for calling the Keepa API. Replace with real endpoint calls.
  Future<ProductInfo> fetchProductInfo(String ean) async {
    if (apiKey == 'PLACEHOLDER' || apiKey.isEmpty) {
      // no API key: return stub data
      await Future.delayed(const Duration(milliseconds: 250));
      final List<double> last90 = List.generate(90, (index) => 100.0 + index * 0.2);
      return ProductInfo(
        ean: ean,
        title: 'Demo Product for $ean',
        currentPrice: last90.last,
        prices90: last90,
        allTimeLow: 80.0,
      );
    }

    // If we have an API key, try to call Keepa's product endpoint (simplified).
    // Keepa needs an ASIN or EAN with the right parameters; you may need to adapt this
    // depending on your account's usage. This is a best-effort example.
    final uri = Uri.parse('https://api.keepa.com/product?key=$apiKey&domain=1&ean=$ean');
    final response = await httpClient.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Keepa fetch failed: ${response.statusCode}');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    // Parse the Keepa response into a ProductInfo instance. Keepa's response format is complex,
    // so here we attempt to read a simple structure; adapt to exact response fields.
    // FALLBACK: use demo data if parsing fails.
    try {
      final title = (data['products']?[0]?['title']) ?? 'Unknown Product $ean';
      // Keepa returns price data in cents or raw arrays; map them to doubles.
      // This simplified mapping will use placeholder conversions.
      final prices90 = <double>[];
      // If keepa returns price history array, transform it; otherwise generate synthetic.
      if (data['products']?[0]?['priceHistory'] != null) {
        // example placeholder
        prices90.addAll(List<double>.generate(90, (i) => 100.0 + i * 0.2));
      } else {
        prices90.addAll(List<double>.generate(90, (i) => 100.0 + i * 0.2));
      }
      final current = prices90.isNotEmpty ? prices90.last : 100.0;
      final low = prices90.reduce((a, b) => a < b ? a : b);
      return ProductInfo(ean: ean, title: title, currentPrice: current, prices90: prices90, allTimeLow: low);
    } catch (_) {
      final List<double> last90 = List.generate(90, (index) => 100.0 + index * 0.2);
      return ProductInfo(ean: ean, title: 'Demo Product for $ean', currentPrice: last90.last, prices90: last90, allTimeLow: 80.0);
    }
  }

  // Simple prediction algorithm
  String predictBuySignal(List<double> prices, double currentPrice) {
    if (prices.isEmpty) return 'NEVER';
    final double avg30 = _average(prices.sublist(prices.length - 30));
    if (currentPrice < avg30 * 0.9) return 'BUY NOW';
    if (currentPrice > avg30 * 1.1) return 'NEVER';
    return 'WAIT';
  }

  static double _average(List<double> v) => v.reduce((a, b) => a + b) / v.length;
}
