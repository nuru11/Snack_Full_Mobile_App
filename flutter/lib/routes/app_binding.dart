import 'package:get/get.dart';

import '../data/services/product_api.dart';
import '../modules/cart/cart_controller.dart';
import '../modules/products/products_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductApi>(ProductApi(), permanent: true);
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<ProductsController>(
      ProductsController(Get.find<ProductApi>()),
      permanent: true,
    );
  }
}
