// lib/bloc/auth_text_field_bloc/auth_text_field_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_text_field_event.dart';
import 'auth_text_field_states.dart';

class AuthTextFieldBloc extends Bloc<AuthTextFieldEvent, AuthTextFState> {
  String _password = '';
  String _confirmPassword = '';
  final Map<String, bool> _passwordRequirements = {
    'At least 8 characters': false,
    'Contains uppercase letter': false,
    'Contains lowercase letter': false,
    'Contains number': false,
    'Contains special character': false,
  };

  AuthTextFieldBloc() : super(const AuthTextFieldInitial()) {
    on<TextChangedEvent>(_handleTextChanged);
    on<TogglePasswordVisibilityEvent>(_handleToggleVisibility);
    on<UpdatePasswordEvent>(_handleUpdatePassword);
  }

  void _handleTextChanged(
      TextChangedEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    String? errorMessage;
    bool showError = false;
    bool isValid = true;

    if (event.text.isEmpty && event.fieldType != 'phone') {
      errorMessage = 'This field is required';
      showError = true;
      isValid = false;
    } else {
      switch (event.fieldType) {
        case 'password':
          _password = event.text;
          if (event.text.isEmpty) {
            // If field is empty, reset requirements and don't show them
            _resetPasswordRequirements();
            isValid = false;
            showError = false;
            emit(AuthTextFieldValidation(
              isValid: isValid,
              obscureText: state.obscureText,
              errorMessage: errorMessage,
              showError: showError,
              passwordRequirements: null, // Set to null to hide container
            ));
          } else {
            // Update requirements first
            _updatePasswordRequirements(event.text);
            isValid = _isValidPassword(event.text);
            showError = false;

            // Check if all requirements are met
            final allRequirementsMet = _passwordRequirements.values.every((met) => met);

            emit(AuthTextFieldValidation(
              isValid: isValid,
              obscureText: state.obscureText,
              errorMessage: errorMessage,
              showError: showError,
              // Show requirements only if not all are met
              passwordRequirements: allRequirementsMet ? null : Map<String, bool>.from(_passwordRequirements),
            ));
          }
          return;

        case 'confirmPassword':
          _confirmPassword = event.text;
          if (event.text.isNotEmpty) {
            isValid = _isValidConfirmPassword(event.text);
            if (!isValid) {
              errorMessage = _getConfirmPasswordError(event.text);
              showError = true;
            }
          } else {
            isValid = false;
            showError = false;
          }
          break;

        case 'name':
          if (!_isValidName(event.text)) {
            errorMessage = _getNameError(event.text);
            showError = true;
            isValid = false;
          }
          break;

        case 'email':
          if (!_isValidEmail(event.text)) {
            errorMessage = _getEmailError(event.text);
            showError = true;
            isValid = false;
          }
          break;

        case 'phone':
          if (!_isValidPhone(event.text)) {
            errorMessage = _getPhoneError(event.text);
            showError = true;
            isValid = false;
          }
          break;
      }
    }

    emit(AuthTextFieldValidation(
      isValid: isValid,
      obscureText: state.obscureText,
      errorMessage: errorMessage,
      showError: showError,
      passwordRequirements: event.fieldType == 'password' ? Map<String, bool>.from(_passwordRequirements) : null,
    ));
  }

  void _handleToggleVisibility(
      TogglePasswordVisibilityEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    emit(AuthTextFieldValidation(
      isValid: state.isValid,
      obscureText: !state.obscureText,
      showError: state.showError,
      errorMessage: state.errorMessage,
      passwordRequirements: state.passwordRequirements != null
          ? Map<String, bool>.from(state.passwordRequirements!)
          : null,
    ));
  }

  void _handleUpdatePassword(
      UpdatePasswordEvent event,
      Emitter<AuthTextFState> emit,
      ) {
    _password = event.password;
    if (_confirmPassword.isNotEmpty) {
      final isValid = _isValidConfirmPassword(_confirmPassword);
      emit(AuthTextFieldValidation(
        isValid: isValid,
        obscureText: state.obscureText,
        errorMessage: isValid ? null : _getConfirmPasswordError(_confirmPassword),
        showError: !isValid,
        passwordRequirements: state.passwordRequirements != null
            ? Map<String, bool>.from(state.passwordRequirements!)
            : null,
      ));
    }
  }

  void _updatePasswordRequirements(String value) {
    // Create a new map to ensure state change detection
    final newRequirements = <String, bool>{
      'At least 8 characters': value.length >= 8,
      'Contains uppercase letter': value.contains(RegExp(r'[A-Z]')),
      'Contains lowercase letter': value.contains(RegExp(r'[a-z]')),
      'Contains number': value.contains(RegExp(r'[0-9]')),
      'Contains special character': value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };

    _passwordRequirements.clear();
    _passwordRequirements.addAll(newRequirements);
  }

  void _resetPasswordRequirements() {
    _passwordRequirements.updateAll((key, value) => false);
  }

  bool _isValidName(String value) {
    return value.isNotEmpty &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) &&
        value.length >= 3 &&
        value[0].toUpperCase() == value[0];
  }

  String? _getNameError(String value) {
    if (value.isEmpty) return 'Please enter your full name';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should only contain letters';
    }
    if (value.length < 3) return 'Name should be at least 3 characters';
    if (value[0].toUpperCase() != value[0]) {
      return 'First letter must be capitalized';
    }
    return null;
  }

  bool _isValidEmail(String value) {
    return value.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
  }

  String? _getEmailError(String value) {
    if (value.isEmpty) return 'Please enter your email';
    return 'Please enter a valid email address';
  }

  bool _isValidPhone(String value) {
    return value.isEmpty || RegExp(r'^[0-9]{11}$').hasMatch(value);
  }

  String? _getPhoneError(String value) {
    return 'Phone number must be exactly 11 digits';
  }

  bool _isValidPassword(String value) {
    if (value.isEmpty) return false;
    return _passwordRequirements.values.every((met) => met);
  }

  bool _isValidConfirmPassword(String value) {
    return value == _password;
  }

  String? _getConfirmPasswordError(String value) {
    return 'Passwords do not match';
  }

  void emitAuthSuccess(String message) {
    emit(AuthSuccess(message: message));
  }

  void emitAuthError(String message) {
    emit(AuthError(message: message));
  }
}