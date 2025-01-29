part of 'profile_bloc.dart';

// states of profile screen  to load data and upload , save and get the image
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel? user;
  final File? image;
  ProfileLoaded({this.user, this.image});
}

class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}

class ProfileImageLoading extends ProfileState {}

class ProfileImageLoaded extends ProfileState {
  final File image;
  ProfileImageLoaded({required this.image});
}

class ProfileImageUploaded extends ProfileState {
  final File image;
  ProfileImageUploaded({required this.image});
}

class ProfileImageError extends ProfileState {
  final String errorMessage;
  ProfileImageError(this.errorMessage);
}

class HeaderLoaded extends ProfileState {
  final File image;
  final String firstName;
  HeaderLoaded({required this.image, required this.firstName});
}

class HeaderDataError extends ProfileState {
  final String errorMessage;
  HeaderDataError(this.errorMessage);
}
