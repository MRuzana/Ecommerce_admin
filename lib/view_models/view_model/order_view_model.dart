// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderViewModel extends ChangeNotifier {
  Future<void> updateStatus(
      String userId,
      String orderId,
      String selectedStatus,
      BuildContext context,
      VoidCallback onStatusUpdated) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .where('order_id', isEqualTo: orderId) // Match the Razorpay orderId
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first matching document
      DocumentSnapshot orderDoc = querySnapshot.docs.first;
      String docId = orderDoc.id;

      // Update the 'status' field
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(docId)
          .update({
        'status': selectedStatus,
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Status updated'),
        ),
      );
      onStatusUpdated(); //refresh table
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUserOrdersWithStatus() async {
    List<Map<String, dynamic>> allOrders =
        []; // Change the type to hold order details
    try {
      // Step 1: Get all users
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Step 2: Loop through each user and get their orders
      for (QueryDocumentSnapshot user in usersSnapshot.docs) {
        QuerySnapshot userOrders = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id) // Assuming 'user.id' is the user document ID
            .collection('orders')
            .get();

        // Step 3: Loop through each user's orders and add the status
        for (var order in userOrders.docs) {
          Map<String, dynamic> orderData = order.data()
              as Map<String, dynamic>; // Cast the order data to a map
          orderData['userId'] = user.id; // Add user ID to the order data
          allOrders.add(orderData); // Add each order to the list
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }

    // Print out the status of each order
    // for (var order in allOrders) {
    //   print('Order ID: ${order['order_id']}, Status: ${order['status']}');
    // }

    //print('Total orders fetched: ${allOrders.length}');
    return allOrders; // Returns a list of maps containing order details for each user
  }

  Future<Map<String, int>> fetchOrderStatusCounts() async {
    Map<String, int> statusCounts = {
      'Order Placed': 0,
      'Shipped': 0,
      'Out for delivery': 0,
      'Delivered': 0,
    };

    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot user in usersSnapshot.docs) {
        QuerySnapshot userOrders = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .collection('orders')
            .get();

        for (var order in userOrders.docs) {
          String status =
              (order.data() as Map<String, dynamic>)['status'] ?? '';
          if (statusCounts.containsKey(status)) {
            statusCounts[status] = statusCounts[status]! + 1;
          }
        }
      }
    } catch (e) {
      print("Error fetching order status counts: $e");
    }

    return statusCounts; // Returns a map with counts of each status
  }

Future<Map<String, double>> fetchRevenue() async {
  double totalRevenue = 0.0;      // For all-time total revenue
  double lastWeekRevenue = 0.0;   // For revenue in the last 7 days
  double todayRevenue = 0.0;      // For revenue today

  DateTime now = DateTime.now();
  DateTime last7Days = now.subtract(const Duration(days: 6)); // Date 7 days ago
  DateTime startOfToday = DateTime(now.year, now.month, now.day); // Start of today (midnight)

  try {
    // Step 1: Get all users
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Step 2: Loop through each user and get their orders
    for (QueryDocumentSnapshot user in usersSnapshot.docs) {
      QuerySnapshot userOrders = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('orders')
          .get();

      // Step 3: Loop through each user's orders and categorize revenue
      for (var order in userOrders.docs) {
        Map<String, dynamic> orderData = order.data() as Map<String, dynamic>;

        // Ensure the order contains the 'totalAmount' and 'timestamp' fields
        if (orderData.containsKey('totalAmount') && orderData.containsKey('timestamp')) {
          double orderAmount = (orderData['totalAmount'] as num).toDouble();
          DateTime orderDate = (orderData['timestamp'] as Timestamp).toDate();

          // Add to total revenue
          totalRevenue += orderAmount;

          // Add to last week's revenue if within the last 7 days
          if (orderDate.isAfter(last7Days)) {
            lastWeekRevenue += orderAmount;
          }

          // Add to today's revenue if the order was placed today
          if (orderDate.isAfter(startOfToday)) {
            todayRevenue += orderAmount;
          }
        }
      }
    }
  } catch (e) {
    print("Error fetching revenue: $e");
  }

  // Return the calculated revenues
  return {
    'totalRevenue': totalRevenue,
    'lastWeekRevenue': lastWeekRevenue,
    'todayRevenue': todayRevenue,
  };
}


Future<Map<String, double>> fetchLastWeekRevenue() async {
  Map<String, double> dailyRevenue = {};  // Revenue for each day in the last week
  DateTime now = DateTime.now();

  // Initialize map with last 7 days
  for (int i = 0; i < 7; i++) {
    DateTime date = now.subtract(Duration(days: i));
    String formattedDate = '${date.day}-${date.month}-${date.year}'; // Format: DD-MM-YYYY
    dailyRevenue[formattedDate] = 0.0;
  }

  try {
    // Step 1: Get all users
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Step 2: Loop through each user and get their orders
    for (QueryDocumentSnapshot user in usersSnapshot.docs) {
      QuerySnapshot userOrders = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('orders')
          .get();

      // Step 3: Loop through each user's orders
      for (var order in userOrders.docs) {
        Map<String, dynamic> orderData = order.data() as Map<String, dynamic>;

        if (orderData.containsKey('totalAmount') && orderData.containsKey('timestamp')) {
          double orderAmount = (orderData['totalAmount'] as num).toDouble();
          DateTime orderDate = (orderData['timestamp'] as Timestamp).toDate();
          String formattedDate = '${orderDate.day}-${orderDate.month}-${orderDate.year}'; // Format: DD-MM-YYYY

          // If the order was placed in the last 7 days, add it to the map
          if (dailyRevenue.containsKey(formattedDate)) {
            dailyRevenue[formattedDate] = dailyRevenue[formattedDate]! + orderAmount;
          }
        }
      }
    }
  } catch (e) {
    print("Error fetching last week revenue: $e");
  }

  return dailyRevenue; // Return daily revenue for the last week
}
}
