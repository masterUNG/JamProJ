// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InformriskModel {
  final String cid;
  final String inform_name;
  final String inform_key;
  final String? inform_titel;
  final String inform_detail;
  final String inform_place;
  final String? inform_date;
  final String? fullname;
  final String status_name;
  final String inform_tel;
  final String? inform_images;
  final String? inform_remark;
  final String? lat;
  final String? lng;


  
  InformriskModel({
    required this.cid,
    required this.inform_name,
    required this.inform_key,
    this.inform_titel,
    required this.inform_detail,
    required this.inform_place,
    this.inform_date,
    this.fullname,
    required this.status_name,
    required this.inform_tel,
    this.inform_images,
    this.inform_remark,
    this.lat,
    this.lng,
  });
  

  InformriskModel copyWith({
    String? cid,
    String? inform_name,
    String? inform_key,
    String? inform_titel,
    String? inform_detail,
    String? inform_place,
    String? inform_date,
    String? fullname,
    String? status_name,
    String? inform_tel,
    String? inform_images,
    String? inform_remark,
    String? lat,
    String? lng,
  }) {
    return InformriskModel(
      cid: cid ?? this.cid,
      inform_name: inform_name ?? this.inform_name,
      inform_key: inform_key ?? this.inform_key,
      inform_titel: inform_titel ?? this.inform_titel,
      inform_detail: inform_detail ?? this.inform_detail,
      inform_place: inform_place ?? this.inform_place,
      inform_date: inform_date ?? this.inform_date,
      fullname: fullname ?? this.fullname,
      status_name: status_name ?? this.status_name,
      inform_tel: inform_tel ?? this.inform_tel,
      inform_images: inform_images ?? this.inform_images,
      inform_remark: inform_remark ?? this.inform_remark,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

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

  factory InformriskModel.fromMap(Map<String, dynamic> map) {
    return InformriskModel(
      cid: map['cid'] as String,
      inform_name: map['inform_name'] as String,
      inform_key: map['inform_key'] as String,
      inform_titel: map['inform_titel'] != null ? map['inform_titel'] as String : null,
      inform_detail: map['inform_detail'] as String,
      inform_place: map['inform_place'] as String,
      inform_date: map['inform_date'] != null ? map['inform_date'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      status_name: map['status_name'] as String,
      inform_tel: map['inform_tel'] as String,
      inform_images: map['inform_images'] != null ? map['inform_images'] as String : null,
      inform_remark: map['inform_remark'] != null ? map['inform_remark'] as String : null,
      lat: map['lat'] != null ? map['lat'] as String : null,
      lng: map['lng'] != null ? map['lng'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InformriskModel.fromJson(String source) => InformriskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InformriskModel(cid: $cid, inform_name: $inform_name, inform_key: $inform_key, inform_titel: $inform_titel, inform_detail: $inform_detail, inform_place: $inform_place, inform_date: $inform_date, fullname: $fullname, status_name: $status_name, inform_tel: $inform_tel, inform_images: $inform_images, inform_remark: $inform_remark, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(covariant InformriskModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.cid == cid &&
      other.inform_name == inform_name &&
      other.inform_key == inform_key &&
      other.inform_titel == inform_titel &&
      other.inform_detail == inform_detail &&
      other.inform_place == inform_place &&
      other.inform_date == inform_date &&
      other.fullname == fullname &&
      other.status_name == status_name &&
      other.inform_tel == inform_tel &&
      other.inform_images == inform_images &&
      other.inform_remark == inform_remark &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode {
    return cid.hashCode ^
      inform_name.hashCode ^
      inform_key.hashCode ^
      inform_titel.hashCode ^
      inform_detail.hashCode ^
      inform_place.hashCode ^
      inform_date.hashCode ^
      fullname.hashCode ^
      status_name.hashCode ^
      inform_tel.hashCode ^
      inform_images.hashCode ^
      inform_remark.hashCode ^
      lat.hashCode ^
      lng.hashCode;
  }
}
