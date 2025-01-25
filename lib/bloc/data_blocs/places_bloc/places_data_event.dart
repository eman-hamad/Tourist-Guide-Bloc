part of 'places_data_bloc.dart';

@immutable
abstract class PlacesEvent {}

class LoadPlacesEvent extends PlacesEvent {}

class LoadMorePlacesEvent extends PlacesEvent {}
