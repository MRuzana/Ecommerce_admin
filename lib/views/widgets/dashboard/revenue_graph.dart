import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueBarChart extends StatelessWidget {
  final Map<String, double> revenueData;

  const RevenueBarChart({super.key, required this.revenueData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround, // Reduce gaps between bars
          barGroups: _buildBarGroups(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // Reserve space for the title
                getTitlesWidget: (double value, TitleMeta meta) {
                  List<String> days = revenueData.keys.toList();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      days[value.toInt()], // Use the formatted date string
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40 , // Reserve space for the title
                interval: 1000, // Set interval for revenue values
                getTitlesWidget: (double value, TitleMeta meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      value.toStringAsFixed(0), // Show whole numbers
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true, // Show border lines
            border: const Border(
              bottom: BorderSide(color: Colors.black, width: 1), // X-axis
              left: BorderSide(color: Colors.black, width: 1), // Y-axis
            ),
          ),
          gridData: const FlGridData(show: true, verticalInterval: 1), // Show grid lines
          barTouchData: BarTouchData(enabled: true), // Enable touch interactions
          maxY: revenueData.values.isNotEmpty ? revenueData.values.reduce((a, b) => a > b ? a : b) + 1000 : 1000,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    List<BarChartGroupData> barGroups = [];
    List<String> days = revenueData.keys.toList();

    for (int i = 0; i < days.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: revenueData[days[i]]!,
              width: 25 , // Reduce the width of each bar for less gap
              borderRadius: BorderRadius.zero, // Make bars rectangular
              color: Colors.blue, // Color of the bar
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}