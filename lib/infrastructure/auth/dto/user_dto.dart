// lib/infrastructure/auth/dto/user_dto.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/domain/auth/entities/user_entity.dart';

class UserDTO {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final List<String> favPlacesIds;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.favPlacesIds = const [],
  });

  // From Domain
  factory UserDTO.fromDomain(UserEntity user) {
    return UserDTO(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      image: user.image,
      favPlacesIds: user.favPlacesIds,
    );
  }

  // To Domain
  UserEntity toDomain() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      image: image,
      favPlacesIds: favPlacesIds,
    );
  }

  // From Firestore
  factory UserDTO.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserDTO(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      image: data['image'],
      favPlacesIds: List<String>.from(data['favPlacesIds'] ?? []),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      if (image != null) 'image': image,
      'favPlacesIds': favPlacesIds,
    };
  }
}