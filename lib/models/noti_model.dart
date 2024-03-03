import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotiModel {
  final String title;
  final String message;
  NotiModel({
    required this.title,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
    };
  }

  factory NotiModel.fromMap(Map<String, dynamic> map) {
    return NotiModel(
      title: (map['title'] ?? '') as String,
      message: (map['message'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotiModel.fromJson(String source) =>
      NotiModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
