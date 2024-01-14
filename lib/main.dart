import 'package:firebase_ecommers/ui/catalog/index2.dart';
import 'package:firebase_ecommers/ui/product_detail/index.dart';
// import 'package:firebase_ecommers/ui/shoping_cart/index.dart';
import 'package:firebase_ecommers/models/product.dart';
import 'package:firebase_ecommers/ui/shoping_cart/index2.dart';
import 'package:firebase_ecommers/ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_ecommers/services/databaseHelper.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StoreApp());
  // final dbHelper = DatabaseHelper();
  // // Insert a product
  // await dbHelper.insertProduct({
  //   'name': 'Product Name',
  //   'price': 19,
  //   'description': 'Product Description',
  //   'image': 'image_url.jpg',
  // });

  // // Get all products
  // List<Map<String, dynamic>> products = await dbHelper.getAllProducts();
  // print(products);
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoes Store',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/splash',
      routes: {
        '/': (context) => CatalogPage2(),
        '/splash': (context) => const SplashSreen(),
        '/shoping_cart': (context) => ShopingCartPage2(),
        '/product_detail': (context) => ProductDetailPage(
              product: ModalRoute.of(context)?.settings.arguments as Product,
            )
      },
    );
  }
}
