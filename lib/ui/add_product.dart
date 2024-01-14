import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsertProductPage extends StatefulWidget {
  
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _insertProduct(context);
                },
                child: Text('Insert Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _insertProduct(BuildContext context) async {
    String name = nameController.text;
    String image = imageController.text;
    // dynamic price = int.parse(priceController.text);
    
    try {
      if (name.isNotEmpty && image.isNotEmpty) {
           CollectionReference products = FirebaseFirestore.instance.collection('product');
        // Kirim data ke Firestore
          DocumentReference newProductRef = await products.add({
            
          'name': name,
          'price': int.parse(priceController.text),
          'description': descriptionController.text,
          'image': image,
        }
        );
         String newProductId = newProductRef.id;

        // Tampilkan pesan sukses dan kembali ke halaman Admin
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('add berhasil ditambahkan!'),
          ),
        );
        Navigator.pop(context);
      } else {
        // Tampilkan pesan error jika ada data yang belum diisi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('nama atau image harus diisi!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle the exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inserting product. Please enter a valid price.'),
          backgroundColor: Colors.tealAccent.shade700,
          duration: Duration(seconds: 1),
        ),
      );
    }

    // try {
    //   await FirebaseFirestore.instance.collection('products').add({
    //     'name': nameController.text,
    //     'price': int.parse(priceController.text),
    //     'description': descriptionController.text,
    //     'image': imageController.text,
    //   });

    //   // Optional: Show a success message or navigate to another page
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Product inserted successfully',
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       backgroundColor: Colors.tealAccent.shade700,
    //       duration: Duration(seconds: 1),
    //     ),
    //   );
    //   setState(() {});
    //   Navigator.pop(context); // Pop the current screen
    // } catch (e) {
    //   // Handle the exception
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Error inserting product. Please enter a valid price.'),
    //       backgroundColor: Colors.tealAccent.shade700,
    //       duration: Duration(seconds: 1),
    //     ),
    //   );
    // }
  }
}
