import 'package:clothing_admin_panel/views/widgets/order/order_table_helper.dart';
import 'package:clothing_admin_panel/views/widgets/order/user_table_helper.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTableView extends StatefulWidget {
  const UserTableView({
    super.key,
    required this.usersList,
    required this.orderCounts,
  });

  final List<QueryDocumentSnapshot>? usersList;
  final List<int> orderCounts;

  @override
  TableViewOrderState createState() => TableViewOrderState();
}

class TableViewOrderState extends State<UserTableView> {
  String? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              buildUserTableHeader(),
              for (var i = 0; i < widget.usersList!.length; i++)
                buildUserTableRow(
                  user: widget.usersList![i],
                  index: i + 1,
                  orderCount: widget.orderCounts[i],
                  selectedUserId: selectedUserId,
                  onSelectUser: (userid) {
                    setState(() {
                      selectedUserId = selectedUserId == userid ? null : userid;
                      
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Order Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (selectedUserId != null) _buildOrderDetailsTable(selectedUserId!),
        ],
      ),
    );
  }

  Widget _buildOrderDetailsTable(String userId) {

    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            'No orders found for this user.',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          );
        }

        final orders = snapshot.data!.docs;
        return Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            buildOrderTableHeader(),
            for (var i = 0; i < orders.length; i++)
              buildOrderTableRow(order: orders[i], 
              index: i + 1, 
              context: context,
              onStatusUpdated: () {
                setState(() {
                  
                });
              },
            ),
          ],
        );
      },
    );
  }
}

















