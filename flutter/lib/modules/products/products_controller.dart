import 'package:get/get.dart';

import '../../data/models/product.dart';
import '../../data/services/product_api.dart';

class ProductsController extends GetxController {
  ProductsController(this._api);

  final ProductApi _api;

  final products = <Product>[].obs;
  final selectedCategory = 'food'.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  List<Product> get filteredProducts =>
      products.where((p) => p.category == selectedCategory.value).toList();

      

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final list = await _api.fetchProducts();
      products.assignAll(list);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }
}
