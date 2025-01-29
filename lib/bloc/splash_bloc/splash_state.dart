// splash_screen_state.dart
import 'package:meta/meta.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

@immutable
// Update splash_state.dart to include user data
abstract class SplashScreenState {}

class SplashScreenInitialState extends SplashScreenState {}

class SplashScreenLoadingState extends SplashScreenState {}

class SplashScreenLoggedInState extends SplashScreenState {}

class SplashScreenLoggedOutState extends SplashScreenState {}

class SplashScreenErrorState extends SplashScreenState {
  final String error;
  SplashScreenErrorState({required this.error});
}

class SplashScreenNavigationState extends SplashScreenState {
  final bool isLoggedIn;
  SplashScreenNavigationState(this.isLoggedIn);
}