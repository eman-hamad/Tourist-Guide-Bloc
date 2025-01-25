import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

part 'places_data_event.dart';
part 'places_data_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  int _page = 0;
  final int _pageSize = 4;

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
      final sugPlaces = _getPaginatedSuggestedPlaces();
      final popPlaces = PlacesData().popularPlaces();
      await Future.delayed(Duration(seconds: 2));
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
      await Future.delayed(Duration(seconds: 1));

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

  List<LandMark> _getPaginatedSuggestedPlaces() {
    final allPlaces = PlacesData.kLandmarks;
    final startIndex = _page * _pageSize;
    if (startIndex >= allPlaces.length) return [];
    return allPlaces.sublist(
      startIndex,
      startIndex + _pageSize > allPlaces.length
          ? allPlaces.length
          : startIndex + _pageSize,
    );
  }
}
