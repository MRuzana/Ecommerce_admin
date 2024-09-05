import 'package:clothing_admin_panel/view_models/provider/dropdown_category_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  late Future<List<String>> _categoryFuture;
  late String _categoryType;

  @override
  void initState() {
    super.initState();
    _categoryType = Provider.of<RadioProvider>(context, listen: false).selectedValue;
    _categoryFuture = _fetchCategories(_categoryType);
  }

  @override
  Widget build(BuildContext context) {
    final dropdownProvider = Provider.of<DropdownCategoryProvider>(context);
    final newCategoryType = Provider.of<RadioProvider>(context).selectedValue;

    // Update the future if the category type changes
    if (_categoryType != newCategoryType) {
      _categoryType = newCategoryType;
      _categoryFuture = _fetchCategories(_categoryType);
    }

    return FutureBuilder<List<String>>(
      future: _categoryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else {
          final categoryList = snapshot.data!;
          String dropdownValue = dropdownProvider.selectedValue.isEmpty
              ? categoryList.isNotEmpty ? categoryList.first : ''
              : dropdownProvider.selectedValue;

          // Handle cases where dropdownValue might not be in the new categoryList
          if (!categoryList.contains(dropdownValue)) {
            dropdownValue = categoryList.isNotEmpty ? categoryList.first : '';
            // Update provider value without causing rebuild issues
            WidgetsBinding.instance.addPostFrameCallback((_) {
              dropdownProvider.updateValue(dropdownValue);
            });
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Added padding
            width: double.infinity, // Changed to double.infinity for proper sizing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromARGB(255, 254, 254, 253),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true, // Allows the dropdown to take full width
                value: dropdownValue.isEmpty && categoryList.isNotEmpty
                    ? categoryList.first
                    : dropdownValue,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                onChanged: (String? value) {
                  if (value != null) {
                    dropdownProvider.updateValue(value);
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


















