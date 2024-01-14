// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_ecommers/models/product.dart';
// import 'package:firebase_ecommers/services/databaseHelper.dart';
import 'package:firebase_ecommers/ui/add_product.dart';
import 'package:firebase_ecommers/ui/product_detail/index.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogProductCard2 extends StatefulWidget {
  const CatalogProductCard2({Key? key, required this.product})
      : super(key: key);

  final Product product;

  @override
  State<CatalogProductCard2> createState() => _CatalogProductCard2State();
}

class _CatalogProductCard2State extends State<CatalogProductCard2> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    Future<void> _addToCart(BuildContext context, Product product) async {
      try {
        // Menambahkan produk ke koleksi 'shoppingCart' di Firestore
        await FirebaseFirestore.instance.collection('shoppingCart').add({
          'name': product.name,
          'image': product.image,
          'price': product.price,
          // ... (Tambahkan properti lain yang diperlukan)
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

    void _deleteProduct(product) async {
      CollectionReference products =
          FirebaseFirestore.instance.collection('product');
      QuerySnapshot<Object?> newProductRef = await products.get();
      // Kiim data ke Firestore

      // InsertProductPage proid = InsertProductPage();
      try {
        if (widget.product.name.isEmpty) {
          await FirebaseFirestore.instance
              .collection('product')
              .doc(newProductRef.docs.first.id)
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Product Delete successfully',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.tealAccent.shade700,
              duration: Duration(seconds: 1),
            ),
          );
          setState(() {});
        } else {
          print('Error deleting product: Product ID is empty');
        }
      } catch (e) {
        print('Error deleting product: $e');
      }
    }

    // Menambahkan argumen product ke dalam _showDeleteConfirmation
    void _showDeleteConfirmation(Product product) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Product'),
            content: Text('Are you sure you want to delete ${product.name}?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  _deleteProduct(product.name);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

// Fungsi untuk menghapus data product

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductDetailPage(product: widget.product);
              },
            ),
          );
        },
        onLongPress: () {
          _showDeleteConfirmation(widget.product);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              widget.product.image, // Jangan lupa menambahkan fallback untuk null
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

            // Image.asset(
            //   'assets/image/shoe4.png',
            //   fit: BoxFit.cover,
            // ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.product.name}",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    "IDR ${widget.product.price}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        icon: isLiked
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red[300],
                              )
                            : Icon(Icons.favorite_outline),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _addToCart(context, widget.product);
                        },
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text('Add to Cart'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.tealAccent.shade700,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogPage2 extends StatefulWidget {
  CatalogPage2({super.key});

  @override
  State<CatalogPage2> createState() => _CatalogPage2State();
}

class _CatalogPage2State extends State<CatalogPage2> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          icon: Icon(Icons.refresh_outlined),
        ),
        centerTitle: true,
        title: const Text('Catalog'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/shoping_cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Shopping Cart',
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('product').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No products available');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var productData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return CatalogProductCard2(
                    product: Product.fromMap(productData));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent.shade700,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => InsertProductPage())));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  //  fungsi untuk melihat detail product
  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['name']),
          content: Container(
            width: 600,
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                (product['image'] == '' || product['image'] == 'image_url.jpg')
                    ? Image.asset(
                        'assets/image/shoe4.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        product['image'].toString(),
                        fit: BoxFit.cover,
                      ),
                SizedBox(height: 8.0),
                Text('Description: ${product['description']}'),
                Text('Price: IDR ${product['price']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // fungsi untuk melihat komfirmasi hapus
  void _showDeleteDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete ${product['name']}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteProduct(product);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

// fungsi unutk menghapus data product
  void _deleteProduct(Map<String, dynamic> product) async {
    try {
      await FirebaseFirestore.instance
          .collection('product')
          .doc(product['id'])
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product Delete successfully',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.tealAccent.shade700,
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {});
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  void _addToCart(Map<String, dynamic> product) async {
    try {
      // Implement your logic to add the product to the shopping cart
      // You may want to store it in a separate collection in Firestore
      // For example:
      await FirebaseFirestore.instance
          .collection('shoppingCart')
          .add({'productId': product['id']});

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

  Future<void> _showDeleteConfirmation(String cartItemId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete from Cart?'),
          content:
              Text('Are you sure you want to remove this item from your cart?'),
          actions: [
            TextButton(
              onPressed: () async {
                // await _deleteCartItem(cartItemId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  bool isValidImage(String imagePath) {
    // Implement your logic to check whether the image path is valid.
    // For example, you can check the file extension or other criteria.
    return imagePath.endsWith('.jpg') || imagePath.endsWith('.png');
  }

  bool _isValidImageUrl(String imageUrl) {
    // Implementasi validasi sederhana berdasarkan ekstensi file atau kriteria lainnya
    return imageUrl.endsWith('.jpg') ||
        imageUrl.endsWith('.jpeg') ||
        imageUrl.endsWith('.png');
  }
}
