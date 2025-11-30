import 'package:price_ghost/services/product_lookup_service.dart';
import 'package:price_ghost/models/product_info.dart';

/// Mock ProductLookupService for testing
class MockProductLookupService implements ProductLookupService {
  final String _serviceName;
  final bool _isAvailable;
  final ProductInfo? Function(String)? _lookupResult;
  final bool _shouldThrow;
  int lookupCallCount = 0;

  MockProductLookupService({
    required String serviceName,
    bool isAvailable = true,
    ProductInfo? Function(String)? lookupResult,
    bool shouldThrow = false,
  })  : _serviceName = serviceName,
        _isAvailable = isAvailable,
        _lookupResult = lookupResult,
        _shouldThrow = shouldThrow;

  @override
  String get serviceName => _serviceName;

  @override
  bool get isAvailable => _isAvailable;

  @override
  Future<ProductInfo?> lookup(String ean) async {
    lookupCallCount++;
    if (_shouldThrow) {
      throw Exception('Mock service error');
    }
    return _lookupResult?.call(ean);
  }
}
