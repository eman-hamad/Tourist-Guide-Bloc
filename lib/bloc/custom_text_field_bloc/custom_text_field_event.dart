part of 'custom_text_field_bloc.dart';



abstract class CustomTextFieldEvent {}

class TextChangedEvent extends CustomTextFieldEvent {
  final String text;
  final String fieldType;

  TextChangedEvent({required this.text, required this.fieldType});
}

class TogglePasswordVisibilityEvent extends CustomTextFieldEvent {}

class UpdatePasswordEvent extends CustomTextFieldEvent {
  final String password;
  UpdatePasswordEvent(this.password);
}