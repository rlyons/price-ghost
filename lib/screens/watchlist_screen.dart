import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/watchlist_provider.dart';
import '../providers/product_provider.dart';
import 'product_detail_screen.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(watchlistProvider);
    if (list.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Watchlist')),
        body: const Center(child: Text('No items in your watchlist')), 
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final ean = list[index];
          return ListTile(
            title: Text(ean),
            onTap: () async {
              final product = await ref.read(productFutureProvider(ean).future);
              if (!context.mounted) return;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
            },
          );
        },
      ),
    );
  }
}
