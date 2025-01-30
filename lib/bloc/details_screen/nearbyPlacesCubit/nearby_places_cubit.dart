import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:tourist_guide/data/firebase/places_services.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

part 'nearby_places_state.dart';

class NearbyPlacesCubit extends Cubit<NearbyPlacesState> {
  NearbyPlacesCubit() : super(NearbyPlacesInitial());

  void getNearbyPlaces({required FSLandMark landamark}) async {
    emit(NearbyPlacesLoading());
    try {
      List<FSLandMark> nearbyPlaces =
          await PlacesServices.getNearbyPlaces(landmark: landamark);
      emit(NearbyPlacesLoaded(nearbyPlaces: nearbyPlaces));
    } catch (e) {
      emit(NearbyPlacesError(errorMsg: e.toString()));
    }
  }
}
