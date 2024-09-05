import 'package:flutter/material.dart';

class RadioProvider extends ChangeNotifier{
  String _selectedValue='' ;

  String get selectedValue => _selectedValue;

  void setSelectedValue(String newValue){
    if(_selectedValue !=newValue){
      _selectedValue = newValue;
      notifyListeners();
    }
  }

   void clearSelectedValue() {
    _selectedValue = '';
    notifyListeners();
  }
}