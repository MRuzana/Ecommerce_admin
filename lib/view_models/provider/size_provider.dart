import 'package:flutter/material.dart';

class SizeProvider extends ChangeNotifier{
  final List<String> _selectedSizes = [];

  List<String> get selectedSizes => _selectedSizes;

  void toggleSizeSelection(String size) {
    if (_selectedSizes.contains(size)) {
      _selectedSizes.remove(size);
    } else {
      _selectedSizes.add(size);
    }
    notifyListeners();
  }

  void setSelectedSizes(List<String> sizes) {
    _selectedSizes.clear();
    _selectedSizes.addAll(sizes);
    notifyListeners();
  }

  void clearSizes(){
    _selectedSizes.clear();
    notifyListeners();
  }
}