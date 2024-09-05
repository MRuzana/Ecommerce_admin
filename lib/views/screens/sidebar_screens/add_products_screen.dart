// ignore_for_file: must_be_immutable

import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:clothing_admin_panel/utils/validator.dart';
import 'package:clothing_admin_panel/view_models/view_model/product_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/custom_textfield.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/dropdown_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/image_gallery_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/product_image_preview_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/size_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductsScreen extends StatelessWidget {
  AddProductsScreen({super.key});
  static const String routName = '/add_products';

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStockController = TextEditingController();
  
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final productImageProvider = Provider.of<ProductImageProvider>(context);
     final viewModel  = Provider.of<ProductViewModel>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromARGB(255, 240, 238, 238),
                          ),
                          height: 525 ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                const Text('General Information', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10,),
                                Text('Product Name', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productNameController,
                                 // height: 40,
                                  width: double.infinity,
                                  validator: (value) => Validator.validateProductName(value),
                                ),
                                const SizedBox(height: 10,),
                                Text('Product Description', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productDescriptionController,
                                  width: double.infinity,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  validator: (value) => Validator.validateProductDescription(value),
                                ),
                                const SizedBox(height: 10,),
                                Text('Size', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 10),
                                SizeWidget(),
                                const SizedBox(height: 25,),
                                const Text('Pricing and Stock', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Text('Price', style: Theme.of(context).textTheme.bodySmall),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 280),
                                      child: Text('Stock', style: Theme.of(context).textTheme.bodySmall),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextField(
                                      controller: productPriceController,
                                     // height: 40,
                                      width: 250,
                                      validator: (value) => Validator.validatePrice(value),
                                    ),
                                    CustomTextField(
                                      controller: productStockController,
                                     // height: 40,
                                      width: 250,
                                      validator: (value) => Validator.validateStock(value),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 240, 238, 238),
                          ),
                          height: 525 ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                const Text('Upload Image', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                ProductImagePreviewWidget(productImageProvider: productImageProvider),
                                const SizedBox(height: 53 ,),
                                ImageGalleryWidget(productImageProvider: productImageProvider),
                                const SizedBox(height: 30,),
                                const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10,),
                                Text('Product category', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 10,),
                                const DropdownWidget()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate() && productImageProvider.selectedImageUrl!= null) {
                          viewModel.uploadProduct(
                            context: context,
                            productName: productNameController.text.trim(),
                            productDescription: productDescriptionController.text.trim(),
                            price: productPriceController.text.trim(),
                            stock: productStockController.text.trim()
                          );
                          productNameController.clear();
                          productDescriptionController.clear();
                          productPriceController.clear();
                          productStockController.clear();
                          
                        }
                        else{
                          if(productImageProvider.selectedImageUrl ==null){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Please select image')));
                          }
                        }
                      },
                      child: const Text(' ✔️ ADD PRODUCT', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}




































