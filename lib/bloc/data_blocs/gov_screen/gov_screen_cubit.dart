import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

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

  Future<void> loadGovernorates() async {
    try {
      // Emit data loading state
      emit(GovScreenLoading());

      // Add a delay before emitting the data
      // Assign the future to track it
      _loadGovsFuture = await Future.delayed(Duration(seconds: 3), () {
        // Check if cubit is still active before emitting
        if (!isClosed) {
          // Get the data
          final govs = PlacesData().govs();

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

  Future<void> getDetails(String govName) async {
    try {
      // Emit data loading state
      emit(GovDetailsLoading());

      // Add a delay before emitting the data
      // Assign the future to track it
      _loadGovsFuture = await Future.delayed(Duration(seconds: 3), () {
        // Check if cubit is still active before emitting
        if (!isClosed) {
          // Get the data
          List<LandMark> govs = PlacesData().getGoverLandmarks(govName);

          // Emit data loaded state
          emit(GovDetailsLoaded(govs: govs));
        }
        return null;
      });

      await _loadGovsFuture;
    } catch (e) {
      emit(GovDetailsError(errorMsg: e.toString()));
    }
  }
}
