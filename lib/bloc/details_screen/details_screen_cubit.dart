import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'details_screen_state.dart';

class DetailsScreenCubit extends Cubit<DetailsScreenState> {
  DetailsScreenCubit() : super(DetailsScreenState.initial()) {
    _initializeAnimations();
  }

  void _initializeAnimations() async {
    // await Future.delayed(Duration(milliseconds: 1500));
    Timer(const Duration(milliseconds: 1500),
        () => emit(state.copyWith(showFirst: true)));
    Timer(const Duration(milliseconds: 2000),
        () => emit(state.copyWith(showSecond: true)));
    Timer(const Duration(milliseconds: 3000),
        () => emit(state.copyWith(showThird: true)));
    Timer(const Duration(milliseconds: 4000),
        () => emit(state.copyWith(showFourth: true)));
  }
}
