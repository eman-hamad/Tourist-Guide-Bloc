import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/services/places_services.dart';

part 'fav_btn_event.dart';
part 'fav_btn_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  static FavBloc? _favBloc;
  FavBloc._internal() : super(FavInitial()) {
    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  // Singleton instance getter
  static FavBloc getInstance() {
    if (_favBloc == null || _favBloc!.isClosed) {
      _favBloc = FavBloc._internal(); 
    }
    return _favBloc!;
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
