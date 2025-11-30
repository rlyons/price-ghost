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