import 'dart:io';

import 'package:clothing_admin_panel/config/routes/routes.dart';
import 'package:clothing_admin_panel/view_models/provider/dropdown_category_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/image_picker_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/product_image_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/radioprovider.dart';
import 'package:clothing_admin_panel/view_models/provider/screen_provider.dart';
import 'package:clothing_admin_panel/view_models/provider/size_provider.dart';
import 'package:clothing_admin_panel/splash_screen.dart';
import 'package:clothing_admin_panel/view_models/view_model/category_view_model.dart';
import 'package:clothing_admin_panel/view_models/view_model/product_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb || Platform.isAndroid ? const FirebaseOptions(
      apiKey: "AIzaSyAkCQ5meE173XJMPgAf6hGAhikU6HzlKtI",
      appId: "1:282198732334:web:3a6af5c33743df282279bf",
      messagingSenderId: "282198732334",
      projectId: "style-avenue-fb8f4",
      storageBucket: "style-avenue-fb8f4.appspot.com",
    ) : null
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScreenProvider()),
        ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
        ChangeNotifierProvider(create: (context) => RadioProvider()),
        ChangeNotifierProvider(create: (context) => SizeProvider()),
        ChangeNotifierProvider(create: (context) => ProductImageProvider()),
        ChangeNotifierProvider(create: (context) => DropdownCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CategoryViewModel()),
        ChangeNotifierProvider(create: (context) => ProductViewModel())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue
        ),
        initialRoute: '/splash',
        routes: Routes.routes,
        home: const SplashScreen(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

