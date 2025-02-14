// lib/domain/auth/interfaces/auth_service.dart



import 'package:tourist_guide/core/utils/result.dart';

import 'package:tourist_guide/domain/auth/entities/user_entity.dart';
import 'package:tourist_guide/domain/auth/models/auth_credentials.dart';
import 'package:tourist_guide/domain/auth/models/sign_up_data.dart';

abstract class IAuthService {
  Future<Result<UserEntity>> signIn(AuthCredentials credentials);
  Future<Result<UserEntity>> signUp(SignUpData signUpData);
  Future<Result<void>> signOut();
  Stream<bool> get authStateChanges;
}