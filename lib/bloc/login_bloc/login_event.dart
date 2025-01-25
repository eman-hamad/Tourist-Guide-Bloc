// login_event.dart
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}
