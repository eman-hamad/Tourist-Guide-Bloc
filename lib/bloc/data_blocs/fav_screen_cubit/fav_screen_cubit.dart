import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

part 'fav_screen_state.dart';

class FavScreenCubit extends Cubit<FavScreenState> {
  final FavBloc favBloc;

  FavScreenCubit({required this.favBloc}) : super(FavScreenInitial()) {
    // Load favorites when the cubit initializes
    loadFavorites();

    // Listen to FavBloc to reload when a favorite is toggled
    favBloc.stream.listen((state) {
      if (state is FavoriteToggled) {
        loadFavorites();
      }
    });
  }

  // Track active asynchronous operations
  Future<void>? _loadFavsFuture;

  @override
  Future<void> close() {
    // Cancel pending futures when the cubit is closed
    _loadFavsFuture?.ignore();
    return super.close();
  }

  Future<void> loadFavorites() async {
    // Emit data loading state
    emit(FavScreenLoading());

    try {
      // Add a delay before emitting the data
      // Assign the future to track it
      _loadFavsFuture = await Future.delayed(Duration(seconds: 3), () {
        // Check if cubit is still active before emitting
        if (!isClosed) {
          // Fetch favorites directly from PlacesData
          final ids = UserManager().getFavPlacesIds();
          final favs = PlacesData.kLandmarks
              .where((place) => ids.contains(place.id))
              .toList();

          emit(FavScreenLoaded(favs: favs));
        }
        return null;
      });

      await _loadFavsFuture;
    } catch (e) {
      emit(FavScreenError(e.toString()));
    }
  }
}
