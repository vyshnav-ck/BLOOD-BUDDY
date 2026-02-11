import 'package:cloud_firestore/cloud_firestore.dart';

class DonorModel {
  final String id;
  final String name;
  final String bloodGroup;
  final String location;
  final String phone;
  final String emergencyContact;
  final Timestamp createdAt;

  DonorModel({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.phone,
    required this.emergencyContact,
    required this.createdAt,
  });

  factory DonorModel.fromMap(String id, Map<String, dynamic> map) {
    return DonorModel(
      id: id,
      name: map['name'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      location: map['location'] ?? '',
      phone: map['phone'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}



