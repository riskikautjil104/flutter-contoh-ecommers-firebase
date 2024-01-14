import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// kita gunakan Sql Lite untuk membuat database

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');

    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

// funcion untuk membuat database
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE product (
        id INTEGER PRIMARY KEY,
        name TEXT,
        price INTEGER,
        description TEXT,
        image TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE cart(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productId INTEGER,
    createdAt TEXT,
    updatedAt TEXT,
    FOREIGN KEY(productId) REFERENCES product(id)
  )
    ''');
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    // final db = await database;
    // return db.query('cart');
    final db = await database;
    return db.rawQuery('''
      SELECT cart.id, cart.productId, product.name, product.description, product.price, product.image
      FROM cart
      INNER JOIN product ON cart.productId = product.id
    ''');
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    Database db = await database;
    return await db.insert('product', product);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    Database db = await database;
    return await db.query('product');
  }

  Future<void> addToCart(int productId) async {
    final db = await database;

    // Optional: Check if the product is already in the cart
    final existingCartItem = await db.query(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    if (existingCartItem.isEmpty) {
      // Product is not in the cart, add it
      await db.insert('cart', {'productId': productId});
    } else {
      // Product is already in the cart, you may want to show a message or handle it accordingly
      print('Product is already in the cart');
    }
  }

  Future<void> deleteProduct(var productID) async {
    final db = await database;
    await db.delete('product', where: 'id = ?', whereArgs: [productID]);
  }

  Future<int> deleteCartItem(int cartItemId) async {
    final db = await database;
    return db.delete('cart', where: 'id = ?', whereArgs: [cartItemId]);
  }
  // Add other CRUD operations as needed
}
