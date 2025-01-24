// custom_snack_bar_event.dart
import 'package:meta/meta.dart';

@immutable
abstract class CustomTextFieldEvent {}

class TextChangedEvent extends CustomTextFieldEvent {
  final String text;
  final String fieldType;

  TextChangedEvent({required this.text, required this.fieldType});
}

class TogglePasswordVisibilityEvent extends CustomTextFieldEvent {}
