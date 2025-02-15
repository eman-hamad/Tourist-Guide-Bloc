part of 'places_screen_cubit.dart';

@immutable
abstract class PlacesScreenState {}

class PlacesScreenInitial extends PlacesScreenState {}

class PlacesScreenLoadingState extends PlacesScreenState {}

class PlacesScreenLoadedState extends PlacesScreenState {
  final List<FSLandMark> sugPlaces;
  final List<FSLandMark> popPlaces;
  final bool isLoadingMore;
  final bool hasMore;

  PlacesScreenLoadedState({
    required this.sugPlaces,
    required this.popPlaces,
    this.isLoadingMore = false,
    this.hasMore = true,
  });

  PlacesScreenLoadedState copyWith({
    List<FSLandMark>? sugPlaces,
    List<FSLandMark>? popPlaces,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return PlacesScreenLoadedState(
      sugPlaces: sugPlaces ?? this.sugPlaces,
      popPlaces: popPlaces ?? this.popPlaces,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PlacesScreenErrorState extends PlacesScreenState {
  final String errorMsg;
  PlacesScreenErrorState({required this.errorMsg});
}
