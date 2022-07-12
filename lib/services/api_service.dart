import 'dart:convert';

import 'package:fake_store/models/api_response.dart';
import 'package:fake_store/models/cart.dart';
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

  Future<APIResponse<List<Product>>> getLimitedProducts(int numberOfProducts) {
    return http
        .get(Uri.parse('$baseUrl/products?limit=$numberOfProducts'))
        .then((data) {
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

  Future<APIResponse<Product>> getSingleProduct(int productID) {
    productID = productID + 1;
    return http.get(Uri.parse('$baseUrl/products/$productID')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final product = Product.fromJson(jsonData);

        return APIResponse<Product>(data: product);
      }
      return APIResponse<Product>(
          error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse> getAllCategories() {
    return http.get(Uri.parse('$baseUrl/products/categories')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse(data: jsonData);
      }
      return APIResponse(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<List<Product>>> getProductsByCategory(String category) {
    return http
        .get(Uri.parse('$baseUrl/products/category/$category'))
        .then((data) {
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

  Future<APIResponse<Cart>> getCart(int id) {
    return http.get(Uri.parse('$baseUrl/carts/$id')).then((data) {
      print(data.statusCode);
      print(data.body);
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);

        return APIResponse<Cart>(data: jsonData);
      }
      return APIResponse<Cart>(error: true, errorMessage: 'An error occurred');
    });
  }
}
