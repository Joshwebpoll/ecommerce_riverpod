import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:riverpod_ecommerce/models/user_model.dart';
import 'package:riverpod_ecommerce/services/auth_service.dart';

class UserService {
  final baseUrl = 'https://ajos.cosoiit.com/api/ajo';

  Future<UserModel> getUser() async {
    final token = await AuthService().getToken();

    final res = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
    );
    final data = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //return (data as List).map((data) => UserModel.fromJson(data)).toList();

      return UserModel.fromJson(data['user']);
    } else {
      throw (data['message']);
    }
  }
}
