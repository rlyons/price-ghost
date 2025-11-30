import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keepa_service.dart';
import '../widgets/price_chart.dart';
import '../providers/watchlist_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final ProductInfo product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final signal = KeepaService(apiKey: 'PLACEHOLDER').predictBuySignal(product.prices90, product.currentPrice);

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.title, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text('Current: \$${product.currentPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(children: [
              Chip(label: Text(signal)),
              const SizedBox(width: 8),
              Chip(label: Text('Low: \$${product.allTimeLow.toStringAsFixed(2)}'))
            ]),
            const SizedBox(height: 12),
            Expanded(child: PriceChart(prices: product.prices90)),
            const SizedBox(height: 12),
            Row(children: [
              Consumer(builder: (context, ref, child) {
                final watchlist = ref.watch(watchlistProvider);
                final isWatching = watchlist.contains(product.ean);
                return ElevatedButton(
                  onPressed: () async {
                    final notifier = ref.read(watchlistProvider.notifier);
                    if (isWatching) await notifier.remove(product.ean);
                    else await notifier.add(product.ean);
                  },
                  child: Text(isWatching ? 'Remove Watch' : 'Add to Watchlist'),
                );
              }),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Buy Now'))
            ])
          ],
        ),
      ),
    );
  }
}
