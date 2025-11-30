import 'package:flutter_riverpod/flutter_riverpod.dart';

final latestBarcodeProvider = NotifierProvider<LatestBarcodeNotifier, String?>(LatestBarcodeNotifier.new);

class LatestBarcodeNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}
