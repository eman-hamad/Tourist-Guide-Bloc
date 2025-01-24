// custom_text_field_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_text_field_event.dart';
import 'custom_text_field_state.dart';

class CustomTextFieldBloc extends Bloc<CustomTextFieldEvent, CustomTextFieldState> {
  CustomTextFieldBloc() : super(CustomTextFieldInitial()) {
    on<TextChangedEvent>(_onTextChanged);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
  }
  bool _showPasswordRequirements = true;
  bool _showErrorMessage = true;
  bool _obscureText = true;
  String _password = '';
  final Map<String, bool> _passwordRequirements = {
    'Length': false,
    'Uppercase': false,
    'Lowercase': false,
    'Number': false,
    'Special': false,
  };

  void _onTextChanged(TextChangedEvent event, Emitter<CustomTextFieldState> emit) {
    String? errorMessage;
    bool showError = true;

    switch (event.fieldType) {
      case 'name':
        if (_isValidName(event.text)) {
          errorMessage = null;
          showError = false;
        } else {
          errorMessage = _getNameError(event.text);
        }
        break;
      case 'email':
        if (_isValidEmail(event.text)) {
          errorMessage = null;
          showError = false;
        } else {
          errorMessage = _getEmailError(event.text);
        }
        break;
      case 'phone':
        if (_isValidPhone(event.text)) {
          errorMessage = null;
          showError = false;
        } else {
          errorMessage = _getPhoneError(event.text);
        }
        break;
      case 'password':
        _password = event.text;
        if (_isValidPassword(event.text)) {
          errorMessage = null;
          _showPasswordRequirements = false;
          showError = false;
        } else {
          errorMessage = 'Please meet all password requirements';
          _showPasswordRequirements = true;
        }
        break;
      case 'confirmPassword':
        if (_isValidConfirmPassword(event.text)) {
          errorMessage = null;
          showError = false;
        } else {
          errorMessage = _getConfirmPasswordError(event.text);
        }
        break;
    }

    _showErrorMessage = showError;

    emit(TextFieldValidationState(
      errorMessage: _showErrorMessage ? errorMessage : null,
      obscureText: _obscureText,
      passwordRequirements: event.fieldType == 'password' && _showPasswordRequirements
          ? _passwordRequirements
          : null,
      showError: _showErrorMessage,
    ));
  }

  bool _isValidName(String value) {
    return value.isNotEmpty &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(value) &&
        value.length >= 3 &&
        value[0].toUpperCase() == value[0];
  }

  String? _getNameError(String value) {
    if (value.isEmpty) return 'Please enter your full name';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Name should only contain letters';
    if (value.length < 3) return 'Name should be at least 3 characters';
    if (value[0].toUpperCase() != value[0]) return 'First letter must be capitalized';
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

    _passwordRequirements['Length'] = value.length >= 8;
    _passwordRequirements['Uppercase'] = value.contains(RegExp(r'[A-Z]'));
    _passwordRequirements['Lowercase'] = value.contains(RegExp(r'[a-z]'));
    _passwordRequirements['Number'] = value.contains(RegExp(r'[0-9]'));
    _passwordRequirements['Special'] = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return _passwordRequirements.values.every((met) => met);
  }

  bool _isValidConfirmPassword(String value) {
    return value.isNotEmpty && value == _password;
  }

  String? _getConfirmPasswordError(String value) {
    if (value.isEmpty) return 'Please confirm your password';
    return 'Passwords do not match';
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibilityEvent event, Emitter<CustomTextFieldState> emit) {
    _obscureText = !_obscureText;
    emit(TextFieldValidationState(
      obscureText: _obscureText,
      passwordRequirements: _showPasswordRequirements ? _passwordRequirements : null,
      showError: _showErrorMessage,
    ));
  }

  void updatePassword(String password) {
    _password = password;
  }
}