import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpStates> {
  static SignUpBloc get(context) => BlocProvider.of(context);

  SignUpBloc() : super(SignUpInitialState()) {
    on<RegiesterEvent>(
      (event, emit) => regis(
          email: event.email,
          phone: event.phone,
          name: event.name,
          password: event.password,
          confPassword: event.confPassword,
          emit: emit),
    );
  }
}

Future<void> regis(
    {required String email,
    required String phone,
    required String name,
    required String password,
    required String confPassword,
    required Emitter<SignUpStates> emit}) async {
  try {
    emit(SignUpLoadingState(loadingMessage: 'Registering...'));
// Add a small delay to show the loading message
    await Future.delayed(const Duration(milliseconds: 1500));
    final prefs = await SharedPreferences.getInstance();

    // Check for existing users
    List<Map<String, dynamic>> usersList = [];
    String? existingUsersString = prefs.getString('users_list');

    if (existingUsersString != null) {
      // Parse existing users
      usersList =
          List<Map<String, dynamic>>.from(json.decode(existingUsersString));

      // Check for duplicate email
      if (usersList.any((user) =>
          user['email'].toString().toLowerCase() == email.toLowerCase())) {
        emit(
            SignUpErrorState(errorMessage: 'This email is already registered'));
        return;
      } else if (phone.trim().isNotEmpty &&
          usersList.any((user) =>
              user['phone']?.toString().toLowerCase() ==
              phone.trim().toLowerCase())) {
        emit(SignUpErrorState(
            errorMessage: 'This phone number is already registered'));
        return;
      }
    }

    // Create new user data
    Map<String, dynamic> newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'confPassword': confPassword,
      'phone': phone,
      'registrationDate': DateTime.now().toIso8601String(),
    };

    // Add new user to the list
    usersList.add(newUser);

    // Save updated users list
    await prefs.setString('users_list', json.encode(usersList));

    // Save current user for session
    await prefs.setString('current_user', json.encode(newUser));
    await prefs.setBool('isLoggedIn', true);

    debugPrint('Users List: ${prefs.getString('users_list')}');
    debugPrint('Current User: ${prefs.getString('current_user')}');

    emit(SignUpSuccessState(succssesMessage: 'Registration successful!'));

    // Navigate directly to HomePage after successful signup
  } catch (e) {
    debugPrint('Error during registration: $e');

    emit(
        SignUpErrorState(errorMessage: 'Registration failed: ${e.toString()}'));
  }
}
