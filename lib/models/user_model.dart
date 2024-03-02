// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class UserModel {

  final String fullname;
  final String user_key;
  final String? user_phone;
  final String user_photo;
  final String name;
  final String lastname;
  final String user_position;
  final String pos_name;
  UserModel({
    required this.fullname,
    required this.user_key,
    this.user_phone,
    required this.user_photo,
    required this.name,
    required this.lastname,
    required this.user_position,
    required this.pos_name,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'user_key': user_key,
      'user_phone': user_phone,
      'user_photo': user_photo,
      'name': name,
      'lastname': lastname,
      'user_position': user_position,
      'pos_name': pos_name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullname: (map['fullname'] ?? '') as String,
      user_key: (map['user_key'] ?? '') as String,
      user_phone: map['user_phone'] != null ? map['user_phone'] as String : null,
      user_photo: (map['user_photo'] ?? '') as String,
      name: (map['name'] ?? '') as String,
      lastname: (map['lastname'] ?? '') as String,
      user_position: (map['user_position'] ?? '') as String,
      pos_name: (map['pos_name'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
