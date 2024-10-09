import 'package:clothing_admin_panel/views/widgets/users/user_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  static const String routName = '/users';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Users',style: Theme.of(context).textTheme.headlineSmall,),
          const SizedBox(height: 20,),
          const ListUserWidget()
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
          return TableViewUser(usersList: usersList);
        }
        return const Center(child: Text('No users'));
      },
    );
  }
}
