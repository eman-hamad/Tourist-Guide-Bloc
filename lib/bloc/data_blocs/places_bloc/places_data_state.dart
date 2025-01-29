part of 'places_data_bloc.dart';

@immutable
abstract class PlacesState {}

class PlacesDataInitial extends PlacesState {}

class PlacesLoadingState extends PlacesState {}

class PlacesLoadedState extends PlacesState {
  final List<FSLandMark> sugPlaces;
  final List<FSLandMark> popPlaces;
  final bool isLoadingMore;
  final bool hasMore;

  PlacesLoadedState({
    required this.sugPlaces,
    required this.popPlaces,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  PlacesLoadedState copyWith({
    List<FSLandMark>? sugPlaces,
    List<FSLandMark>? popPlaces,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return PlacesLoadedState(
      sugPlaces: sugPlaces ?? this.sugPlaces,
      popPlaces: popPlaces ?? this.popPlaces,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PlacesLoaded extends PlacesState {
  final List<FSLandMark> places;
  PlacesLoaded({required this.places});
}

class PlacesError extends PlacesState {
  final String errorMsg;
  PlacesError({required this.errorMsg});
}
