part of 'custom_text_field_bloc.dart';



abstract class CustomFormFieldState {}

class FormFieldInitial extends CustomFormFieldState {}

class FormFieldValidationState extends CustomFormFieldState {
  final String? errorMessage;
  final bool obscureText;
  final Map<String, bool>? passwordRequirements;
  final bool showError;
  final bool isValid;

  FormFieldValidationState({
    this.errorMessage,
    this.obscureText = true,
    this.passwordRequirements,
    this.showError = false,
    this.isValid = false,
  });
}