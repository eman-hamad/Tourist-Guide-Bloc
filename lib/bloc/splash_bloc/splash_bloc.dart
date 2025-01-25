// splash_screen_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_event.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_state.dart';


class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  SplashScreenBloc() : super(SplashScreenInitialState()) {
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
    on<NavigateToNextScreenEvent>(_onNavigateToNextScreen);
  }

  Future<void> _onCheckLoginStatus(
      CheckLoginStatusEvent event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenLoadingState());
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(SplashScreenLoggedInState());
    } else {
      emit(SplashScreenLoggedOutState());
    }
  }

  Future<void> _onNavigateToNextScreen(
      NavigateToNextScreenEvent event, Emitter<SplashScreenState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    emit(SplashScreenNavigationState(isLoggedIn));
  }
}
