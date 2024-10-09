import 'package:clothing_admin_panel/views/widgets/order/bottomsheet_order.dart';
import 'package:clothing_admin_panel/views/widgets/order/edit_order_status.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Order Table Header
TableRow buildOrderTableHeader() {
  return TableRow(
    decoration: BoxDecoration(color: Colors.grey[300]),
    children: const [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Sl No',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Order Id',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Order Time',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Total Amount',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Status',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

// Order Table Row
TableRow buildOrderTableRow({
  required QueryDocumentSnapshot order,
  required int index,
  required BuildContext context,
  required VoidCallback onStatusUpdated,
}) {
  final orderId = order['order_id'];
  final totalAmount = order['totalAmount'].toString();
  final timestamp = order['timestamp'] as Timestamp;
  final date =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  final formattedDateTime = DateFormat('MMM d, yyyy hh:mm a').format(date);
  final status = order['status'];
  final userId = order['userId'];
  final shippingAddresId = order['shippingAddressId'];
  final List<dynamic> products = order['products'];

  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(index.toString(), textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              showCenteredModalBottomSheet(
                  context,
                  orderId,
                  totalAmount,
                  formattedDateTime,
                  status,
                  shippingAddresId,
                  products,
                  userId);
              // getAddress(shippingAddresId, userId);
            },
            child: Text(
              orderId,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  decoration: TextDecoration.underline, color: Colors.blue),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(formattedDateTime, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(totalAmount, textAlign: TextAlign.center),
      ),

      Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
               alignment: WrapAlignment.spaceBetween,
     
              children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(status, textAlign: TextAlign.center),
            ),
            IconButton(
              onPressed: () {
                editAlert(context, orderId, status, userId, onStatusUpdated);
              },
              icon: const Padding(
                padding: EdgeInsets.only(right: 25),
                child: Icon(Icons.edit, color: Colors.blue),
              ),
            ),
          ],
            );
          },
          
          
        ),
      ),
    ],
  );
}

void showCenteredModalBottomSheet(
  BuildContext context,
  String orderId,
  String totalAmount,
  String formattedDateTime,
  String status,
  String shippingAddresId,
  List<dynamic> products,
  String userId,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {

      return BottomSheetOrderDetails(shippingAddresId: shippingAddresId,userId: userId,orderId: orderId,
      products: products,formattedDateTime: formattedDateTime,status: status,totalAmount: totalAmount,
      );
    },
  );
}



Future<Map<String, dynamic>?> getAddress(
    String shippingAddressId, String userId) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('addresses')
        .doc(shippingAddressId)
        .get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>?;
    } else {
      return null; // No address found, return null
    }
  } catch (e) {
    print('Error retrieving address: $e');
    return null;
  }
}
