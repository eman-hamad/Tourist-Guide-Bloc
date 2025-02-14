// lib/application/auth/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/auth/interfaces/auth_service.dart';
import '../../../domain/auth/interfaces/biometric_service.dart';
import '../../../domain/auth/models/auth_credentials.dart';
import '../../../domain/auth/models/sign_up_data.dart';
import 'auth_event.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthService _authService;
  final IBiometricService _biometricService;

  AuthBloc({
    required IAuthService authService,
    required IBiometricService biometricService,
  })  : _authService = authService,
        _biometricService = biometricService,
        super(AuthInitial()) {
    on<SignInRequested>(_handleSignIn);
    on<SignUpRequested>(_handleSignUp);
    on<SignOutRequested>(_handleSignOut);
    on<BiometricAuthRequested>(_handleBiometricAuth);
    on<ValidateFieldsRequested>(_handleValidateFields);
  }

  Future<void> _handleSignIn(
      SignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'Signing in...'));

    final credentials = AuthCredentials(
      email: event.email,
      password: event.password,
    );

    final result = await _authService.signIn(credentials);

    if (result.isSuccess) {
      emit(AuthSuccess(
        user: result.data!,
        message: 'Welcome back, ${result.data!.name}!',
      ));
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _handleSignUp(
      SignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (event.password != event.confirmPassword) {
      emit(AuthError('Passwords do not match'));
      return;
    }

    emit(AuthLoading(message: 'Creating your account...'));

    final signUpData = SignUpData.builder()
        .setName(event.name)
        .setEmail(event.email)
        .setPassword(event.password)
        .setPhone(event.phone)
        .build();

    final result = await _authService.signUp(signUpData);

    if (result.isSuccess) {
      emit(AuthSuccess(
        user: result.data!,
        message: 'Welcome, ${result.data!.name}!',
      ));
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _handleSignOut(
      SignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading(message: 'Signing out...'));

    final result = await _authService.signOut();

    if (result.isSuccess) {
      emit(SignOutSuccess());
    } else {
      emit(AuthError(result.error!));
    }
  }

  Future<void> _handleBiometricAuth(
      BiometricAuthRequested event,
      Emitter<AuthState> emit,
      ) async {
    final isAvailable = await _biometricService.isAvailable();
    if (!isAvailable) {
      emit(BiometricAuthError('Biometric authentication is not available'));
      return;
    }

    final isAuthenticated = await _biometricService.authenticate();
    if (isAuthenticated) {
      emit(BiometricAuthSuccess());
    } else {
      emit(BiometricAuthError('Biometric authentication failed'));
    }
  }

  void _handleValidateFields(
      ValidateFieldsRequested event,
      Emitter<AuthState> emit,
      ) {
    final List<String> emptyFields = [];

    if (event.name.trim().isEmpty) emptyFields.add('Full Name');
    if (event.email.trim().isEmpty) emptyFields.add('Email');
    if (event.password.isEmpty) emptyFields.add('Password');
    if (event.confirmPassword.isEmpty) emptyFields.add('Confirm Password');

    if (emptyFields.isNotEmpty) {
      emit(ValidationError(_getEmptyFieldsMessage(emptyFields)));
    } else {
      emit(ValidationSuccess());
    }
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    if (emptyFields.length == 1) return 'Please enter your ${emptyFields[0]}';

    String message = 'Please enter: ';
    for (int i = 0; i < emptyFields.length; i++) {
      if (i == emptyFields.length - 1) {
        message += 'and ${emptyFields[i]}';
      } else if (i == emptyFields.length - 2) {
        message += '${emptyFields[i]} ';
      } else {
        message += '${emptyFields[i]}, ';
      }
    }
    return message;
  }
}