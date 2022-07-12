import 'dart:convert';

import 'package:fake_store/models/api_response.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  Future<APIResponse> getToken(String username, String password) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {"username": username, "password": password},
    ).then((data) {
      final jsonData = json.decode(data.body);
      return APIResponse(data: jsonData);
    });
  }

  Future<APIResponse<List<Product>>> getAllProducts() {
    return http.get(Uri.parse('$baseUrl/products')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final products = <Product>[];

        for (var item in jsonData) {
          products.add(Product.fromJson(item));
        }

        return APIResponse<List<Product>>(data: products);
      }
      return APIResponse<List<Product>>(
          error: true, errorMessage: 'An error occurred');
    });
  }
}
