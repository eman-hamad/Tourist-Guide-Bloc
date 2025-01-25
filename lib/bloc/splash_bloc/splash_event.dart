// splash_screen_event.dart
import 'package:meta/meta.dart';

@immutable
abstract class SplashScreenEvent {}

class CheckLoginStatusEvent extends SplashScreenEvent {}

class NavigateToNextScreenEvent extends SplashScreenEvent {}
