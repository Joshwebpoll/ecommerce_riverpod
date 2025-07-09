import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_ecommerce/models/category_model.dart';

class CategoryService {
  final baseUrl = "https://api.escuelajs.co";

  Future<List<Category>> fetchCategory() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/categories/'),
      headers: {'Content-Type': 'application/json'},
    );
    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //return (data as List).map((data) => UserModel.fromJson(data)).toList();

      return (data as List).map((result) => Category.fromJson(result)).toList();
    } else {
      throw (data['message']);
    }
  }
}
