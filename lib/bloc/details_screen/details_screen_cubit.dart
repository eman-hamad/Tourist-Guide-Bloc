import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_screen_state.dart';

class DetailsScreenCubit extends Cubit<DetailsScreenState> {
  DetailsScreenCubit() : super(DetailsScreenState.initial()) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    Timer(const Duration(milliseconds: 0),
        () => emit(state.copyWith(showFirst: true)));
    Timer(const Duration(milliseconds: 250),
        () => emit(state.copyWith(showSecond: true)));
    Timer(const Duration(milliseconds: 500),
        () => emit(state.copyWith(showThird: true)));
    Timer(const Duration(milliseconds: 750),
        () => emit(state.copyWith(showFourth: true)));
  }
}
