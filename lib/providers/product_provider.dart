import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keepa_service.dart';

final productFutureProvider = FutureProvider.family<ProductInfo, String>((ref, ean) async {
  final keepa = ref.read(keepaServiceProvider);
  return await keepa.fetchProductInfo(ean);
});
