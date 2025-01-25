// login_state.dart
import 'package:meta/meta.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {
  final String loadingMessage;

  LoginLoadingState({required this.loadingMessage});
}

class LoginSuccessState extends LoginState {
  final String successMessage;

  LoginSuccessState({required this.successMessage});
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  LoginErrorState({required this.errorMessage});
}
