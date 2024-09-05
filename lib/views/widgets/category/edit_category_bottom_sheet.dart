import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/view_model/category_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditCategoryBottomSheet extends StatelessWidget {
  EditCategoryBottomSheet({super.key, required this.categoryDetails});
  final QueryDocumentSnapshot categoryDetails;
  final TextEditingController categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize the categoryNameController with the category name
    categoryNameController.text = categoryDetails['name'];
    String selectedType = categoryDetails['type'];
    final viewModel = Provider.of<CategoryViewModel>(context);

    return Consumer<RadioProvider>(
      builder: (context, provider, child) {
        // Set the selectedValue in the provider if it's empty
        if (provider.selectedValue.isEmpty) {
          provider.setSelectedValue(selectedType);
        }
        String docId = categoryDetails.id;

        return ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  catogoryTitle(context),
                  const SizedBox(height: 30 ),
                  catgoryName(context, categoryNameController),
                  radioButton(
                    title: 'Men',
                    value: 'Men',
                    groupValue: provider.selectedValue,
                    onChanged: (value) {
                      provider.setSelectedValue(value!);
                    },
                  ),
                  radioButton(
                    title: 'Women',
                    value: 'Women',
                    groupValue: provider.selectedValue,
                    onChanged: (value) {
                      provider.setSelectedValue(value!);
                    },
                  ),
                  const SizedBox(height: 25),
                  button(
                    buttonText: 'UPDATE',
                    color: Colors.blue,
                    buttonPressed: () {
                      
                      viewModel.editCategory(context, categoryNameController.text, provider.selectedValue,docId);
                      categoryNameController.clear();
                     
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget catogoryTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        'Edit Category',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget catgoryName(BuildContext context, TextEditingController categoryName) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
        controller: categoryName,
        decoration: const InputDecoration(
          labelText: 'Enter Category name',
          labelStyle: TextStyle(fontSize: 12),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget radioButton({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }

   
}
















// class EditCategoryBottomSheet extends StatelessWidget {
//   EditCategoryBottomSheet({super.key,required this.categoryDetails});
//   final QueryDocumentSnapshot categoryDetails;
//   final TextEditingController categoryNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     categoryNameController.text = categoryDetails['name'];
//     String selectedType = categoryDetails['type'];
//     print('sel = $selectedType');

//     return Consumer<RadioProvider>(
//       builder: (context,provider,child){
//         if(provider.selectedValue.isEmpty){
//           provider.setSelectedValue(selectedType);
//         }
//          return ListView(
//       children:  [
//         Padding(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               catogoryTitle(context),
//               const SizedBox(height: 20),
//               catgoryName(context,categoryNameController),
//               radioButton(
//                   title: 'Men',
//                   value: 'Men',
//                   groupValue: provider.selectedValue,
//                   onChanged: (value) {
//                     Provider.of<RadioProvider>(context, listen: false)
//                         .setSelectedValue(value!);
//                   }),
//               radioButton(
//                   title: 'Women',
//                   value: 'Women',
//                   groupValue: provider.selectedValue,
//                   onChanged: (value) {
//                     Provider.of<RadioProvider>(context, listen: false)
//                         .setSelectedValue(value!);
//                   }),
//               const SizedBox(height: 10),   
//               button(buttonText: 'UPDATE',color: Colors.blue, buttonPressed: () {
//                 // viewModel.saveCatogory(context,catogoryController.text, provider.selectedValue);
//                 // catogoryController.clear();
//               }),          
          
//             ],
//           ),
//         ),

//       ],
//      );
//       }
//     );

   
//   }

//   Widget catogoryTitle(BuildContext context) {
//     return Container(
//       alignment: Alignment.topLeft,
//       child: Text(
//         'Edit Category',
//         style: Theme.of(context).textTheme.headlineSmall,
//       ),
//     );
//   }

//   Widget catgoryName(BuildContext context,TextEditingController categoryName) {
//     return SizedBox(
//       height: 45,
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: TextField(
//         controller: categoryName,
//         decoration: const InputDecoration(
//             labelText: 'Enter Catogory name',
//             labelStyle: TextStyle(fontSize: 12),
//             border: OutlineInputBorder()),
//       ),
//     );
//   }

//   Widget radioButton({
//     required String title,
//     required String value,
//     required String groupValue,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return ListTile(
//       title: Text(title),
//       leading: Radio<String>(
//           value: value, groupValue: groupValue, onChanged: onChanged),
//     );
//   }
  
// }



