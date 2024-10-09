// ignore_for_file: use_build_context_synchronously

import 'package:clothing_admin_panel/view_models/provider/dropdown_category_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/provider/screen_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/size_provider.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/product_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   uploadProduct({
  required BuildContext context,
  required String productName,
  required String productDescription,
  required String price,
  required String stock,
  required String categoryType,
  required String categoryName,
  required List<String> sizes,
  required List<dynamic> imagesUrls,
  String? productId,
}) async {
  String? categoryId = await getCategoryId(categoryName);
  
  final productData = {
    'productName': productName,
    'productDescription': productDescription,
    'price': price,
    'stock': stock,
    'categoryType': categoryType,
    'categoryName': categoryName,
    'size': sizes,
    'imagePath': imagesUrls,
    'categoryId': categoryId,
    'timestamp': FieldValue.serverTimestamp(),
  };

  try {

    if (productId != null && productId.isNotEmpty) {
      // Update existing product
      await _firestore.collection('products').doc(productId).update(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product updated successfully!'),
        ),
      );

      // Delay to allow snackbar to show
     // await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();

    } else {
      // Create new product
      await _firestore.collection('products').add(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product added successfully!'),
          duration: Duration(seconds: 3),
        ),
      );
      await Future.delayed(const Duration(seconds: 3));
    }

    // Clear provider states
    clearProviderStates(context);
    notifyListeners();

    // Navigate to the product screen
    Provider.of<ScreenProvider>(context, listen: false).setSelectedItem(ProductScreen.routName);
    
  } catch (e) {
    // Show error snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text('Failed to upload product: $e'),
    ));
  }
}

  // Method to clear provider states
  void clearProviderStates(BuildContext context) {
    Provider.of<RadioProvider>(context, listen: false).clearSelectedValue();
    Provider.of<DropdownCategoryProvider>(context, listen: false)
        .clearDropdownValue();
    Provider.of<SizeProvider>(context, listen: false).clearSizes();
    Provider.of<ProductImageProvider>(context, listen: false).clearImages();
  }

  void deleteProduct(String productId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Product deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error deleting product: $e')));
    } finally {
      Navigator.of(context).pop();
    }
  }
}

Future<String?> getCategoryId(String categoryName) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('categories')
        .where('name', isEqualTo: categoryName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  } catch (e) {
    print('Error getting category ID: $e');
    return null;
  }
}

