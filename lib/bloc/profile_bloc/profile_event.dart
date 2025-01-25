part of 'profile_bloc.dart';

// profile events
abstract class ProfileEvent {}

class LoadSavedImage extends ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateAvatar extends ProfileEvent {}

class LoadHeaderData extends ProfileEvent {}
