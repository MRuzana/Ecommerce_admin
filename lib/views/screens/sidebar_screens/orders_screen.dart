import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
 static const String routName = '/orders';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10),
        child: Text('OrdersScreen'),
      ),
    );
  }
}