import 'package:firebase_ecommers/services/databaseHelper.dart';

class ProductController {
  final dbHelper = DatabaseHelper();
  // Insert a product
  void insertProduct() async {
    await dbHelper.insertProduct({
      'name': 'Product Name',
      'price': 19.9,
      'description': 'Product Description',
      'image': 'image_url.jpg',
    });
  }

  void getProduct() async {
    // Get all products
    List<Map<String, dynamic>> products = await dbHelper.getAllProducts();
    print(products);
  }

  
}
