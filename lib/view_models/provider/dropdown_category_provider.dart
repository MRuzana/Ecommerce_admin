import 'package:flutter/material.dart';

class DropdownCategoryProvider extends ChangeNotifier{

 String _selectedValue = '';

  String get selectedValue => _selectedValue;

  void updateValue(String newValue) {
    if (_selectedValue != newValue) {
      _selectedValue = newValue;
      notifyListeners();
    }
  }

   void clearDropdownValue() {
    _selectedValue = '';
    notifyListeners();
  }
}