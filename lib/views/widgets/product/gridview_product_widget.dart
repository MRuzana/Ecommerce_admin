import 'package:clothing_admin_panel/view_models/view_model/product_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/delete_alert_widget.dart';
import 'package:clothing_admin_panel/views/widgets/edit_alert_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridViewProductWidget extends StatelessWidget {
  const GridViewProductWidget({super.key, required this.productData});
  final List<QueryDocumentSnapshot>? productData;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = getCrossAxisCount(screenWidth);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: kIsWeb ? 0.8 : 0.75, // Adjust for web and mobile
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productData!.length,
      itemBuilder: (context, index) {
        final product = productData![index];
        final productName = product['productName'];
        final price = product['price'];
        final List<dynamic> imageList = product['imagePath'];
        final productId = product.id;

        return Card(
          color: const Color.fromARGB(255, 247, 245, 245),
       
          //elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 80 ,
                  child: Image.network(imageList[0], fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        editAlert(product, context);
                      },
                      icon: const Icon(Icons.edit,color: Colors.green,),
                    ),
                    IconButton(
                      onPressed: () {
                       deleteAlert(productId, context);
                      },
                      icon: const Icon(Icons.delete,color: Colors.red,),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int getCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) {
      return 6; // 6 items per row for very large screens
    } else if (screenWidth > 900) {
      return 4; // 4 items per row for large screens
    } else if (screenWidth > 600) {
      return 3; // 3 items per row for medium screens
    } else {
      return 2; // 2 items per row for small screens
    }
  }


  deleteAlert(String productId,BuildContext context){
  final viewModel = Provider.of<ProductViewModel>(context,listen: false);

  showDialog(
      context: context,
      builder: (context) {
        return DeleteAlert(onDelete: () {
          viewModel.deleteProduct(productId,context);
        });
      });
  }

  editAlert(QueryDocumentSnapshot<Object?> product,BuildContext context) {   
  
  showDialog(
      context: context,
      builder: (context) {
        return EditAlert(onEdit: () {
          Navigator.of(context).pop();

          Navigator.pushNamed(context, '/edit_products',arguments: product);          
        });
      });
  }


}





