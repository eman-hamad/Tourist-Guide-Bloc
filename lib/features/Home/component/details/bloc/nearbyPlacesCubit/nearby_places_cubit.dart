import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/models/fire_store_landmark_model.dart';
import '../../../../../../data/services/places_services.dart';

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
