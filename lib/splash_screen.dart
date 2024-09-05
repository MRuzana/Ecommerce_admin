import 'package:clothing_admin_panel/views/screens/main_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1),(){
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const MainScreen()));
    });
    return Scaffold(
       body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            width: 60,
            height: 60,
          
              'lib/assets/images/logo.png'
            ),
        ),
    );
  }
}