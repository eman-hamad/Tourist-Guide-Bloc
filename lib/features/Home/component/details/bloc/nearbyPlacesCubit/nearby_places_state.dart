part of 'nearby_places_cubit.dart';

@immutable
abstract class NearbyPlacesState {}

class NearbyPlacesInitial extends NearbyPlacesState {}

class NearbyPlacesLoading extends NearbyPlacesState {}

class NearbyPlacesLoaded extends NearbyPlacesState {
  final List<FSLandMark> nearbyPlaces;

  NearbyPlacesLoaded({required this.nearbyPlaces});
}

class NearbyPlacesError extends NearbyPlacesState {
  final String errorMsg;

  NearbyPlacesError({required this.errorMsg});
}
