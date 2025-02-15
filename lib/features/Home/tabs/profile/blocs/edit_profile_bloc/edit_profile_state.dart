part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

class EditInitial extends EditProfileState {}

class EditLoading extends EditProfileState {}

class EditSuccess extends EditProfileState {}

class EditError extends EditProfileState {
  final String errorMessage;
  EditError(this.errorMessage);
}
