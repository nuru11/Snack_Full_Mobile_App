import 'package:get/get.dart';

import '../../data/models/cart_line.dart';
import '../../data/models/product.dart';

class CartController extends GetxController {
  final lines = <CartLine>[].obs;

  int get itemCount =>
      lines.fold<int>(0, (sum, line) => sum + line.quantity);

  double get total =>
      lines.fold<double>(0, (sum, line) => sum + line.lineTotal);

  void addProduct(Product product, {int quantity = 1}) {
    final idx = lines.indexWhere((l) => l.product.id == product.id);
    if (idx >= 0) {
      lines[idx].quantity += quantity;
      lines.refresh();
    } else {
      lines.add(CartLine(product: product, quantity: quantity));
    }
  }

  void setQuantity(int productId, int quantity) {
    if (quantity < 1) {
      removeProduct(productId);
      return;
    }
    final idx = lines.indexWhere((l) => l.product.id == productId);
    if (idx >= 0) {
      lines[idx].quantity = quantity;
      lines.refresh();
    }
  }

  void removeProduct(int productId) {
    lines.removeWhere((l) => l.product.id == productId);
  }

  void clear() => lines.clear();
}
