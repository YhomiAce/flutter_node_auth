import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String email;
  final String name;
  final String token;
  final String password;
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    print(map);
    return User(
      id: map['data']['user']['_id'] as String,
      email: map['data']['user']['email'] as String,
      name: map['data']['user']['name'] as String,
      token: map['data']['token'] as String,
      password: map['data']['user']['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
