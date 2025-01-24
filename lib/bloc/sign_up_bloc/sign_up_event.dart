// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'sign_up_bloc.dart';
abstract class SignUpEvent {}

class RegiesterEvent extends SignUpEvent {
  final String email;
  final String phone;
  final String name;
  final String password;
  final String confPassword;

  RegiesterEvent({
    required this.email,
    required this.phone,
    required this.name,
    required this.password,
    required this.confPassword,
  });
}

class ValidateFieldsEvent extends SignUpEvent {
  final String email;
  final String phone;
  final String name;
  final String password;
  final String confPassword;

  ValidateFieldsEvent({
    required this.email,
    required this.phone,
    required this.name,
    required this.password,
    required this.confPassword,
  });
}
