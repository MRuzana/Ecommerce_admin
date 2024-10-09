import 'package:clothing_admin_panel/views/widgets/category/category_table_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListCategoriesWidget extends StatelessWidget {
  const ListCategoriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final categoryData = snapshot.data!.docs;
          return CategoryTableWidget(categoryData: categoryData);
        }
        return const Center(child: Text('No categories added'));
      },
    );
  }
}
