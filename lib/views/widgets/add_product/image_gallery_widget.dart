import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:flutter/material.dart';


class ImageGalleryWidget extends StatelessWidget {
  const ImageGalleryWidget({
    super.key,
    required this.productImageProvider,
    this.imageList,
  });

  final ProductImageProvider productImageProvider;
  final List<String>? imageList;

  @override
  Widget build(BuildContext context) {
    final imagesToDisplay = imageList ?? productImageProvider.imageUrls;

    return SizedBox(
      height: 60, // Adjust height as needed for visibility
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: imagesToDisplay.length,
        itemBuilder: (context, index) {
          final image = imagesToDisplay[index];

          return Stack(  // Use Stack for positioning
            children: [
              GestureDetector(
                onTap: () {
                  productImageProvider.selectImage(image);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),
              Positioned(
                // Position close button in top right corner
                top: -12 , // Adjust padding as needed
                right: -4 ,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red,size: 12 ,),
                  onPressed: () {
                   
                    productImageProvider.removeImage(image);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}







