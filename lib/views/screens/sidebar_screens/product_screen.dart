import 'package:clothing_admin_panel/views/widgets/product/gridview_product_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});
    static const String routName = '/products';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('products',style: Theme.of(context).textTheme.headlineSmall,),
        const SizedBox(height: 20,),
        const ListProductWidget()
      ],
    );
  }
}


class ListProductWidget extends StatelessWidget {
  const ListProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final productData = snapshot.data!.docs;
          return GridViewProductWidget(productData: productData);
        }
        return const Center(child: Text('No products added'));
      },
    );
  }
}
