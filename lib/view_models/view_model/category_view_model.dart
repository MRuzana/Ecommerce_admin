// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryViewModel extends ChangeNotifier {

  void saveCatogory(
      BuildContext context, String catogoryName, String selectedType) async {
    if (catogoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please enter catogory name')));
    }
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection('categories');
      await ref.add({'name': catogoryName, 'type': selectedType});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Category uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to save category: $e')));
    }
  }

  void deleteCategory(
    QueryDocumentSnapshot<Object?> category,
    BuildContext context, // Pass context as an argument
  ) async {
  final docId = category.id;

  try {
    final QuerySnapshot productsInCategory = await FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: docId)
        .get();

    if (productsInCategory.docs.isNotEmpty) {
      // If there are products in the category, show a warning message and do not delete
      ScaffoldMessenger.of(context).showSnackBar( // Access context here
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Cannot delete category : Products exist in this category!'),
        ),
      );
      return; // Exit the function without deleting the category
    }

    // Proceed to delete the category if no products are found
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar( 
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Category deleted successfully!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar( 
      SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error deleting category: $e')));
  } finally {
    Navigator.of(context).pop(); // Close the dialog after deletion (optional)
  }
}

  void editCategory(BuildContext context, String categoryController,
      String selectedType, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update({'name': categoryController, 'type': selectedType});

        // Find products with the corresponding category and update them
    final productQuerySnapshot = await FirebaseFirestore.instance
        .collection('products') 
        .where('categoryId', isEqualTo: docId) 
        .get();    

     // Use a batch to update all products under this category
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var productDoc in productQuerySnapshot.docs) {
      // Assuming products have 'categoryName' and 'categoryType' fields that need updating
      batch.update(productDoc.reference, {
        'categoryName': categoryController,
        'categoryType': selectedType,
      });
    }

    // Commit the batch update
    await batch.commit();  

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Category updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error deleting category: $e')));
    }
  }
}

