import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../../data/models/fire_store_landmark_model.dart';
import '../../../../../../data/services/places_services.dart';

part 'gov_details_state.dart';

class GovDetailsCubit extends Cubit<GovDetailsState> {
  GovDetailsCubit() : super(GovDetailsInitial());

  Future<void> getDetails(String govName) async {
    try {
      // Emit data loading state
      emit(GovDetailsLoading());

      // Get the data
      List<FSLandMark> govs = PlacesServices.places.where((lanmark) {
        return lanmark.governorate.toLowerCase() == govName.toLowerCase();
      }).toList();

      // Emit data loaded state
      emit(GovDetailsLoaded(govs: govs));
    } catch (e) {
      emit(GovDetailsError(errorMsg: e.toString()));
    }
  }
}
