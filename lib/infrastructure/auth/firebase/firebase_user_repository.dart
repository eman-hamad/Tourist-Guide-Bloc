// lib/infrastructure/auth/firebase/firebase_user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/domain/auth/entities/user_entity.dart';
import 'package:tourist_guide/infrastructure/auth/dto/user_dto.dart';
import '../../../domain/auth/interfaces/user_repository.dart';
import '../../../domain/auth/models/sign_up_data.dart';
import '../../../core/utils/result.dart';

class FirebaseUserRepository implements IUserRepository {
  static final FirebaseUserRepository _instance = FirebaseUserRepository._internal();

  factory FirebaseUserRepository() => _instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'Users';

  FirebaseUserRepository._internal() : _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<UserEntity?>> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return Result.success(null);

      return Result.success(UserDTO.fromFirestore(doc).toDomain());
    } catch (e) {
      return Result.failure('Failed to get user data');
    }
  }

  @override
  Future<Result<void>> createUser(SignUpData signUpData, String uid) async {
    try {
      final userDto = UserDTO(
        id: uid,
        name: signUpData.name.trim(),
        email: signUpData.email.trim(),
        phone: signUpData.phone?.trim() ?? '',
        image: '',
        favPlacesIds: [],
      );

      await _firestore
          .collection(_collection)
          .doc(uid)
          .set(userDto.toFirestore());

      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to create user');
    }
  }

  @override
  Future<Result<void>> updateUser(UserEntity user) async {
    try {
      final userDto = UserDTO.fromDomain(user);
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(userDto.toFirestore());

      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to update user');
    }
  }

  @override
  Future<Result<bool>> isNameTaken(String name) async {
    try {
      final result = await _firestore
          .collection(_collection)
          .where('name', isEqualTo: name.trim())
          .get();
      return Result.success(result.docs.isNotEmpty);
    } catch (e) {
      return Result.failure('Failed to check name availability');
    }
  }

  @override
  Future<Result<bool>> isPhoneTaken(String phone) async {
    try {
      if (phone.isEmpty) return Result.success(false);

      final result = await _firestore
          .collection(_collection)
          .where('phone', isEqualTo: phone.trim())
          .get();
      return Result.success(result.docs.isNotEmpty);
    } catch (e) {
      return Result.failure('Failed to check phone availability');
    }
  }
}