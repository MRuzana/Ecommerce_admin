import 'package:clothing_admin_panel/utils/validator.dart';
import 'package:clothing_admin_panel/view_models/provider/dropdown_category_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/provider/size_provider.dart';
import 'package:clothing_admin_panel/view_models/view_model/product_view_model.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/dropdown_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/image_gallery_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/product_image_preview_widget.dart';
import 'package:clothing_admin_panel/views/widgets/add_product/size_widget.dart';
import 'package:clothing_admin_panel/views/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({super.key, required this.productDetails});
  final QueryDocumentSnapshot? productDetails;
  static const String routName = '/edit_products';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController productStockController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String selectedType;
  late String selectedCatName;
  late List<String> sizeList;
  late List<String>? imageList;
  late String productId;
 
  @override
  void initState() {
    super.initState();

    // Initialize form fields with the product details
    productNameController.text = widget.productDetails!['productName'];
    productDescriptionController.text = widget.productDetails!['productDescription'];
    productPriceController.text = widget.productDetails!['price'];
    productStockController.text = widget.productDetails!['stock'];
    selectedType = widget.productDetails!['categoryType'];
    selectedCatName = widget.productDetails!['categoryName'];
    sizeList = List<String>.from(widget.productDetails!['size'] ?? []);
    imageList = List<String>.from(widget.productDetails!['imagePath'] ?? []);
    productId = widget.productDetails!.id;

    // Set image list in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductImageProvider>(context, listen: false).setImageList(imageList!);
      Provider.of<DropdownCategoryProvider>(context, listen: false).updateValue(selectedCatName);
      Provider.of<SizeProvider>(context, listen: false).setSelectedSizes(sizeList);
      Provider.of<RadioProvider>(context, listen: false).setSelectedValue(selectedType);
    });
  }

  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<ProductViewModel>(context);
    final productImageProvider = Provider.of<ProductImageProvider>(context);
     bool isSmallScreen = MediaQuery.of(context).size.width < 600;

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
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                const Text('General Information',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10,),
                                Text('Product Name',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productNameController,
                                  // height: 40,
                                  width: double.infinity,
                                  validator: (value) => Validator.validateProductName(value),
                                ),
                                const SizedBox(height: 10,),
                                Text('Product Description',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productDescriptionController,
                                  width: double.infinity,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  validator: (value) => Validator.validateProductDescription(value),
                                ),
                                const SizedBox(height: 10,),
                                Text('Size',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 10),
                                const SizeWidget(),
                                const SizedBox(height: 25,),
                                const Text('Pricing and Stock',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                               const SizedBox(height: 10,),
                                Text('Price',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productPriceController,
                                  width: double.infinity,
                                  validator: (value) => Validator.validatePrice(value),
                                ),
                                const SizedBox(height: 10,),
                                Text('Stock',
                                    style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 6,),
                                CustomTextField(
                                  controller: productStockController,
                                  width: double.infinity,
                                  validator: (value) => Validator.validateStock(value),
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
                        child: Column(
                          children: [

                            isSmallScreen
                    ? Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                '✖️ CANCEL',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10), // Space between buttons
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () async {
                              await updateProduct(context, viewModel);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '✔️ UPDATE PRODUCT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                '✖️ CANCEL',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10), // Space between buttons
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () async {
                                await updateProduct(context, viewModel);
                              },
                              child: const Text(
                                '✔️ UPDATE PRODUCT',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 240, 238, 238),
                              ),
                              // height: 500 ,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text('Upload Image',style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                     ProductImagePreviewWidget(productImageProvider: productImageProvider,imageList: imageList,),
                                    // ProductImagePreviewWidget(productImageProvider: productImageProvider),
                                    const SizedBox(height: 53),
                                    ImageGalleryWidget(productImageProvider: productImageProvider,imageList: imageList,),
                                    const SizedBox(height: 30),
                                    const Text('Category',style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Product category',style: Theme.of(context).textTheme.bodySmall),
                                    const SizedBox(height: 10),
                                    const DropdownWidget(),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  Future<void> updateProduct(BuildContext context, ProductViewModel viewModel) async {
    final radioProvider = Provider.of<RadioProvider>(context,listen: false);
    final dropdownProvider = Provider.of<DropdownCategoryProvider>(context,listen: false);
    final sizeProvider = Provider.of<SizeProvider>(context,listen: false);
    final imageProvider = Provider.of<ProductImageProvider>(context,listen: false);

      // final imagesToUpload = imageProvider.selectedImageUrl != null 
      // ? [imageProvider.selectedImageUrl!] 
      // : imageProvider.imageUrls;

   //   print('inside update imagesToUpload $imagesToUpload');
    
    if (formKey.currentState!.validate() &&
      //  imageProvider.selectedImageUrl != null &&
        radioProvider.selectedValue.isNotEmpty &&
        dropdownProvider.selectedValue.isNotEmpty &&
        
        sizeProvider.selectedSizes.isNotEmpty) {
      // Call uploadProduct method and wait for completion
      await viewModel.uploadProduct(
        context: context,
        productId: productId,
        productName: productNameController.text.trim(),
        productDescription: productDescriptionController.text.trim(),
        price: productPriceController.text.trim(),
        stock: productStockController.text.trim(),
        categoryType: radioProvider.selectedValue,
        categoryName: dropdownProvider.selectedValue,
        sizes: sizeProvider.selectedSizes,
        imagesUrls: imageList!,
      );
    
      productNameController.clear();
      productDescriptionController.clear();
      productPriceController.clear();
      productStockController.clear();
    } else if (imageProvider.selectedImageUrl == null) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please select an image'),
      ));
    } else if (radioProvider.selectedValue.isEmpty) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please select category type'),
      ));
    } else if (dropdownProvider.selectedValue.isEmpty) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please select category name'),
      ));
    } else if (sizeProvider.selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please select at least one size'),
      ));
    }
  }
}
