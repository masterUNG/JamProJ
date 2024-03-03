// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class RiskModel {
  final String cid;
  final String inform_name;
  final String inform_key;
  final String inform_titel;
  final String inform_detail;
  final String inform_place;
  final String inform_date;
  final String fullname;
  final String status_name;
  final String inform_tel;
  final String inform_images;
  final String inform_remark;
  final String lat;
  final String lng;
  RiskModel({
    required this.cid,
    required this.inform_name,
    required this.inform_key,
    required this.inform_titel,
    required this.inform_detail,
    required this.inform_place,
    required this.inform_date,
    required this.fullname,
    required this.status_name,
    required this.inform_tel,
    required this.inform_images,
    required this.inform_remark,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cid': cid,
      'inform_name': inform_name,
      'inform_key': inform_key,
      'inform_titel': inform_titel,
      'inform_detail': inform_detail,
      'inform_place': inform_place,
      'inform_date': inform_date,
      'fullname': fullname,
      'status_name': status_name,
      'inform_tel': inform_tel,
      'inform_images': inform_images,
      'inform_remark': inform_remark,
      'lat': lat,
      'lng': lng,
    };
  }

  factory RiskModel.fromMap(Map<String, dynamic> map) {
    return RiskModel(
      cid: (map['cid'] ?? '') as String,
      inform_name: (map['inform_name'] ?? '') as String,
      inform_key: (map['inform_key'] ?? '') as String,
      inform_titel: (map['inform_titel'] ?? '') as String,
      inform_detail: (map['inform_detail'] ?? '') as String,
      inform_place: (map['inform_place'] ?? '') as String,
      inform_date: (map['inform_date'] ?? '') as String,
      fullname: (map['fullname'] ?? '') as String,
      status_name: (map['status_name'] ?? '') as String,
      inform_tel: (map['inform_tel'] ?? '') as String,
      inform_images: (map['inform_images'] ?? '') as String,
      inform_remark: (map['inform_remark'] ?? '') as String,
      lat: (map['lat'] ?? '') as String,
      lng: (map['lng'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RiskModel.fromJson(String source) => RiskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
