import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommers/models/product.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<void> _addToCart(BuildContext context, Product product) async {
    try {
      // Menambahkan produk ke koleksi 'shoppingCart' di Firestore
      await FirebaseFirestore.instance.collection('shoppingCart').add({
        'name': product.name,
        'image': product.image,
        'price': product.price,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product added to cart',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.tealAccent.shade700,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
        title: const Text('Product Details'),
      ),
      body: ListView(
        children: [
          Image.network(
              widget.product.image ??
                  '', // Jangan lupa menambahkan fallback untuk null
              fit: BoxFit.cover,
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                // Jika terjadi kesalahan (misalnya link tidak valid),
                // tampilkan gambar default dari Unsplash
                return Image.network(
                  'https://images.unsplash.com/photo-1628155930542-3c7a64e2c833?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  fit: BoxFit.cover,
                );
              },
            ),
          ListTile(
            title: Text(
              'Rp${widget.product.price}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                });
                _addToCart(context, widget.product);
              },
              icon: isLiked
                  ? Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.green[300],
                    )
                  : Icon(Icons.shopping_cart_outlined),
              // icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ListTile(
            title: const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.product.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
