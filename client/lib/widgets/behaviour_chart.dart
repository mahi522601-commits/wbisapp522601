import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class BehaviourChart extends StatelessWidget {
  final List<int> points;

  const BehaviourChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    final spots = points.isEmpty
        ? const [FlSpot(0, 0)]
        : points
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
            .toList();

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: WBISTheme.primaryGreen,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: WBISTheme.primaryGreen.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
