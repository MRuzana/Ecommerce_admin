import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductImagePreviewWidget extends StatelessWidget {
  const ProductImagePreviewWidget({
    super.key,
    required this.productImageProvider,
  });

  final ProductImageProvider productImageProvider;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          height: 150 ,
          color: const Color.fromARGB(255, 254, 254, 253),   
                             
          child: productImageProvider.selectedImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:Image.network(productImageProvider.selectedImageUrl!,                      
                  fit: BoxFit.contain,
                ),
              )
            : Container(),   
        ),
        IconButton(onPressed: ()async {
          await Provider.of<ProductImageProvider>(context,listen: false).pickImages(context);
        }, icon: const Icon(Icons.add_circle_rounded))
      ],
    );
  }
}