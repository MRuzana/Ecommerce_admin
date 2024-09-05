// ignore_for_file: use_build_context_synchronously

import 'package:clothing_admin_panel/views/widgets/delete_alert_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class GridviewWidget extends StatelessWidget {
  const GridviewWidget({
    super.key,
    required this.bannerData,
  });

  final List<QueryDocumentSnapshot>? bannerData;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: bannerData!.length,
        itemBuilder: (context, index) {
          final banners = bannerData![index];
          final imageUrl = banners['image'] as String;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(border: Border.all()),
              child: Stack(fit: StackFit.expand, children: [
                Image.network(
                  banners['image'],
                  fit: BoxFit.cover,
                ),
                Positioned(
                    top: -12 ,
                    right: -10 ,
                    child: IconButton(
                        onPressed: () {
                          deleteAlert(banners,context,imageUrl);
                          
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 15,
                        )))
              ]),
            ),
          );
        });
  }

  void deleteBanner(QueryDocumentSnapshot<Object?> banners,BuildContext context, String imageUrl) async {
    final docId = banners.id;
    try {
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(docId)
          .delete();
      // Optionally, delete from Firebase Storage
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Banner deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error deleting banners: $e')));
    }
  }

  deleteAlert(QueryDocumentSnapshot<Object?> banners,BuildContext context, String imageUrl) {
  showDialog(
      context: context,
      builder: (context) {
        return DeleteAlert(onDelete: () {
         deleteBanner(banners,context,imageUrl);
          Navigator.of(context).pop();
        });
      });
}
}













