import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_info.dart';
import 'keepa_provider.dart';

final productFutureProvider = FutureProvider.family<ProductInfo, String>((ref, ean) async {
  final keepa = ref.read(keepaServiceProvider);
  return await keepa.fetchProductInfo(ean);
});
