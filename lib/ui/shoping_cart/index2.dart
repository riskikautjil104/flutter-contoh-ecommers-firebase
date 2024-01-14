// import 'package:ecomerce/services/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopingCartPage2 extends StatefulWidget {
  @override
  _ShopingCartPage2State createState() => _ShopingCartPage2State();
}

class _ShopingCartPage2State extends State<ShopingCartPage2> {
  // final dbHelper = DatabaseHelper();

  Future<void> _addToCart(Map<String, dynamic> product) async {
    try {
      // Menambahkan produk ke koleksi 'shoppingCart' di Firestore
      await FirebaseFirestore.instance.collection('shoppingCart').add(product);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('shoppingCart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var cartItem = snapshot.data!.docs[index];
                var data = cartItem.data() as Map<String, dynamic>;

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(data['name']),
                        leading: (data['image'] == '' ||
                                data['image'] == 'image_url.jpg')
                            ? Image.asset(
                                'assets/image/shoe4.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                data['image']??
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
                        subtitle: Text(
                          'Rp${data['price']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteCartItem(cartItem.id);
                          },
                        ),
                      ),
                      const ShopingCartItemQty(),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Fungsi untuk menghapus item dari keranjang
  Future<void> _deleteCartItem(String cartItemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('shoppingCart')
          .doc(cartItemId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cart Delete successfully',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.tealAccent.shade700,
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {
        // Refresh UI setelah penghapusan
      });
    } catch (e) {
      print('Error deleting cart item: $e');
    }
  }
}

class ShopingCartItemQty extends StatefulWidget {
  const ShopingCartItemQty({
    Key? key,
  }) : super(key: key);

  @override
  State<ShopingCartItemQty> createState() => _ShopingCartItemQtyState();
}

class _ShopingCartItemQtyState extends State<ShopingCartItemQty> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            setState(() {
              if (_qty > 1) _qty--;
            });
          },
        ),
        Text('$_qty'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _qty++;
            });
          },
        ),
      ],
    );
  }
}
