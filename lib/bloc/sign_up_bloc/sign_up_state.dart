// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

part of 'sign_up_bloc.dart';

@immutable
abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {
  String loadingMessage;
  SignUpLoadingState({
    required this.loadingMessage,
  });
}

class SignUpErrorState extends SignUpStates {
  String errorMessage;
  SignUpErrorState({required this.errorMessage});
}

class SignUpSuccessState extends SignUpStates {
  String succssesMessage;
  SignUpSuccessState({
    required this.succssesMessage,
  });
}
