import 'package:clothing_admin_panel/view_models/provider/screen_provider.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/banner_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/catogories_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/dashboard_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/orders_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/add_products_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/product_screen.dart';
import 'package:clothing_admin_panel/views/screens/sidebar_screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreenProvider>(context);
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue

      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(title: 'Dashboard',icon: Icons.dashboard,route: DashBoardScreen.routName),
          AdminMenuItem(title: 'Users',icon: Icons.group,route: UsersScreen.routName),
          AdminMenuItem(title: 'Products',icon: Icons.category,route: ProductScreen.routName),
          AdminMenuItem(title: 'Orders',icon: Icons.shopping_cart,route: OrdersScreen.routName),
          AdminMenuItem(title: 'Upload Products',icon: Icons.add,route: AddProductsScreen.routName),
          AdminMenuItem(title: 'Categories',icon: Icons.category,route: CatogoriesScreen.routName),
          AdminMenuItem(title: 'Upload Banners',icon: Icons.add,route: BannerScreen.routName),

        ], 
        selectedRoute: '',
        onSelected: (item) {
          screenProvider.setSelectedItem(item.route!);
        },
        
      ),
      body: screenProvider.selectedItem
    );
  }
}