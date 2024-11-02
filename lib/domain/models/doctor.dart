import 'package:flutter/foundation.dart';

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'isActive': isActive,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      isActive: json['isActive'] ?? true,
    );
  }
}
