// lib/application/auth/bloc/auth_states.dart



import 'package:tourist_guide/domain/auth/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final String message;

  AuthLoading({required this.message});
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  final String message;
  final bool shouldNavigate;

  AuthSuccess({
    required this.user,
    required this.message,
    this.shouldNavigate = true,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class SignOutSuccess extends AuthState {}

class BiometricAuthSuccess extends AuthState {}

class BiometricAuthError extends AuthState {
  final String message;

  BiometricAuthError(this.message);
}

class ValidationSuccess extends AuthState {}

class ValidationError extends AuthState {
  final String message;

  ValidationError(this.message);
}