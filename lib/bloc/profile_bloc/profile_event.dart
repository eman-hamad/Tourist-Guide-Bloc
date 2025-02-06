part of 'profile_bloc.dart';

// profile events
abstract class ProfileEvent {}

class UpdateAvatar extends ProfileEvent {}

class LoadHeaderData extends ProfileEvent {}

class SubscribeProfile extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final FSUser user;

  ProfileUpdated({required this.user});
}

class ImageUpdated extends ProfileEvent {
  final Uint8List? image;

  ImageUpdated({required this.image});
}

class ImageRemoved extends ProfileEvent {
  ImageRemoved();
}

class ProfileSubscriptionError extends ProfileEvent {
  final String errorMessage;
  ProfileSubscriptionError(this.errorMessage);
}
class AuthenticateWithBiometrics extends ProfileEvent {}