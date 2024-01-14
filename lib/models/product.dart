class Product {
  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.image = '',
  });

  String id;
  String name;
  String description;
  int price;
  String image;

  
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '', 
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toInt(),
      image: map['image'] ?? '',
    );
  }
}
