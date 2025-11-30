import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;
  const PriceChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return const Center(child: Text('No data'));

    final spots = <FlSpot>[];
    for (var i = 0; i < prices.length; i++) {
      spots.add(FlSpot(i.toDouble(), prices[i]));
    }

    final currentIndex = prices.length - 1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            dotData: FlDotData(show: true, getDotPainter: (spot, __, ___, ____){
              if (spot.x == currentIndex) return FlDotCirclePainter(radius: 6, color: Colors.green);
              return FlDotCirclePainter(radius: 3, color: Colors.white);
            }),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Colors.green.withOpacity(0.3), Colors.transparent])),
            gradient: LinearGradient(colors: [Colors.greenAccent]),
            barWidth: 2.0,
          )
        ],
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
