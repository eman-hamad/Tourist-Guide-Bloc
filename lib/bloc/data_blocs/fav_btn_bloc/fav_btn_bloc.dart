import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

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
      // Get the current User data
      FSUser? user = await FirebaseService()
          .getUserData(FirebaseService().currentUser!.uid);
      if (user == null) {
        emit(FavError(errorMsg: "User not found"));
        return;
      }
      // Get the current User Fav List
      List<String> updatedFavorites = List.from(user.favPlacesIds ?? []);

      if (updatedFavorites.contains(event.placeId)) {
        updatedFavorites.remove(event.placeId);
      } else {
        updatedFavorites.add(event.placeId.toString());
      }

      // Update User data (fav List)
      await FirebaseService()
          .updateUserData({"favPlacesIds": updatedFavorites});

      emit(FavoriteToggled(isFav: updatedFavorites));
    } catch (e) {
      emit(FavError(errorMsg: e.toString()));
    }
  }
}
