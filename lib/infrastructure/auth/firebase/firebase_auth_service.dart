// lib/infrastructure/auth/firebase/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourist_guide/domain/auth/entities/user_entity.dart';

import '../../../core/utils/result.dart';
import '../../../domain/auth/interfaces/auth_service.dart';
import '../../../domain/auth/interfaces/user_repository.dart';
import '../../../domain/auth/models/auth_credentials.dart';
import '../../../domain/auth/models/sign_up_data.dart';


class FirebaseAuthService implements IAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService({required IUserRepository userRepository}) {
    _instance._userRepository = userRepository;
    return _instance;
  }

  final FirebaseAuth _auth;
  late final IUserRepository _userRepository;

  FirebaseAuthService._internal() : _auth = FirebaseAuth.instance;

  @override
  Stream<bool> get authStateChanges =>
      _auth.authStateChanges().map((user) => user != null);

  @override
  Future<Result<UserEntity>> signIn(AuthCredentials credentials) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: credentials.email.trim(),
        password: credentials.password,
      );

      if (userCredential.user != null) {
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('Authentication failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<UserEntity>> signUp(SignUpData signUpData) async {
    try {
      // Check if name is taken
      final nameResult = await _userRepository.isNameTaken(signUpData.name);
      if (nameResult.isSuccess && nameResult.data!) {
        return Result.failure('This name is already taken');
      }

      // Check if phone is taken (if provided)
      if (signUpData.phone != null) {
        final phoneResult = await _userRepository.isPhoneTaken(signUpData.phone!);
        if (phoneResult.isSuccess && phoneResult.data!) {
          return Result.failure('This phone number is already registered');
        }
      }

      // Create Firebase auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: signUpData.email.trim(),
        password: signUpData.password,
      );

      if (userCredential.user != null) {
        // Create user in Firestore
        await _userRepository.createUser(signUpData, userCredential.user!.uid);

        // Get created user
        final userResult = await _userRepository.getUserById(userCredential.user!.uid);
        if (userResult.isSuccess && userResult.data != null) {
          return Result.success(userResult.data!);
        }
      }
      return Result.failure('User creation failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Result.failure(_mapFirebaseAuthError(e));
    } catch (e) {
      return Result.failure('An unexpected error occurred');
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _auth.signOut();
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to sign out');
    }
  }

  String _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'The password provided is too weak';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}