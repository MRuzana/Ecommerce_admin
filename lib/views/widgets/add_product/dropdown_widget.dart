// ignore_for_file: use_build_context_synchronously

import 'package:clothing_admin_panel/view_models/provider/dropdown_category_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  DropdownWidgetState createState() => DropdownWidgetState();
}

class DropdownWidgetState extends State<DropdownWidget> {
  late Future<List<String>> _categoryFuture;
  late String _categoryType;
  late String dropdownValue; // Add a local variable for the dropdown value

  @override
  void initState() {
    super.initState();
    _categoryType = Provider.of<RadioProvider>(context, listen: false).selectedValue;
    dropdownValue = ''; // Initialize dropdownValue
    _categoryFuture = _fetchCategories(_categoryType);
  }

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownCategoryProvider>(context);
    final newCategoryType = Provider.of<RadioProvider>(context).selectedValue;

    // Update the future and dropdownValue if the category type changes
    if (_categoryType != newCategoryType) {
      _categoryType = newCategoryType;
      _categoryFuture = _fetchCategories(_categoryType);
      dropdownValue = ''; // Reset dropdownValue when category type changes
    }

    return FutureBuilder<List<String>>(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else {
          final categoryList = snapshot.data!;

          // Use the provider value if it exists; otherwise, set to the first item
          dropdownValue = dropdownProvider.selectedValue.isNotEmpty
              ? dropdownProvider.selectedValue
              : categoryList.first;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 254, 254, 253),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                onChanged: (String? value) {
                  if (value != null) {
                    dropdownProvider.updateValue(value);
                    setState(() {
                      dropdownValue = value; // Update local dropdown value
                    });
                  }
                },
                items: categoryList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<String>> _fetchCategories(String categoryType) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await firestore
          .collection('categories')
          .where('type', isEqualTo: categoryType)
          .get();
      List<String> categoryList =
          snapshot.docs.map((doc) => doc['name'] as String).toList();

      return categoryList;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error fetching categories: $e')));
      return [];
    }
  }
}

















