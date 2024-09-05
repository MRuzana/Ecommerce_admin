class ProductModel {
  String productName;
  String productDescription;
  String price;
  String stock;
  String categoryType;
  String categoryName;
  String categoryid;
  List<dynamic>imagePath;
  List<String>size;
  String? productId;
  

  ProductModel({
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.stock,
    required this.categoryType,
    required this.categoryName,
    required this.categoryid,
    required this.imagePath,
    required this.size,
    this.productId,
  });
}