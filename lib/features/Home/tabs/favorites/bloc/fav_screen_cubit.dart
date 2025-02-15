import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/features/Home/component/fav_btn_bloc/fav_btn_bloc.dart';
import '../../../../../data/services/places_services.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';

part 'fav_screen_state.dart';

class FavScreenCubit extends Cubit<FavScreenState> {
  FavBloc favBloc = FavBloc.getInstance();

  FavScreenCubit({required this.favBloc}) : super(FavScreenInitial()) {
    // Load favorites when the cubit initializes
    loadFavorites();

    // Listen to FavBloc to reload when a favorite is toggled
    favBloc.stream.distinct().listen((state) {
      if (state is FavoriteToggled) {
        loadFavorites();
      }
    });
  }

  Future<void> loadFavorites() async {
    // Emit data loading state
    emit(FavScreenLoading());
    try {
      if (!isClosed) {
        final favPlaces = await PlacesServices().favPlaces();
        emit(FavScreenLoaded(favs: favPlaces));
      }
    } catch (e) {
      if (!isClosed) {
        emit(FavScreenError(e.toString()));
      }
    }
  }
}
