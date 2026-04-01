// enum Availability {
//   available,
//   unavailable,
// }

// class Product {
//   final int id;
//   final String name;
//   final String description;
//   final double price;
//   final Availability isAvailable;
//   final String imageUrl;
//   final DateTime createdAt;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.isAvailable,
//     required this.imageUrl,
//     required this.createdAt,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       price: double.parse(json['price'].toString()),
//       imageUrl: json['image_url'],
//       isAvailable:
//           json['is_available'] == 1
//               ? Availability.available
//               : Availability.unavailable,
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }