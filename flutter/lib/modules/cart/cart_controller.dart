import 'package:get/get.dart';
import 'package:learn_flutter/screens/cart_screen.dart';

import '../../data/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  // final lines = <CartLine>[].obs;
  final cartItems = <String>[].obs;

  static const _cartKey = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    getCartItems();
  }

  // int get itemCount =>
  //     lines.fold<int>(0, (sum, line) => sum + line.quantity);

  // double get total =>
  //     lines.fold<double>(0, (sum, line) => sum + line.lineTotal);

  Future<void> addProduct(Product product, {int quantity = 1, bool isIncrement = false, isFromHome = false}) async {
    // final idx = lines.indexWhere((l) => l.product.id == product.id);


    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_cartKey) ?? <String>[];

    if (stored.contains(product.id.toString()) && !isIncrement) {
      // print("${product.id} product.id is already in the cart");
      // print("isFromHome: $isFromHome");
      isFromHome ? "" : Get.to(const CartScreen());
      return;
    }
    for (var i = 0; i < quantity; i++) {
      stored.add(product.id.toString());
    }
    await prefs.setStringList(_cartKey, stored);
    cartItems.assignAll(stored);
    // print("isFromHome: $isFromHome");
    isFromHome ? "" : Get.to(const CartScreen());

    Get.snackbar(
      'Added to cart',
      product.name,
      snackPosition: SnackPosition.BOTTOM,
    );

    // final sharedPreferences = await SharedPreferences.getInstance();
    // await sharedPreferences.setString('cart_items', product.name.toString());

    
    // if (idx >= 0) {
    //   lines[idx].quantity += quantity;
    //   lines.refresh();
    // } else {
    //   lines.add(CartLine(product: product, quantity: quantity));
    // }
  }

  Future<void> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_cartKey) ?? <String>[];
    cartItems.assignAll(stored);
  }

  void setQuantity(int productId, int quantity) {
    print("${productId} productId");
    print("${quantity} quantity");
    if (quantity < 1) {
      removeProduct(productId);
      return;
    }
    // final idx = lines.indexWhere((l) => l.product.id == productId);
    // if (idx >= 0) {
    //   lines[idx].quantity = quantity;
    //   lines.refresh();
    // }
  }

  Future<void> removeProduct(int productId) async {
    // lines.removeWhere((l) => l.product.id == productId);
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_cartKey) ?? <String>[];
    stored.removeWhere((id) => id == productId.toString());
    await prefs.setStringList(_cartKey, stored);
    cartItems.assignAll(stored);
  }

  Future<void> removeOne(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_cartKey) ?? <String>[];
    final idx = stored.indexOf(productId.toString());
    if (idx >= 0) {
      stored.removeAt(idx);
      await prefs.setStringList(_cartKey, stored);
      cartItems.assignAll(stored);
    }
  }

  Future<void> clear() async {
    // lines.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    cartItems.clear();
  }
}
