import 'package:clothing_admin_panel/views/screens/sidebar_screens/banner_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/catogories_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/dashboard_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/orders_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/add_products_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/product_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenProvider extends ChangeNotifier {
  Widget _selectedItem = const DashBoardScreen();

  Widget get selectedItem => _selectedItem;

  void setSelectedItem(String route) {
    switch (route) {
      case DashBoardScreen.routName:
        _selectedItem = const DashBoardScreen();
        break;
      case CatogoriesScreen.routName:
        _selectedItem = CatogoriesScreen();
        break;
      case OrdersScreen.routName:
        _selectedItem = const OrdersScreen();
        break;
      case AddProductsScreen.routName:
        _selectedItem = const AddProductsScreen();
        break;
      case UsersScreen.routName:
        _selectedItem = const UsersScreen();
        break;
      case BannerScreen.routName:
        _selectedItem = BannerScreen();
        break; 
       case ProductScreen.routName:
        _selectedItem = const ProductScreen();
        break;    
    }
    notifyListeners();
  }
}
