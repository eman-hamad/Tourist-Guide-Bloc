// login_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>(_loginUser);
  }

  Future<void> _loginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState(loadingMessage: 'Logging in...'));

    try {
      // Attempt to sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Convert Firestore data to your User model
          FSUser user = FSUser.fromFirestore(userDoc);

          emit(LoginSuccessState(
            successMessage: 'Welcome back, ${user.name}!',
            user: user,
          ));
        } else {
          await _auth.signOut();
          emit(LoginErrorState(
            errorMessage: 'User data not found. Please contact support.',
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }

      emit(LoginErrorState(errorMessage: errorMessage));
    } catch (e) {
      emit(LoginErrorState(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  // You might want to add a method to check if user is already logged in
  Future<void> checkCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await _firestore
            .collection('Users')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          FSUser user = FSUser.fromFirestore(userDoc);
          emit(LoginSuccessState(
            successMessage: 'Welcome back, ${user.name}!',
            user: user,
          ));
        }
      } catch (e) {
        emit(LoginErrorState(
          errorMessage: 'Error fetching user data: ${e.toString()}',
        ));
      }
    }
  }
}
