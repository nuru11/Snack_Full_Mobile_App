import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/modules/cart/cart_controller.dart';

import '../data/models/product.dart';
import '../modules/products/products_controller.dart';
import '../routes/app_routes.dart';

class MenuScreen extends GetView<ProductsController> {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const PromoBannerSlider(),
            const _AppBar(),
          const _CategoryTabs(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              final err = controller.errorMessage.value;
              if (err != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(err, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: controller.loadProducts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final list = controller.filteredProducts;
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    'No ${controller.selectedCategory.value} items yet.',
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: controller.loadProducts,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, i) {
                    final p = list[i];
                    return _FoodCard(product: p);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


//   Widget _appBar() {
//     return  Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Good afternoon',
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF111827),
//                       ),
//                     ),
                    
//                   ],
//                 ),
//               ),
//               Container(
//                 width: 46,
//                 height: 46,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color(0x14000000),
//                       blurRadius: 14,
//                       offset: Offset(0, 6),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.notifications_none_rounded),
//               ),
//            ],
//   );
// }



}


class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good afternoon',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.notifications_none_rounded),
              ),

              const SizedBox(width: 10),
              Badge(
                label: Obx(() => Text(cart.cartItems.length.toString())),
                child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
                            ),
                            child: const Icon(Icons.shopping_cart_outlined),
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                child: SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: _FoodCardImage(imageUrl: product.imageUrl),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.45,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1EB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFE76F51),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            product.category == 'drinks' ? 'Refreshing drink' : 'Popular food',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1F2937),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () =>
                              Get.toNamed(AppRoutes.productDetail, arguments: product),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: const Text('View details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE76F51),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FilledButton(
                  onPressed: () => cart.addProduct(product, quantity: 1, isFromHome: true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFE76F51),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Add to cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends GetView<ProductsController> {
  const _CategoryTabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: _CategoryTabButton(
                label: 'Food',
                icon: Icons.fastfood_rounded,
                isSelected: controller.selectedCategory.value == 'food',
                onTap: () => controller.setCategory('food'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryTabButton(
                label: 'Drinks',
                icon: Icons.local_drink_rounded,
                isSelected: controller.selectedCategory.value == 'drinks',
                onTap: () => controller.setCategory('drinks'),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  const _CategoryTabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 14,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : const Color(0xFF374151),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodCardImage extends StatelessWidget {
  const _FoodCardImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _fallback();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/product_img/${imageUrl!}",
          fit: BoxFit.cover,
          // errorBuilder: (_, __, ___) => _fallback(),
          // loadingBuilder: (context, child, progress) {
          //   if (progress == null) return child;
          //   return Container(
          //     color: const Color(0xFFFFF1EB),
          //     alignment: Alignment.center,
          //     child: const CircularProgressIndicator(),
          //   );
          // },
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0x70000000), Color(0x00000000)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFFFE9DF),
      alignment: Alignment.center,
      child: const Icon(
        Icons.fastfood_rounded,
        size: 64,
        color: Color(0xFFE76F51),
      ),
    );
  }
}

class PromoBannerSlider extends StatefulWidget {
  const PromoBannerSlider({super.key});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  static const _banners = <_PromoBannerData>[
    _PromoBannerData(
      title: 'Fresh Food Delivered',
      subtitle: 'Your restaurant favorites prepared fast and served hot.',
      chip: '20 min avg',
      icon: Icons.delivery_dining_rounded,
      startColor: Color(0xFFE76F51),
      endColor: Color(0xFFF4A261),
    ),
    _PromoBannerData(
      title: 'Lunch Specials',
      subtitle: 'Save more on our most loved meals every afternoon.',
      chip: 'Up to 15% off',
      icon: Icons.local_offer_outlined,
      startColor: Color(0xFF2A9D8F),
      endColor: Color(0xFF52B788),
    ),
    _PromoBannerData(
      title: 'Perfect For Dinner',
      subtitle: 'Comfort food, quick checkout, and reliable delivery.',
      chip: 'Chef picks',
      icon: Icons.restaurant_menu_rounded,
      startColor: Color(0xFF264653),
      endColor: Color(0xFF3A506B),
    ),
  ];

  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      if (_currentPage >= _banners.length - 1) {
        _pageController.jumpToPage(0);
        return;
      }

      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 54, 16, 18),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7FB),
      ),
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: const [
          //           Text(
          //             'Good afternoon',
          //             style: TextStyle(
          //               fontSize: 26,
          //               fontWeight: FontWeight.w800,
          //               color: Color(0xFF111827),
          //             ),
          //           ),
                    
          //         ],
          //       ),
          //     ),
          //     Container(
          //       width: 46,
          //       height: 46,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(14),
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Color(0x14000000),
          //             blurRadius: 14,
          //             offset: Offset(0, 6),
          //           ),
          //         ],
          //       ),
          //       child: const Icon(Icons.notifications_none_rounded),
          //     ),
          //   ],
          // ),
        
          const SizedBox(height: 18),
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = _banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [banner.startColor, banner.endColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  banner.chip,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              // const SizedBox(height: 8),
                              // Text(
                              //   banner.subtitle,
                              //   style: const TextStyle(
                              //     color: Color(0xFFF9FAFB),
                              //     height: 1.4,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            banner.icon,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_banners.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFE76F51)
                      : const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(99),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PromoBannerData {
  const _PromoBannerData({
    required this.title,
    required this.subtitle,
    required this.chip,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  final String title;
  final String subtitle;
  final String chip;
  final IconData icon;
  final Color startColor;
  final Color endColor;
}
