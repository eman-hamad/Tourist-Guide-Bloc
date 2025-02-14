// lib/domain/auth/entities/user.dart

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final List<String> favPlacesIds;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.favPlacesIds = const [],
  });

  UserEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? image,
    List<String>? favPlacesIds,
  }) {
    return UserEntity(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      favPlacesIds: favPlacesIds ?? this.favPlacesIds,
    );
  }
}