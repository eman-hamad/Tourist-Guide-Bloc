// login_state.dart
import 'package:meta/meta.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {
  final String loadingMessage;
  LoginLoadingState({required this.loadingMessage});
}

class LoginSuccessState extends LoginState {
  final String successMessage;
  final FSUser user;
  LoginSuccessState({required this.successMessage, required this.user});
}

class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState({required this.errorMessage});
}


