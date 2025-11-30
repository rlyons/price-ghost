import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductInfo {
  final String title;
  final double currentPrice;
  final List<double> prices90;
  final double allTimeLow;

  ProductInfo({
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
    await Future.delayed(const Duration(milliseconds: 250));

    final List<double> last90 = List.generate(90, (index) => 100.0 + index * 0.2);

    return ProductInfo(
      title: 'Demo Product for $ean',
      currentPrice: last90.last,
      prices90: last90,
      allTimeLow: 80.0,
    );
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
