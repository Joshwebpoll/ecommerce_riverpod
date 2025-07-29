import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final baseUrl = 'https://buddy-chat-backend-ii8g.onrender.com/api/v1/auth';
  final storage = FlutterSecureStorage();

  Future<String> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print(data);
      final token = data['token'];
      await storage.write(key: 'token', value: token);
      //print(data['message']);
      //await _storage.write(key: 'token', value: data['token']);
      return data['message'];
    } else {
      final result = jsonDecode(res.body);

      throw (result['message'] ?? 'Login failed');
    }
  }

  Future<String> passwordReset(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/forgot_password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      //await _storage.write(key: 'token', value: data['token']);
      return data['message'];
    } else {
      final result = jsonDecode(res.body);

      throw (result['message'] ?? 'Login failed');
    }
  }

  Future<String> verifyPasswordReset(String emailCode) async {
    final res = await http.post(
      Uri.parse('$baseUrl/reset_password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"resetCode": emailCode}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      return data['message'];
    } else {
      final result = jsonDecode(res.body);

      throw (result['message'] ?? 'Something went wrong');
    }
  }

  Future<String> updateResentPassword(
    String password,
    String confirmpassword,
    String resetCode,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/password_reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "resetCode": resetCode,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      //print(data['message']);
      //await _storage.write(key: 'token', value: data['token']);
      return data['message'];
    } else {
      final result = jsonDecode(res.body);

      throw (result['message'] ?? 'Login failed');
    }
  }

  Future<String> register(
    String email,
    String name,
    String password,

    // String confirmPassword,
    // String username,
    // String phoneNumber,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    print(data);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return data['message'];
      // print(data['message']);
      //await _storage.write(key: 'token', value: data['token']);
    } else if (res.statusCode == 422) {
      final data = json.decode(res.body);

      // // throw ValidationException(errors);
      throw ('Something went wrong');
    } else {
      final result = jsonDecode(res.body);
      //return result['message'] ?? 'Registration failed';
      throw (result['message'] ?? 'Registration failed');
    }
  }

  Future<String> verifyEmail(String emailCode) async {
    final res = await http.post(
      Uri.parse('$baseUrl/verify_email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"emailCode": emailCode}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['message'];
    } else {
      final data = jsonDecode(res.body);
      throw (data['message'] ?? 'Something went wrong');
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<String?> getOnboarding() async {
    return await storage.read(key: 'hasSeenOnboarding');
  }

  Future<bool> isOnboarded() async {
    final hasSeenOnboarding = await getOnboarding();
    return hasSeenOnboarding != null;
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<bool> deleteTokens() async {
    await storage.delete(key: 'token');
    return true;
  }
}
