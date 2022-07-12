import 'dart:convert';

import 'package:fake_store/models/api_response.dart';
import 'package:http/http.dart' as http;

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
}
