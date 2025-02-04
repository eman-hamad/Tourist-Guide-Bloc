import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/data/firebase/places_services.dart';

part 'fav_btn_event.dart';
part 'fav_btn_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  FavBloc() : super(FavInitial()) {
    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  Future<void> _toggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavState> emit,
  ) async {
    try {
      final isFav = await PlacesServices().updateFavPlaces(event.placeId);

      // Emit success state
      emit(FavoriteToggled(isFav: isFav));
    } catch (e) {
      emit(FavError(errorMsg: e.toString()));
    }
  }
}
