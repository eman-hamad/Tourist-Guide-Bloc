import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/data/firebase/places_services.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

part 'fav_screen_state.dart';

class FavScreenCubit extends Cubit<FavScreenState> {
  final FavBloc favBloc;

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
      PlacesServices.places.clear();

      List<FSLandMark> land = await PlacesServices().getPlaces();
      //Get the curret user
      FSUser? user = await FirebaseService()
          .getUserData(FirebaseService().currentUser!.uid);
      if (user == null) {
        emit(FavScreenError("User not found"));
        return;
      }

      // Add a delay before emitting the data
      // Assign the future to track it
      _loadFavsFuture = await Future.delayed(Duration(seconds: 1), () {
        // Check if cubit is still active before emitting
        if (!isClosed) {
          // Get the fav place for the current user
          Set<String> favoritesList = Set.from(user.favPlacesIds ?? []);

          // Get the fav places withe the id
          List<FSLandMark> favs =
              land.where((place) => favoritesList.contains(place.id)).toList();

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
