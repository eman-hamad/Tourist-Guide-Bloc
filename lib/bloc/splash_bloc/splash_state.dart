// splash_screen_state.dart
import 'package:meta/meta.dart';

@immutable
abstract class SplashScreenState {}

class SplashScreenInitialState extends SplashScreenState {}

class SplashScreenLoadingState extends SplashScreenState {}

class SplashScreenLoggedInState extends SplashScreenState {}

class SplashScreenLoggedOutState extends SplashScreenState {}

class SplashScreenNavigationState extends SplashScreenState {
  final bool isLoggedIn;

  SplashScreenNavigationState(this.isLoggedIn);
}
