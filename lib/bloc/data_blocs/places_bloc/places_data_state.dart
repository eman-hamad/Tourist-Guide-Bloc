// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'places_data_bloc.dart';

@immutable
abstract class PlacesState {}

class PlacesDataInitial extends PlacesState {}

class PlacesLoadingState extends PlacesState {}

class PlacesLoadedState extends PlacesState {
  final List<LandMark> sugPlaces;
  final List<LandMark> popPlaces;
  final bool isLoadingMore;
  final bool hasMore;

  PlacesLoadedState({
    required this.sugPlaces,
    required this.popPlaces,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  PlacesLoadedState copyWith({
    List<LandMark>? sugPlaces,
    List<LandMark>? popPlaces,
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
  final List<LandMark> places;
  PlacesLoaded({required this.places});
}

class PlacesError extends PlacesState {
  final String errorMsg;
  PlacesError({required this.errorMsg});
}
