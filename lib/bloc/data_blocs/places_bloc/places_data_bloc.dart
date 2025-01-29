import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/data/firebase/places_services.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

part 'places_data_event.dart';
part 'places_data_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  int _page = 0;
  final int _pageSize = 4;
  List<FSLandMark> places = [];

  PlacesBloc() : super(PlacesDataInitial()) {
    on<LoadPlacesEvent>(_getPlaces);
    on<LoadMorePlacesEvent>(_getMorePlaces);
  }

  FutureOr<void> _getPlaces(
    LoadPlacesEvent event,
    Emitter<PlacesState> emit,
  ) async {
    _page = 0;
    try {
      emit(PlacesLoadingState());
      places = await PlacesServices().getPlaces();

      final sugPlaces = _getPaginatedSuggestedPlaces();
      List<FSLandMark> popPlaces = [];

      for (int i = 0; i < places.length; i++) {
        if (i.isOdd) {
          popPlaces.add(places[i]);
        }
      }

      emit(PlacesLoadedState(
        sugPlaces: sugPlaces,
        popPlaces: popPlaces,
        hasMore: true,
      ));
    } catch (e) {
      emit(PlacesError(errorMsg: e.toString()));
    }
  }

  FutureOr<void> _getMorePlaces(
    LoadMorePlacesEvent event,
    Emitter<PlacesState> emit,
  ) async {
    if (state is! PlacesLoadedState) return;
    final currentState = state as PlacesLoadedState;

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
