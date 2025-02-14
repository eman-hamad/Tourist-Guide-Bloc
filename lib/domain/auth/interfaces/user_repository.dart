// lib/domain/auth/interfaces/user_repository.dart

import 'package:tourist_guide/domain/auth/entities/user_entity.dart';

import '../models/sign_up_data.dart';
import '../../../core/utils/result.dart';

abstract class IUserRepository {
  Future<Result<UserEntity?>> getUserById(String id);
  Future<Result<void>> createUser(SignUpData signUpData, String uid);
  Future<Result<void>> updateUser(UserEntity user);
  Future<Result<bool>> isNameTaken(String name);
  Future<Result<bool>> isPhoneTaken(String phone);
}