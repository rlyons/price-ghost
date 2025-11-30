import '../models/product_info.dart';

/// Common interface for product lookup services
abstract class ProductLookupService {
  /// Look up product information by EAN/UPC
  Future<ProductInfo?> lookup(String ean);

  /// Whether this service is available (has API key, etc.)
  bool get isAvailable;

  /// Service name for logging/debugging
  String get serviceName;
}