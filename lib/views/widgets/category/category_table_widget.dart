import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/view_model/category_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/category/edit_category_bottom_sheet.dart';
import 'package:clothing_admin_panel/views/widgets/delete_alert_widget.dart';
import 'package:clothing_admin_panel/views/widgets/edit_alert_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryTableWidget extends StatelessWidget {
  const CategoryTableWidget({super.key, required this.categoryData});
  final List<QueryDocumentSnapshot>? categoryData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(
            color: Colors.grey), // Optional: Add border for the table
        columnWidths: const {
          0: FlexColumnWidth(2), // Category Type column
          1: FlexColumnWidth(3), // Category Name column
          2: FlexColumnWidth(1), // Action buttons column
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableHeader(),
          ..._buildTableRows(context),
        ],
      ),
    );
  }

  // Method to build the table header
  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(
          color: Colors.blue), // Optional: Add header background color
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Category Type',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Category Name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Actions',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  // Method to build table rows dynamically based on the category data
  List<TableRow> _buildTableRows(BuildContext context) {
    return List.generate(categoryData!.length, (index) {
      final category = categoryData![index];
      final categoryName = category['name'];
      final categoryType = category['type'];

      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(categoryType),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(categoryName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min, // Use min size
              children: [
                Expanded(
                  // Use Expanded or Flexible
                  child: IconButton(
                    onPressed: () {
                      editAlert(category, context);
                    },
                    icon: const Icon(Icons.edit, color: Colors.green),
                  ),
                ),
                Expanded(
                  // Use Expanded or Flexible
                  child: IconButton(
                    onPressed: () {
                      deleteAlert(category, context);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  deleteAlert(QueryDocumentSnapshot<Object?> category, BuildContext context) {
    final viewModel = Provider.of<CategoryViewModel>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return DeleteAlert(onDelete: () {
            viewModel.deleteCategory(category, context);
            //Navigator.of(context).pop();
          });
        });
  }

  editAlert(QueryDocumentSnapshot<Object?> category, BuildContext context) {
    final provider = Provider.of<RadioProvider>(context, listen: false);
    provider.clearSelectedValue();
    showDialog(
        context: context,
        builder: (context) {
          return EditAlert(onEdit: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return EditCategoryBottomSheet(categoryDetails: category);
                });
          });
        });
  }
}
