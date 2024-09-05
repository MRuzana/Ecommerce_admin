import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double width;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({super.key, 
    required this.controller,
    required this.width,
    this.keyboardType,
    this.maxLines,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
                255, 254, 254, 253),
            contentPadding:
                const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 12.0),
            border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12),
                borderSide: BorderSide.none)),
      ),
    );
  }
}