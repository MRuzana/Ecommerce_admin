import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildOrderSection(
      BuildContext context, Map<String, int> statusCounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(
            'Orders',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Align the row to the start
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderPieChart(statusCounts),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 25),
              child: _buildLegend(statusCounts),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Divider(
          height: 2,
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _buildOrderPieChart(Map<String, int> statusCounts) {
    return Container(
      height: 200, // Increased size of the pie chart
      width: 200,
      alignment: Alignment.center,
      child: PieChart(
        PieChartData(
            sections: pieChartSectionData(statusCounts),
            centerSpaceRadius: 50,
            pieTouchData: PieTouchData()),
      ),
    );
  }

  List<PieChartSectionData> pieChartSectionData(Map<String, int> statusCounts) {
    return [
      PieChartSectionData(
          value: statusCounts['Order Placed']?.toDouble() ?? 0,
          color: Colors.blue, // Color for Order Placed
          title: '${statusCounts['Order Placed']}',
          radius: 50),
      PieChartSectionData(
          value: statusCounts['Shipped']?.toDouble() ?? 0,
          color: Colors.red, // Color for Shipped
          title: '${statusCounts['Shipped']} ',
          radius: 50),
      PieChartSectionData(
          value: statusCounts['Out for delivery']?.toDouble() ?? 0,
          color: Colors.orange, // Color for Out for delivery
          title: '${statusCounts['Out for delivery']}',
          radius: 50),
      PieChartSectionData(
          value: statusCounts['Delivered']?.toDouble() ?? 0,
          color: Colors.green, // Color for Delivered
          title: '${statusCounts['Delivered']}',
          radius: 50),
    ];
  }

  Widget _buildLegend(Map<String, int> statusCounts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLegendItem(Colors.blue, 'Order Placed'),
        _buildLegendItem(Colors.red, 'Shipped'),
        _buildLegendItem(Colors.orange, 'Out for delivery'),
        _buildLegendItem(Colors.green, 'Delivered'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 16), // More spacing
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              //borderRadius: BorderRadius.circular(4), // Rounded corners
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }