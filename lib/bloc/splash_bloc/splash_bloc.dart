// splash_screen_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_event.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SplashScreenBloc() : super(SplashScreenInitialState()) {
    on<CheckLoginStatusEvent>(_onCheckLoginStatus);
    on<NavigateToNextScreenEvent>(_onNavigateToNextScreen);
  }

  Future<void> _onCheckLoginStatus(
      CheckLoginStatusEvent event, Emitter<SplashScreenState> emit) async {
    emit(SplashScreenLoadingState());

    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null && !currentUser.isAnonymous) {
        // Verify if user data exists in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          emit(SplashScreenLoggedInState());
        } else {
          await _auth.signOut();
          emit(SplashScreenLoggedOutState());
        }
      } else {
        emit(SplashScreenLoggedOutState());
      }
    } catch (e) {
      emit(SplashScreenErrorState(
          error: 'Error checking login status. Please try again.'));
    }
  }

  Future<void> _onNavigateToNextScreen(
      NavigateToNextScreenEvent event, Emitter<SplashScreenState> emit) async {
    try {
      User? currentUser = _auth.currentUser;
      bool isLoggedIn = currentUser != null && !currentUser.isAnonymous;

      if (isLoggedIn) {
        // Verify if user data exists in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          emit(SplashScreenNavigationState(true));
        } else {
          await _auth.signOut();
          emit(SplashScreenNavigationState(false));
        }
      } else {
        emit(SplashScreenNavigationState(false));
      }
    } catch (e) {
      emit(SplashScreenErrorState(
          error: 'Error during navigation. Please try again.'));
    }
  }
}
