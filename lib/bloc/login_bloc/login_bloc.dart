// login_bloc.dart
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>(_loginUser);
  }

  Future<void> _loginUser(
      LoginUserEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState(loadingMessage: 'Logging in...'));
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users_list');

      if (usersString == null) {
        emit(LoginErrorState(
            errorMessage: 'No registered users found. Please sign up first.'));
        return;
      }

      List<Map<String, dynamic>> usersList =
      List<Map<String, dynamic>>.from(json.decode(usersString));

      final user = usersList.firstWhere(
            (user) =>
        user['email'].toString().toLowerCase() ==
            event.email.toLowerCase() &&
            user['password'] == event.password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        emit(LoginErrorState(
            errorMessage: 'Invalid email or password. Please try again.'));
        return;
      }

      await prefs.setString('current_user', json.encode(user));
      await prefs.setBool('isLoggedIn', true);

      emit(LoginSuccessState(
          successMessage: 'Welcome back, ${user['name']}!'));
    } catch (e) {
      emit(LoginErrorState(
          errorMessage: 'Login failed: ${e.toString()}'));
    }
  }
}
