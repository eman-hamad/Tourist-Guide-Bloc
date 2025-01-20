import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'landmark_event.dart';
part 'landmark_state.dart';

class LandmarkBloc extends Bloc<LandmarkEvent, LandmarkState> {
  LandmarkBloc() : super(LandmarkInitial());

  Stream<LandmarkState> mapEventToState(LandmarkEvent event) async* {}
}
