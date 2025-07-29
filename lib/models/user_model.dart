// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String name;

  final String email;

  UserModel({required this.name, required this.email});

  UserModel copyWith({String? name, String? email}) {
    return UserModel(name: name ?? this.name, email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'email': email};
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,

      email: map['email'] as String,
    );
  }
}
