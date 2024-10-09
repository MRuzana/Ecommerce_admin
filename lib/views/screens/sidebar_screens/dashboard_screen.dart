import 'package:clothing_admin_panel/view_models/view_model/order_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/dashboard/order_section.dart';
import 'package:clothing_admin_panel/views/widgets/dashboard/revenue_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});
  static const String routName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrderViewModel>(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<Map<String, int>>(
              future: viewModel.fetchOrderStatusCounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No order statuses found.');
                }

                final statusCounts = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                       buildOrderSection(context, statusCounts),
                      _buildRevenueSection(context),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text('Revenue',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 20),

            // Use FutureBuilder to fetch and display revenue cards
            FutureBuilder<List<Widget>>(
              future: _buildRevenueCards(width, width <= 600,
                  context), // Pass `isColumn` based on width
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return width > 600
                      ? Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Horizontal layout
                          children: snapshot.data!, // Use the loaded widgets
                        )
                      : Column(
                          children: snapshot.data!, // Vertical layout
                        );
                }
              },
            ),

            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(25 ),
              child: Text('Last week Revenue'),
            ),

            FutureBuilder<Map<String, double>>(
            future: Provider.of<OrderViewModel>(context, listen: false).fetchLastWeekRevenue(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No revenue data available.');
              }

              return RevenueBarChart(revenueData: snapshot.data!);
            },
          ),
           // const Divider(height: 2),
          //  const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}

  Future<List<Widget>> _buildRevenueCards(double width, bool isColumn, BuildContext context) async {
    double cardWidth = width > 600 ? (width / 3) - 20 : width - 40;

    Map<String, double> revenues = await Provider.of<OrderViewModel>(context, listen: false).fetchRevenue();
    double? totalRevenue = revenues['totalRevenue'];
    double? lastWeekRevenue = revenues['lastWeekRevenue'];
    double? todaysRevenue = revenues['todayRevenue'];

    return [
      Padding(
        padding: isColumn
            ? const EdgeInsets.only(bottom: 10.0) // Vertical padding for Column
            : const EdgeInsets.only(right: 10.0), // Horizontal padding for Row
        child: _buildRevenueCard(
            'Total Revenue', '₹$totalRevenue', cardWidth),
      ),
      Padding(
        padding: isColumn
            ? const EdgeInsets.only(bottom: 10.0) // Vertical padding for Column
            : const EdgeInsets.only(right: 10.0), // Horizontal padding for Row
        child: _buildRevenueCard('Today\'s Revenue', '₹$todaysRevenue', cardWidth),
      ),
      Padding(
        padding: isColumn
            ? const EdgeInsets.only(bottom: 10.0) // Vertical padding for Column
            : const EdgeInsets.only(right: 10.0), // Horizontal padding for Row
        child: _buildRevenueCard('Last Week\'s Revenue', '₹$lastWeekRevenue', cardWidth),
      ),
    ];
  }

  Widget _buildRevenueCard(String title, String amount, double width) {
    return Container(
      width: width,
      height: 100,
      color: Colors.amber[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

