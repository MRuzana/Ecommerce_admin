import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/view_model/category_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/category/edit_category_bottom_sheet.dart';
import 'package:clothing_admin_panel/views/widgets/delete_alert_widget.dart';
import 'package:clothing_admin_panel/views/widgets/edit_alert_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridViewCategoryWidget extends StatelessWidget {
  const GridViewCategoryWidget({super.key, required this.categoryData});
  final List<QueryDocumentSnapshot>? categoryData;

  @override
  Widget build(BuildContext context) {
  
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
         
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoryData!.length,
        itemBuilder: (context, index) {
          final category = categoryData![index];
          final categoryName = category['name'];
          final categoryType = category['type'];

          return Container(
            color: const Color.fromARGB(255, 251, 248, 248),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20 ,),
                    Text('Category Type : $categoryType'),
                    const SizedBox(height: 10,),
                    Text('Category Name : $categoryName'),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              editAlert(category,context);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              deleteAlert(category, context);
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                    const SizedBox(height: 20 ,),
                  ]),
            ),
          );
        });
  }

  deleteAlert(QueryDocumentSnapshot<Object?> category,BuildContext context) {
  final viewModel = Provider.of<CategoryViewModel>(context,listen: false);

  showDialog(
      context: context,
      builder: (context) {
        return DeleteAlert(onDelete: () {
          viewModel.deleteCategory(category,context);
          //Navigator.of(context).pop();
        });
      });
  }

  editAlert(QueryDocumentSnapshot<Object?> category,BuildContext context) {   
    final provider = Provider.of<RadioProvider>(context,listen: false);  
    provider.clearSelectedValue();
  showDialog(
      context: context,
      builder: (context) {
        return EditAlert(onEdit: () {
          Navigator.of(context).pop();
          showModalBottomSheet(
            context: context, 
            builder: (context){
              return EditCategoryBottomSheet(categoryDetails: category);
            }
          );             
        });
      });
  }
}
