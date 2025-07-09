import 'dart:convert';

import 'package:riverpod_ecommerce/models/category_model.dart';
import 'package:riverpod_ecommerce/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final baseUrl = "https://api.escuelajs.co";
  Future<List<Product>> fetchProduct() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/products/'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //return (data as List).map((data) => UserModel.fromJson(data)).toList();
      print(data);
      return (data as List).map((result) => Product.fromJson(result)).toList();
    } else {
      throw (data['message']);
    }
  }

  Future<List<Category>> fetchCategory() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/categories/'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //return (data as List).map((data) => UserModel.fromJson(data)).toList();
      print(data);
      return (data as List).map((result) => Category.fromJson(result)).toList();
    } else {
      throw (data['message']);
    }
  }
}
