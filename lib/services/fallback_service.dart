import 'product_lookup_service.dart';
import 'upcitemdb_service.dart';
import 'barcode_lookup_service.dart';
import '../models/product_info.dart';

class FallbackService {
  final List<ProductLookupService> _services;

  FallbackService({
    List<ProductLookupService>? services,
    UPCitemdbService? upcitemdbService,
    BarcodeLookupService? barcodeLookupService,
  }) : _services = services ??
           [
             upcitemdbService ?? UPCitemdbService(),
             barcodeLookupService ?? BarcodeLookupService(),
           ];

  /// Look up product information using fallback services
  /// Tries each available service in order until one succeeds
  Future<ProductInfo?> lookup(String ean) async {
    for (final service in _services) {
      if (!service.isAvailable) continue;

      try {
        final result = await service.lookup(ean);
        if (result != null) {
          print('Fallback service ${service.serviceName} found product: ${result.title}');
          return result;
        }
      } catch (e) {
        print('Fallback service ${service.serviceName} failed: $e');
        // Continue to next service
      }
    }

    print('All fallback services failed for EAN: $ean');
    return null;
  }

  /// Get list of available services for debugging
  List<String> get availableServices =>
      _services.where((s) => s.isAvailable).map((s) => s.serviceName).toList();

  /// Check if any fallback services are available
  bool get hasAvailableServices => _services.any((s) => s.isAvailable);

  /// Get the list of services (for testing)
  List<ProductLookupService> get services => _services;
}