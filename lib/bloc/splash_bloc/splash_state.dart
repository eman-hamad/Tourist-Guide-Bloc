// splash_screen_state.dart
import 'package:flutter/material.dart';

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
