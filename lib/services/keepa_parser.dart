

class KeepaProduct {
  final String asin;
  final String title;
  final List<List<dynamic>> csv;
  final Map<String, dynamic>? offers;

  KeepaProduct({
    required this.asin,
    required this.title,
    required this.csv,
    this.offers,
  });

  factory KeepaProduct.fromJson(Map<String, dynamic> json) {
    return KeepaProduct(
      asin: json['asin'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Product',
      csv: (json['csv'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList() ?? [],
      offers: json['offers'] as Map<String, dynamic>?,
    );
  }
}

class KeepaResponse {
  final List<KeepaProduct> products;

  KeepaResponse({required this.products});

  factory KeepaResponse.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List<dynamic>?)
        ?.map((e) => KeepaProduct.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];
    return KeepaResponse(products: products);
  }
}

class ParsedProductData {
  final String title;
  final double currentPrice;
  final List<double> prices90;
  final double allTimeLow;

  ParsedProductData({
    required this.title,
    required this.currentPrice,
    required this.prices90,
    required this.allTimeLow,
  });
}

class KeepaParser {
  /// Parse Keepa CSV data to extract Amazon prices (index 0)
  static List<PricePoint> parseAmazonPrices(List<List<dynamic>> csv) {
    final prices = <PricePoint>[];
    for (final entry in csv) {
      if (entry.length > 1) {
        final time = entry[0] as int?;
        final amazonPrice = entry[1] as int?;
        if (time != null && amazonPrice != null && amazonPrice != -1) {
          final dateTime = DateTime.fromMillisecondsSinceEpoch(time * 60000); // minutes to ms
          final price = amazonPrice / 100.0; // cents to dollars
          prices.add(PricePoint(dateTime, price));
        }
      }
    }
    prices.sort((a, b) => a.time.compareTo(b.time));
    return prices;
  }

  /// Extract product data from Keepa response
  static ParsedProductData? parseProductData(KeepaResponse response) {
    if (response.products.isEmpty) return null;

    final product = response.products.first;
    final amazonPrices = parseAmazonPrices(product.csv);

    if (amazonPrices.isEmpty) return null;

    // Get last 90 days prices
    final ninetyDaysAgo = DateTime.now().subtract(const Duration(days: 90));
    final prices90 = amazonPrices
        .where((p) => p.time.isAfter(ninetyDaysAgo))
        .map((p) => p.price)
        .toList();

    // If no prices in last 90 days, take the most recent ones
    if (prices90.isEmpty) {
      prices90.addAll(amazonPrices.take(90).map((p) => p.price));
    }

    final currentPrice = amazonPrices.last.price;
    final allTimeLow = amazonPrices.map((p) => p.price).reduce((a, b) => a < b ? a : b);

    return ParsedProductData(
      title: product.title,
      currentPrice: currentPrice,
      prices90: prices90,
      allTimeLow: allTimeLow,
    );
  }
}

class PricePoint {
  final DateTime time;
  final double price;

  PricePoint(this.time, this.price);
}