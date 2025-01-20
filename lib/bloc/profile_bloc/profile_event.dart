part of 'profile_bloc.dart';

// profile events
abstract class ProfileEvent {}

class LoadSavedImage extends ProfileEvent {}

class GetData extends ProfileEvent {}

class PickImage extends ProfileEvent {}
