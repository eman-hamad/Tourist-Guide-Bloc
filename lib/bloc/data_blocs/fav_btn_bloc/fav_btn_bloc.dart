import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

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
      // Get the list of favorite places ids
      final ids = UserManager().getFavPlacesIds();

      // Check if ids contains the current id
      final isFav = ids.contains(event.placeId.toString());

      // If current id exists, remove it. Otherwise add it
      isFav
          ? ids.remove(event.placeId.toString())
          : ids.add(event.placeId.toString());

      // Update the fav ids list in shared prefs
      UserManager().setFavPlacesIds(ids: ids);

      // Update PlacesData
      PlacesData.kLandmarks[event.placeId].fav = !isFav;

      // Emit success state
      emit(FavoriteToggled(isFav: !isFav));

      debugPrint('=====\n$ids\n=====');
    } catch (e) {
      emit(FavError(errorMsg: e.toString()));
    }
  }
}
