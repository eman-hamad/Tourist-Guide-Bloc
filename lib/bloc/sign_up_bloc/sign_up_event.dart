// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpEvent {}

class RegiesterEvent extends SignUpEvent {
  String email;
  String phone;
  String name;
  String password;
  RegiesterEvent({
    required this.email,
    required this.phone,
    required this.name,
    required this.password,
  });
}
