class Product {
  final int id;
  final String name;
  final String description;
  final String tagline;
  final double price;
  final String image;
  final double rating;
  final int category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.tagline,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      tagline: json['tagline'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: (json['image'] as String?) ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      category: json['category'] ?? 0, // expect int
    );
  }
}