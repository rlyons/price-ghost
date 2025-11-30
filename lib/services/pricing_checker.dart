import 'dart:async';

import 'services/watchlist_service.dart';
import 'services/keepa_service.dart';
import 'services/notification_service.dart';

class PricingChecker {
  final WatchlistService watchlistService;
  final KeepaService keepaService;
  final NotificationService notificationService;
  Timer? _timer;

  PricingChecker({
    required this.watchlistService,
    required this.keepaService,
    required this.notificationService,
  });

  void startPolling({Duration interval = const Duration(hours: 24)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => _checkAll());
  }

  Future<void> _checkAll() async {
    final list = await watchlistService.loadWatchlist();
    for (final ean in list) {
      try {
        final product = await keepaService.fetchProductInfo(ean);
        final signal = keepaService.predictBuySignal(product.prices90, product.currentPrice);
        if (signal == 'BUY NOW') {
          // This is a simple notification; in production you'd send an FCM message or local notification
          // We just call a stubbed notification service
          await notificationService.init();
        }
      } catch (_) {
        // ignore errors
      }
    }
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
