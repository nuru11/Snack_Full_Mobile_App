import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/app_colors.dart';
import '../core/api_config.dart';
import '../data/models/product.dart';
import '../modules/cart/cart_controller.dart';
import '../modules/products/products_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final Product args = Get.arguments;

  String? get _imageUrl {
    final raw = args.imageUrl;
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    final normalizedBase = ApiConfig.baseUrl.endsWith('/')
        ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
        : ApiConfig.baseUrl;
    final normalizedPath = raw.startsWith('/') ? raw : '/$raw';
    return '$normalizedBase$normalizedPath';
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final productsController = Get.find<ProductsController>();

    return Scaffold(
      body: Stack(
        children: [
          // Top image
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.44,
            width: double.infinity,
            child: _imageUrl == null
                ? Container(
                    color: AppColors.softPeach,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.fastfood_rounded,
                      size: 72,
                      color: AppColors.accent,
                    ),
                  )
                : Image.asset(
                        "assets/product_img/${args.imageUrl}",
                        fit: BoxFit.cover,
                      ),
          ),

          // Image gradient for readability
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.30),
                      Colors.transparent,
                      Colors.black.withOpacity(0.10),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.35, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Top controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: Get.back,
                  ),
                  const Spacer(),
                  _RoundIconButton(
                    icon: Icons.more_horiz_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // Timestamp chip (matches the reference vibe)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 46,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  'Today, 09:41',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                ),
              ),
            ),
          ),

          // Bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.6,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        args.description.isEmpty ? 'No description.' : args.description,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _InfoChip(
                            icon: args.category == 'drinks'
                                ? Icons.local_drink_rounded
                                : Icons.fastfood_rounded,
                            label: args.category == 'drinks' ? 'Drinks' : 'Food',
                          ),
                          _InfoChip(
                            icon: Icons.attach_money_rounded,
                            label: args.price.toStringAsFixed(2),
                          ),
                          _InfoChip(
                            icon: args.isAvailable
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            label: args.isAvailable ? 'Available' : 'Unavailable',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF22C55E),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                cart.addProduct(args, quantity: 1);
                                
                                Get.snackbar(
                                  'Added to cart',
                                  args.name,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: const Text(
                                'Add to cart',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Other items',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        final others = productsController.products
                            .where((p) =>
                                p.id != args.id &&
                                p.isAvailable)
                            .take(10)
                            .toList();

                        if (others.isEmpty) {
                          return const Text(
                            'No other items yet.',
                            style: TextStyle(color: Color(0xFF6B7280)),
                          );
                        }

                        return SizedBox(
                          height: 150,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: others.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final item = others[index];
                              return _OtherProductCard(product: item);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.86),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: const Color(0xFF111827)),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF374151)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherProductCard extends StatelessWidget {
  const _OtherProductCard({required this.product});

  final Product product;

  String? get _imageUrl {
    final raw = product.imageUrl;
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;

    final normalizedBase = ApiConfig.baseUrl.endsWith('/')
        ? ApiConfig.baseUrl.substring(0, ApiConfig.baseUrl.length - 1)
        : ApiConfig.baseUrl;
    final normalizedPath = raw.startsWith('/') ? raw : '/$raw';
    return '$normalizedBase$normalizedPath';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Material(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Get.to(
            () => ProductDetailScreen(),
            arguments: product,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: _imageUrl == null
                        ? Container(
                            color: const Color(0xFFFFE9DF),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.fastfood_rounded,
                              color: Color(0xFFE76F51),
                            ),
                          )
                        : Image.asset(
                             "assets/product_img/${product.imageUrl}",
                            fit: BoxFit.cover,
                            // errorBuilder: (_, __, ___) => Container(
                            //   color: const Color(0xFFFFE9DF),
                            //   alignment: Alignment.center,
                            //   child: const Icon(
                            //     Icons.fastfood_rounded,
                            //     color: Color(0xFFE76F51),
                            //   ),
                            // ),
                          ),
                  ),
                  // Image.asset(
                  //      ,
                  //       fit: BoxFit.cover,
                  //     ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFE76F51),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}