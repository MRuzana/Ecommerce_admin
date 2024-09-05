class Validator{

  static String? validateProductName(String? value){
    if(value == null || value.isEmpty){
      return 'Product name is required';
    }
    return null;
  }

  static String? validateProductDescription(String? value){
    if(value == null || value.isEmpty){
      return 'Product description is required';
    }
    return null;
  }

  static String? validatePrice(String? value){
    if(value == null || value.isEmpty){
      return 'Price is required';
    }
    final priceRegExp =  RegExp(r'^\d+(\.\d{1,2})?$');
    if(!priceRegExp.hasMatch(value)){
      return 'Invalid price';
    }
    return null;
  }

  static String? validateStock(String? value){
    final stockRegExp = RegExp(r'^\d+(\.\d{1,2})?$');
     if(value == null || value.isEmpty){
      return 'Stock is required';
    }
   if(!stockRegExp.hasMatch(value)){
      return 'Invalid stock';
    }
    return null;
  }
}