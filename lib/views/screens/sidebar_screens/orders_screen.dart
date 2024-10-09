import 'package:clothing_admin_panel/views/widgets/order/order_tableview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class OrdersScreen extends StatelessWidget {
 static const String routName = '/orders';
  const OrdersScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Orders',style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 20,),
          const ListUserWidget(),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}


class ListUserWidget extends StatelessWidget {
  const ListUserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('users').snapshots(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final usersList = snapshot.data!.docs;
         // return TableViewOrder(usersList: usersList);
          return FutureBuilder<List<int>>(
            future: _getOrderCounts(usersList), 
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                return UserTableView(
                  usersList: usersList,
                  orderCounts: snapshot.data!,
                );
              }
              return const Center(child: Text('No users found'));
            })
          );
        }
        return const Center(child: Text('No users'));
      },
    );
  }

   Future<List<int>> _getOrderCounts(List<QueryDocumentSnapshot> usersList) async {
    final firestore = FirebaseFirestore.instance;
    List<int> orderCounts = [];

    for (var user in usersList) {
      final orderSnapshot = await firestore
          .collection('users')
          .doc(user.id)
          .collection('orders')
          .get();
      orderCounts.add(orderSnapshot.docs.length);
    }

    return orderCounts;
  }

}

























