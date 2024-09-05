import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:flutter/material.dart';

class ImageGalleryWidget extends StatelessWidget {
  const ImageGalleryWidget({
    super.key,
    required this.productImageProvider,
    this.imageList
  });

  final ProductImageProvider productImageProvider;
  final List<String>? imageList;

  @override
  Widget build(BuildContext context) {

    final imagesToDisplay = imageList ?? productImageProvider.imageUrls;    
    
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagesToDisplay.length, // Use the selected list for item count
        itemBuilder: (context, index) {
          final image = imagesToDisplay[index];
          return GestureDetector(
            onTap: () {
              productImageProvider.selectImage(image);
            },
            child: SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}