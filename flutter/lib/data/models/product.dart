class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.isAvailable,
  });

  final int id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;

  factory Product.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['price'];
    final price = priceRaw is num
        ? priceRaw.toDouble()
        : double.tryParse(priceRaw?.toString() ?? '') ?? 0;

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: (json['category'] as String?) ?? 'food',
      description: (json['description'] as String?) ?? '',
      price: price,
      imageUrl: json['image_url'] as String?,
      isAvailable: ((json['is_available'] as int?) ?? 1) == 1,
    );
  }
}
