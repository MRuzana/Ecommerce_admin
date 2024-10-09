import 'package:clothing_admin_panel/view_models/view_model/product_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/delete_alert_widget.dart';
import 'package:clothing_admin_panel/views/widgets/edit_alert_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TableViewProduct extends StatelessWidget {
  const TableViewProduct({super.key, required this.productData});
  final List<QueryDocumentSnapshot>? productData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(color: Colors.grey),
        columnWidths: const {
          0: FlexColumnWidth(1), // Image
          1: FlexColumnWidth(2), // Product Name
          2: FlexColumnWidth(1), // Price
          3: FlexColumnWidth(1), // category type
          4: FlexColumnWidth(1), // category name
          5: FlexColumnWidth(1), // available sizes
          6: FlexColumnWidth(1), // stock
          7: FlexColumnWidth(1), // Actions (Edit/Delete)
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // Table headers
          _buildTableHeader(),
          // Table rows for each product
          for (var product in productData!) _buildTableRow(product, context),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Colors.blue),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Image',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Product Name',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Price',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Category Type',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Category Name',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Available sizes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Stock',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Actions',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(QueryDocumentSnapshot product, BuildContext context) {
    final productName = product['productName'];
    final price = product['price'];
    final List<dynamic> imageList = product['imagePath'];
    final productId = product.id;
    final List sizes = product['size'];
    final stock = product['stock'];
    final categoryType = product['categoryType'];
    final categoryName = product['categoryName'];

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            imageList[0],height: 50,fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Icon(
                  Icons.error); // Placeholder for failed image loading
            },
          ),
          // child: Image.network(
          //   imageList[0],
          //   height: 50,
          //   fit: BoxFit.cover,
          // ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            productName,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '₹$price',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$categoryType',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$categoryName',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            sizes.join(' , '),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$stock',
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Check available width and adjust accordingly
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0, // Adjust spacing between buttons
                children: [
                  IconButton(
                    onPressed: () {
                      editAlert(product, context);
                    },
                    icon: const Icon(Icons.edit, color: Colors.green),
                    iconSize: constraints.maxWidth > 400
                        ? 24
                        : 18, // Adjust icon size based on screen width
                  ),
                  IconButton(
                    onPressed: () {
                      deleteAlert(productId, context);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    iconSize: constraints.maxWidth > 400
                        ? 24
                        : 18, // Adjust icon size based on screen width
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  deleteAlert(String productId, BuildContext context) {
    final viewModel = Provider.of<ProductViewModel>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return DeleteAlert(
          onDelete: () {
            viewModel.deleteProduct(productId, context);
          },
        );
      },
    );
  }

  editAlert(QueryDocumentSnapshot<Object?> product, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditAlert(
          onEdit: () {
            Navigator.of(context).pop();

            Navigator.pushNamed(
              context,
              '/edit_products',
              arguments: product,
            );
          },
        );
      },
    );
  }
}
