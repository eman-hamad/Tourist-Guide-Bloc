import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';
import 'package:tourist_guide/data/models/user_model.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpStates> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static SignUpBloc get(context) => BlocProvider.of(context);

  SignUpBloc() : super(SignUpInitialState()) {
    on<RegiesterEvent>(_handleRegister);
    on<ValidateFieldsEvent>(_handleValidateFields);
  }

  // Add methods to check for existing name and phone
  Future<bool> isNameTaken(String name) async {
    final QuerySnapshot result = await _firestore
        .collection('Users')
        .where('name', isEqualTo: name.trim())
        .get();
    return result.docs.isNotEmpty;
  }

  Future<bool> isPhoneTaken(String phone) async {
    if (phone.isEmpty) return false;
    final QuerySnapshot result = await _firestore
        .collection('Users')
        .where('phone', isEqualTo: phone.trim())
        .get();
    return result.docs.isNotEmpty;
  }

  bool isValidPhone(String phone) {
    if (phone.isEmpty) return true;
    return RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phone.trim());
  }

  void _handleRegister(RegiesterEvent event, Emitter<SignUpStates> emit) async {
    // First validate fields
    final List<String> emptyFields = _validateFields(
      name: event.name,
      email: event.email,
      password: event.password,
      confPassword: event.confPassword,
    );

    if (emptyFields.isNotEmpty) {
      emit(SignUpValidationErrorState(
          errorMessage: _getEmptyFieldsMessage(emptyFields)));
      return;
    }

    // If validation passes, proceed with registration
    await regis(
      email: event.email,
      phone: event.phone,
      name: event.name,
      password: event.password,
      confPassword: event.confPassword,
      emit: emit,
    );
  }

  void _handleValidateFields(
      ValidateFieldsEvent event, Emitter<SignUpStates> emit) {
    final List<String> emptyFields = _validateFields(
      name: event.name,
      email: event.email,
      password: event.password,
      confPassword: event.confPassword,
    );

    if (emptyFields.isNotEmpty) {
      emit(SignUpValidationErrorState(
          errorMessage: _getEmptyFieldsMessage(emptyFields)));
    } else {
      emit(SignUpValidationSuccessState());
    }
  }

  List<String> _validateFields({
    required String name,
    required String email,
    required String password,
    required String confPassword,
  }) {
    List<String> emptyFields = [];

    if (name.trim().isEmpty) emptyFields.add('Full Name');
    if (email.trim().isEmpty) emptyFields.add('Email');
    if (password.isEmpty) emptyFields.add('Password');
    if (confPassword.isEmpty) emptyFields.add('Confirm Password');

    return emptyFields;
  }

  String _getEmptyFieldsMessage(List<String> emptyFields) {
    if (emptyFields.isEmpty) return '';
    if (emptyFields.length == 1) return 'Please enter your ${emptyFields[0]}';

    String message = 'Please enter: ';
    for (int i = 0; i < emptyFields.length; i++) {
      if (i == emptyFields.length - 1) {
        message += 'and ${emptyFields[i]}';
      } else if (i == emptyFields.length - 2) {
        message += '${emptyFields[i]} ';
      } else {
        message += '${emptyFields[i]}, ';
      }
    }
    return message;
  }

  Future<void> regis({
    required String email,
    required String phone,
    required String name,
    required String password,
    required String confPassword,
    required Emitter<SignUpStates> emit,
  }) async {
    try {
      //emit(SignUpLoadingState(loadingMessage: 'Checking username availability...'));

      // Validate name length
      if (name.trim().length < 3 || name.trim().length > 30) {
        emit(SignUpErrorState(
          errorMessage: 'Name must be between 3 and 30 characters',
        ));
        return;
      }

      // Check for duplicate name
      if (await isNameTaken(name)) {
        emit(SignUpErrorState(
          errorMessage:
              'This Full Name is already taken. Please choose another one.',
        ));
        return;
      }

      // Validate and check phone if provided
      if (phone.isNotEmpty) {
        // emit(SignUpLoadingState(loadingMessage: 'Checking phone number...'));

        if (!isValidPhone(phone)) {
          emit(SignUpErrorState(
            errorMessage: 'Please enter a valid phone number',
          ));
          return;
        }

        if (await isPhoneTaken(phone)) {
          emit(SignUpErrorState(
            errorMessage: 'This phone number is already registered.',
          ));
          return;
        }
      }

      emit(SignUpLoadingState(loadingMessage: 'Creating your account...'));

      // Verify passwords match
      if (password != confPassword) {
        emit(SignUpErrorState(errorMessage: 'Passwords do not match'));
        return;
      }

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // Create FSUser instance
        FSUser newUser = FSUser(
          uid: userCredential.user!.uid,
          name: name.trim(),
          email: email.toLowerCase().trim(),
          phone: phone.trim(),
          favPlacesIds: [],
        );

        // Save user data to Firestore
        await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(newUser.toFirestore());

        emit(SignUpSuccessState(
          succssesMessage: 'Welcome ${newUser.name}!',
          user: newUser,
        ));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      emit(SignUpErrorState(errorMessage: errorMessage));
    } catch (e) {
      emit(SignUpErrorState(
          errorMessage: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}
