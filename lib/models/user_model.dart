// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String firstname;
  final String username;
  final String email;

  UserModel({
    required this.firstname,
    required this.username,
    required this.email,
  });

  UserModel copyWith({String? firstname, String? username, String? email}) {
    return UserModel(
      firstname: firstname ?? this.firstname,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstname': firstname,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      firstname: map['firstname'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }
}
