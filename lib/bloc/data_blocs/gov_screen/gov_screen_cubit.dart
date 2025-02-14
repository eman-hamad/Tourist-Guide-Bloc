import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/data/services/places_services.dart';
import 'package:tourist_guide/data/models/fire_store_goverorate_model.dart';

part 'gov_screen_state.dart';

class GovScreenCubit extends Cubit<GovScreenState> {
  GovScreenCubit() : super(GovScreenInitial()) {
    // Load governorates when the cubit initializes
    loadGovernorates();
  }

  // Track active asynchronous operations
  Future<void>? _loadGovsFuture;

  @override
  Future<void> close() {
    // Cancel pending futures when the cubit is closed
    _loadGovsFuture?.ignore();
    return super.close();
  }

  List<GovernorateModel> govs = [];

  Future<void> loadGovernorates() async {
    try {
      // Emit data loading state
      emit(GovScreenLoading());

      // Add a delay before emitting the data
      // Assign the future to track it
      _loadGovsFuture =
          await Future.delayed(Duration(microseconds: 1), () async {
        // Check if cubit is still active before emitting
        if (!isClosed) {
          // Get the data
          govs = await PlacesServices().getGovs();

          // Emit data loaded state
          emit(GovScreenLoaded(govs: govs));
        }
        return null;
      });

      await _loadGovsFuture;
    } catch (e) {
      if (!isClosed) emit(GovScreenError(errorMsg: e.toString()));
    }
  }
}
