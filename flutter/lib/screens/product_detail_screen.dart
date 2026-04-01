import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../data/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
   ProductDetailScreen({super.key});

  final Product args = Get.arguments;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(args.name)),
      body:  Center(
        child: Column(
          children: [
            Text('Product Price \$${args.price}'),
            const SizedBox(height: 16),
            Text(args.description),
            const SizedBox(height: 16),
            Image.asset("assets/product_img/${args.imageUrl}", height: 200),
          ],
        ),
      ),
    );
  }
}