import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../models/product.dart';

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<List<Product>> fetchProducts() async {
    final res = await _client.get(_uri('/api/products'));
    if (res.statusCode != 200) {
      throw ProductApiException('Failed to load products (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> fetchProduct(int id) async {
    final res = await _client.get(_uri('/api/products/$id'));
    if (res.statusCode == 404) {
      throw ProductApiException('Product not found');
    }
    if (res.statusCode != 200) {
      throw ProductApiException('Failed to load product (${res.statusCode})');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}

class ProductApiException implements Exception {
  ProductApiException(this.message);
  final String message;

  @override
  String toString() => message;
}
