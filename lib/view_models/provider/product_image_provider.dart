// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProductImageProvider extends ChangeNotifier {
  List<String> _imageUrls = []; // List to store image URLs
  final List<String?> _fileNames = [];
  String? _selectedImageUrl;

  Future<void> pickImages(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.image);

      if (result == null) return;

      List<String> newImageUrls = [];
      List<String?> newFileNames =
          result.files.map((file) => file.name).toList();

      for (var file in result.files) {
        final fileName = file.name;
        final fileBytes = file.bytes;

        if (fileBytes != null) {
          // Create a reference to Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('product_images')
              .child(fileName);

          // Upload the file
          await storageRef.putData(fileBytes);

          // Get the download URL
          final downloadUrl = await storageRef.getDownloadURL();
          newImageUrls.add(downloadUrl);
        }
      }

      _imageUrls.addAll(newImageUrls);
      _fileNames.addAll(newFileNames);

      if (_imageUrls.isNotEmpty) {
        _selectedImageUrl = _imageUrls[0];
      }
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.all(15),
          content: Text('Image not selected: ${e.toString()}')));
    }
  }

  String? get selectedImageUrl {
    return _selectedImageUrl;
  }

  List<String> get imageUrls => _imageUrls;
  List<String?> get fileNames => _fileNames;

  void selectImage(String imageUrl) {
    _selectedImageUrl = imageUrl;
    notifyListeners(); // Notify listeners when the selected image changes
  }

  void setImageList(List<String> urls) {
    _imageUrls = urls;
    notifyListeners();
  }

  void clearImages(){
    _selectedImageUrl = null;
    _imageUrls.clear();
    _fileNames.clear();
    notifyListeners();
  }
}










// class ProductImageProvider extends ChangeNotifier {
//  final List<dynamic> _images = [];
//  final List<String?> _fileNames = [];
//   dynamic _selectedImage;

//   Future<void> pickImages (BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform
//           .pickFiles(allowMultiple: true, type: FileType.image);

//       if (result == null) return;


//       List<dynamic> newImages = result.files.map((file) => file.bytes).toList();
//       List<String?>  newFileNames = result.files.map((file) => file.name).toList();

//       _images.addAll(newImages);
//       _fileNames.addAll(newFileNames);

//       if (_images.isNotEmpty) {
//         _selectedImage = _images[0];
//       }
//       notifyListeners();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Colors.red,
//           padding: const EdgeInsets.all(15),
//           content: Text('Image not selected${e.toString()}')));
//     }
//   }

//   dynamic get selectedImage {
//     return _selectedImage ;
//   }
//   List<dynamic> get images => _images;
//   List<String?> get fileNames => _fileNames;

  
//    void selectImage(dynamic image) {
//     _selectedImage = image;
//     notifyListeners(); // Notify listeners when the selected image changes
//   }
  
// }
