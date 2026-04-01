import 'product.dart';

class CartLine {
  CartLine({
    required this.product,
    required this.quantity,
  });

  final Product product;
  int quantity;

  double get lineTotal => product.price * quantity;
}
