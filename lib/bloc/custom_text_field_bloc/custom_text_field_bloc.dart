// custom_text_field_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';




part 'custom_text_field_event.dart';
part 'custom_text_field_state.dart';



class FormFieldBloc extends Bloc<CustomTextFieldEvent, CustomFormFieldState> {
  FormFieldBloc() : super(FormFieldInitial()) {
    on<TextChangedEvent>(_onTextChanged);
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
    on<UpdatePasswordEvent>(_onUpdatePassword);
  }
  bool _showPasswordRequirements = true;
  bool _showErrorMessage = true;
  bool _obscureText = true;
  String _password = '';
  String _confirmPassword = '';
  final Map<String, bool> _passwordRequirements = {
    'Length': false,
    'Uppercase': false,
    'Lowercase': false,
    'Number': false,
    'Special': false,
  };

  void _onTextChanged(TextChangedEvent event, Emitter<CustomFormFieldState> emit) {
    String? errorMessage;
    bool showError = true;

    if (event.text.isEmpty && event.fieldType != 'phone') {
      errorMessage = 'This field is required';
      emit(FormFieldValidationState(
        errorMessage: errorMessage,
        obscureText: _obscureText,
        showError: true,
        isValid: false,
      ));
      return;
    }

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
        _confirmPassword = event.text;
        if (_isValidConfirmPassword(event.text)) {
          errorMessage = null;
          showError = false;
        } else if (event.text.isNotEmpty) {
          errorMessage = _getConfirmPasswordError(event.text);
          showError = true;
        } else {
          showError = false;
        }
        break;
    }

    _showErrorMessage = showError;

    emit(FormFieldValidationState(
      errorMessage: _showErrorMessage ? errorMessage : null,
      obscureText: _obscureText,
      passwordRequirements: event.fieldType == 'password' && _showPasswordRequirements
          ? _passwordRequirements
          : null,
      showError: _showErrorMessage,
      isValid: !showError,
    ));
  }

  void _onTogglePasswordVisibility(
      TogglePasswordVisibilityEvent event, Emitter<CustomFormFieldState> emit) {
    _obscureText = !_obscureText;

    bool showError = false;
    String? errorMessage;

    if (_confirmPassword.isNotEmpty && !_isValidConfirmPassword(_confirmPassword)) {
      showError = true;
      errorMessage = _getConfirmPasswordError(_confirmPassword);
    }

    emit(FormFieldValidationState(
      obscureText: _obscureText,
      passwordRequirements: _showPasswordRequirements ? _passwordRequirements : null,
      showError: showError,
      errorMessage: errorMessage,
      isValid: !showError,
    ));
  }

  void _onUpdatePassword(UpdatePasswordEvent event, Emitter<CustomFormFieldState> emit) {
    _password = event.password;

    bool showError = false;
    String? errorMessage;

    if (_confirmPassword.isNotEmpty && !_isValidConfirmPassword(_confirmPassword)) {
      showError = true;
      errorMessage = _getConfirmPasswordError(_confirmPassword);
    }

    emit(FormFieldValidationState(
      errorMessage: errorMessage,
      obscureText: _obscureText,
      passwordRequirements: _showPasswordRequirements ? _passwordRequirements : null,
      showError: showError,
      isValid: !showError,
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
    return value == _password;
  }

  String? _getConfirmPasswordError(String value) {
    return 'Passwords do not match';
  }
}

