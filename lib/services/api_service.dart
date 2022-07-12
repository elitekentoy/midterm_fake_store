import 'dart:convert';

import 'package:fake_store/models/api_response.dart';
import 'package:fake_store/models/cart.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const headers = {'Content-type': 'application/json'};

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
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final personCart = Cart.fromJson(jsonData);

        return APIResponse<Cart>(data: personCart);
      }
      return APIResponse<Cart>(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<void> deleteCart(int id) {
    return http.delete(Uri.parse('$baseUrl/carts/$id')).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print(jsonData);

        print('Product ID $id has been successfully deleted');
      }
    });
  }

  Future<void> updateCart(int cartId, int productId) async {
    APIResponse<Cart> oldCart = await getCart(cartId);
    APIResponse<Product> newProduct = await getSingleProduct(productId);

    print('Before adding...');
    Cart randomCart = oldCart.data!;
    print(json.encode(randomCart));

    bool isExisting = false;

    Cart newCart = oldCart.data!;
    for (var eachItem in newCart.products!) {
      if (eachItem['productId'] == productId + 1) {
        int thisIndex = newCart.products!.indexOf(eachItem);
        newCart.products![thisIndex]['quantity'] =
            newCart.products![thisIndex]['quantity'] + 1;
        isExisting = true;
        break;
      }
    }
    if (isExisting == false) {
      newCart.products!.add({'productId': newProduct.data!.id, 'quantity': 1});
    }

    newCart.date = DateTime.now();

    return http
        .patch(
      Uri.parse('$baseUrl/carts/$cartId '),
      body: json.encode(newCart.toJson()),
      headers: headers,
    )
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        print('After adding...');
        print(jsonData);

        print(
          'Product ID ${productId + 1} has been successfully added to the cart',
        );
      }
    });
  }
}
