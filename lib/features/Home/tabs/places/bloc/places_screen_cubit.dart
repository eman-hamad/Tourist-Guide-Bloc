import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/features/Home/component/fav_btn_bloc/fav_btn_bloc.dart';
import '../../../../../data/services/places_services.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';

part 'places_screen_state.dart';

class PlacesScreenCubit extends Cubit<PlacesScreenState> {
  final FavBloc favBloc;

  int _page = 0;
  final int _pageSize = 4;
  List<FSLandMark> places = [];

  PlacesScreenCubit({required this.favBloc}) : super(PlacesScreenInitial()) {
    // Load favorites when the cubit initializes
    loadPlaces();

    // Listen to FavBloc to reload when a favorite is toggled
    favBloc.stream.listen((state) {
      if (state is FavoriteToggled) {
        loadPlaces();
      }
    });
  }

  Future<void> loadPlaces() async {
    _page = 0;
    emit(PlacesScreenLoadingState());
    try {
      places.clear();
      places = await PlacesServices().getPlaces();

      final sugPlaces = _getPaginatedSuggestedPlaces();
      List<FSLandMark> popPlaces = [];

      for (int i = 0; i < places.length; i++) {
        if (i.isOdd) {
          popPlaces.add(places[i]);
        }
      }

      emit(PlacesScreenLoadedState(
        sugPlaces: sugPlaces,
        popPlaces: popPlaces,
        hasMore: true,
      ));
    } catch (e) {
      emit(PlacesScreenErrorState(errorMsg: e.toString()));
    }
  }

  Future<void> loadMorePlaces() async {
    if (state is! PlacesScreenLoadedState) return;
    final currentState = state as PlacesScreenLoadedState;

    try {
      emit(currentState.copyWith(isLoadingMore: true));

      _page++;
      final newPlaces = _getPaginatedSuggestedPlaces();

      emit(currentState.copyWith(
        sugPlaces: [...currentState.sugPlaces, ...newPlaces],
        isLoadingMore: false,
        hasMore: newPlaces.isNotEmpty,
      ));
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  List<FSLandMark> _getPaginatedSuggestedPlaces() {
    final startIndex = _page * _pageSize;
    if (startIndex >= places.length) return [];
    return places.sublist(
      startIndex,
      startIndex + _pageSize > places.length
          ? places.length
          : startIndex + _pageSize,
    );
  }
}
