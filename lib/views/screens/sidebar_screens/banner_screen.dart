// ignore_for_file: must_be_immutable

import 'package:clothing_admin_panel/view_models/provider/image_picker_provider.dart';
import 'package:clothing_admin_panel/views/widgets/button_widget.dart';
import 'package:clothing_admin_panel/views/widgets/banner/gridview_banner_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatelessWidget {
  BannerScreen({super.key});

  static const String routName = '/banners';
  PlatformFile? imagefile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Banners',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 200,
                  height: 150,
                  color: const Color.fromARGB(255, 247, 245, 245),
                  child: imagePickerProvider.pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            imagePickerProvider.pickedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(),
                ),
                const SizedBox(width: 20),
                button(
                  buttonPressed: () async {
                    await Provider.of<ImagePickerProvider>(context,
                            listen: false)
                        .uploadToFireStore(context);
                  },
                  buttonText: 'Save',
                  color: Colors.blue

                ),
              ],
            ),
            const SizedBox(height: 20),
            button(
              buttonPressed: () async {
                await Provider.of<ImagePickerProvider>(context, listen: false)
                    .pickimage(context);
              },
              buttonText: 'Upload Image',
              color: Colors.blue
            ),
            const SizedBox(height: 20),
            const Divider( height: 2,color: Colors.grey,),
            const SizedBox(height: 40),           
            ListBannerWidget(firestore: _firestore),
          ],
        ),
      ),
    );
  }
}

class ListBannerWidget extends StatelessWidget {
  const ListBannerWidget({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('banners').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final bannerData = snapshot.data!.docs;
          return GridviewWidget(bannerData: bannerData);
        }
        return const Center(child: Text('No banners added'));
      },
    );
  }
}
