import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductImagePreviewWidget extends StatelessWidget {
  const ProductImagePreviewWidget({
    super.key,
    required this.productImageProvider,
    this.imageList,
  });

  final ProductImageProvider productImageProvider;
  final List<String>? imageList;



  @override
  Widget build(BuildContext context) {
  //  print('inside preview $imageList');
    // Get the screen width using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
 // final imagesToDisplay = imageList![0];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensure proper spacing
      children: [
        // Use Expanded to make sure the image container adjusts based on available space
        Expanded(
          child: Container(
            width: screenWidth * 0.5, // Adjust width based on screen size
            height: 150,
            color: const Color.fromARGB(255, 254, 254, 253),
            
            child: productImageProvider.selectedImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                     
                      productImageProvider.selectedImageUrl!,
                      fit: BoxFit.contain,
                    ),
                  )
                : Container()
              
          ),
        ),
        // Adjust the size of the icon button
        IconButton(
          onPressed: () async {
            await Provider.of<ProductImageProvider>(context, listen: false)
                .pickImages(context);
          },
          icon: const Icon(Icons.add_circle_rounded),
          
        ),
      ],
    );
  }
}





















