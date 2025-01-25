// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

part of 'sign_up_bloc.dart';



abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {
  final String loadingMessage;
  SignUpLoadingState({required this.loadingMessage});
}

class SignUpSuccessState extends SignUpStates {
  final String succssesMessage;
  SignUpSuccessState({required this.succssesMessage});
}

class SignUpErrorState extends SignUpStates {
  final String errorMessage;
  SignUpErrorState({required this.errorMessage});
}

class SignUpValidationErrorState extends SignUpStates {
  final String errorMessage;
  SignUpValidationErrorState({required this.errorMessage});
}

class SignUpValidationSuccessState extends SignUpStates {}