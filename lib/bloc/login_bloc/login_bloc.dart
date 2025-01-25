// login_bloc.dart
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/data/models/user_model.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>(_loginUser);
  }

  Future<void> _loginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState(loadingMessage: 'Logging in...'));
    // Add a small delay to show the loading message
    await Future.delayed(const Duration(milliseconds: 1500));
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users_list');

      if (usersString == null) {
        emit(LoginErrorState(
            errorMessage: 'No registered users found. Please sign up first.'));
        return;
      }

      List<User> usersList =
          List<Map<String, dynamic>>.from(json.decode(usersString))
              .map((userJson) => User.fromJson(userJson))
              .toList();

      User? user = usersList.firstWhere(
        (user) =>
            user.email.toLowerCase() == event.email.toLowerCase() &&
            user.password == event.password,
      );

      if (user == null) {
        emit(LoginErrorState(
            errorMessage: 'Invalid email or password. Please try again.'));
        return;
      }

      await prefs.setString('current_user', json.encode(user.toJson()));
      await prefs.setBool('isLoggedIn', true);

      emit(LoginSuccessState(successMessage: 'Welcome back, ${user.name}!'));
    } catch (e) {
      emit(LoginErrorState(errorMessage: 'Login failed: ${e.toString()}'));
    }
  }
}
