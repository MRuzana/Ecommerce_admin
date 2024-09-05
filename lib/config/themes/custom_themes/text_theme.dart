import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge:
        const TextStyle().copyWith(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold),
    headlineMedium:
        const TextStyle().copyWith(fontSize: 15.0, color: Colors.black),
    headlineSmall:
        const TextStyle().copyWith(fontSize: 11.0, color: Colors.black), 

    titleLarge: const TextStyle().copyWith(fontSize: 20.0,color: Colors.white),
    titleMedium: const TextStyle().copyWith( color: Colors.white),
            
  );



  static TextTheme darkTextTheme = TextTheme(
    headlineLarge:
        const TextStyle().copyWith(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.bold),
    headlineMedium:
        const TextStyle().copyWith(fontSize: 15.0, color: Colors.white),
    headlineSmall:
        const TextStyle().copyWith(fontSize: 11.0, color: Colors.black),
  );
}