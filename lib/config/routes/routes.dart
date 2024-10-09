import 'package:clothing_admin_panel/splash_screen.dart';
import 'package:clothing_admin_panel/views/screens/edit_product.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/catogories_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/dashboard_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/orders_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/add_products_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/product_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/users_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Routes{

  static final Map<String, WidgetBuilder> routes = {
    '/splash':(context) => const SplashScreen(),
    '/dashboard':(context) => const DashBoardScreen(),
    '/users': (context) => const UsersScreen(),
    '/categories':(context) => CatogoriesScreen(),
    '/add_products':(context) => const AddProductsScreen(),
    '/orders':(context) => const OrdersScreen(),
    '/products':(context) => const ProductScreen(),

    '/edit_products':(context){
      final product = ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot<Object?>;
      return EditProductsScreen(productDetails: product);
    } 
  };
}