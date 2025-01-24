// custom_snack_bar_state.dart
import 'package:meta/meta.dart';

@immutable
abstract class CustomTextFieldState {}

class CustomTextFieldInitial extends CustomTextFieldState {}

class TextFieldValidationState extends CustomTextFieldState {
  final String? errorMessage;
  final bool obscureText;
  final bool showError;
  final Map<String, bool>? passwordRequirements;

  TextFieldValidationState({
    this.errorMessage,
    this.obscureText = true,
    this.passwordRequirements,
    this.showError = false,
  });
}
