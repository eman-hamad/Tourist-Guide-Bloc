// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';

import '../../domain/auth/interfaces/auth_service.dart';
import '../../domain/auth/interfaces/biometric_service.dart';
import '../../domain/auth/interfaces/user_repository.dart';
import '../../infrastructure/auth/biometric/local_biometric_service.dart';
import '../../infrastructure/auth/firebase/firebase_auth_service.dart';
import '../../infrastructure/auth/firebase/firebase_user_repository.dart';

class ServiceLocator {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> initialize() async {
    // First, register the repository
    _getIt.registerSingleton<IUserRepository>(
      FirebaseUserRepository(),
    );

    // Then register the auth service with the repository
    _getIt.registerSingleton<IAuthService>(
      FirebaseAuthService(userRepository: _getIt<IUserRepository>()),
    );

    // Register biometric service
    _getIt.registerSingleton<IBiometricService>(
      LocalBiometricService(),
    );

    await _getIt.allReady();
  }

  static T get<T extends Object>() => _getIt.get<T>();
}