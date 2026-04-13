import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/data/models/product.dart';
import 'package:learn_flutter/modules/products/products_controller.dart';
import '../modules/cart/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final productsController = Get.find<ProductsController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Obx(() {
            final canClear = cart.cartItems.isNotEmpty;
            return IconButton(
              tooltip: 'Clear cart',
              onPressed: canClear ? cart.clear : null,
              icon: const Icon(Icons.delete_outline_rounded),
            );
          }),
        ],
      ),
      body: Obx(() {
        final ids = cart.cartItems;
        if (ids.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 18,
                          offset: Offset(0, 8),
                          color: Color(0x11000000),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 34,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Your cart is empty',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Add items from the menu to see them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ),
                  // const SizedBox(height: 14),
                  // FilledButton(
                  //   onPressed: () => Get.back(),
                  //   child: const Text('Browse menu'),
                  // ),
                ],
              ),
            ),
          );
        }

        if (productsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = productsController.products;
        if (products.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Loading products…'),
            ),
          );
        }

        // Build cart lines from stored IDs (duplicates = quantity).
        final qtyById = <int, int>{};
        for (final raw in ids) {
          final id = int.tryParse(raw);
          if (id == null) continue;
          qtyById[id] = (qtyById[id] ?? 0) + 1;
        }

        final viewLines = <({int id, String name, double price, int qty})>[];
        qtyById.forEach((id, qty) {
          Product? product;
          for (final p in products) {
            if (p.id == id) {
              product = p;
              break;
            }
          }
          if (product == null) return;
          viewLines.add((id: id, name: product.name, price: product.price, qty: qty));
        });

        final total = viewLines.fold<double>(
          0,
          (sum, l) => sum + (l.price * l.qty),
        );

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: viewLines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final line = viewLines[index];
                    return _CartLineCard(
                      name: line.name,
                      price: line.price,
                      quantity: line.qty,
                      onMinus: () => cart.removeOne(line.id),
                      onPlus: () {
                        final product = products.firstWhere((p) => p.id == line.id);
                        cart.addProduct(product, quantity: 1, isIncrement: true);
                      },
                      onRemove: () => cart.removeProduct(line.id),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, -8),
                      color: Color(0x11000000),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ETB ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Get.snackbar(
                            'Checkout',
                            'Not implemented yet',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        child: Text(
                              'Checkout (${ids.length} items)',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({
    required this.name,
    required this.price,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  final String name;
  final double price;
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 8),
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.fastfood_rounded, color: Color(0xFF111827)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ETB ${price.toStringAsFixed(2)} • Line ETB ${(price * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Remove',
              ),
              _QtyStepper(
                quantity: quantity,
                onMinus: onMinus,
                onPlus: onPlus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(icon: Icons.remove_rounded, onTap: onMinus),
          SizedBox(
            width: 34,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
              ),
            ),
          ),
          _StepButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: const Color(0xFF111827)),
      ),
    );
  }
}
