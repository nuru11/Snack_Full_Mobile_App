import 'package:get/get.dart';

import '../screens/app_shell_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/product_detail_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.home, page: AppShellScreen.new),
    GetPage(name: AppRoutes.menu, page: MenuScreen.new),
    GetPage(name: AppRoutes.productDetail, page: ProductDetailScreen.new),
    GetPage(name: AppRoutes.cart, page: CartScreen.new),
    GetPage(name: AppRoutes.checkout, page: CheckoutScreen.new),
    GetPage(name: AppRoutes.profile, page: ProfileScreen.new),
  ];
}
