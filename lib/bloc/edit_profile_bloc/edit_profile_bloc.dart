import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/core/widgets/custom_snack_bar.dart';
import 'package:tourist_guide/data/models/user_model.dart';
import 'package:tourist_guide/ui/home/home.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditInitial()) {
    on<SaveEdits>(_onSaveEdits);
  }

  Future<void> _onSaveEdits(
      SaveEdits event, Emitter<EditProfileState> emit) async {
    emit(EditLoading());
    try {
      await saveEdits(
        event.context,
        event.formKey,
        event.name,
        event.email,
        event.password,
        event.phoneNumber,
      );
      emit(EditSuccess());
    } catch (e) {
      emit(EditError(e.toString()));
    }
  }

  // save profile edits
  Future<void> saveEdits(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        final prefs = await SharedPreferences.getInstance();
        final myUser = prefs.getString('current_user');
        if (myUser != null) {
          Map<String, dynamic> map = jsonDecode(myUser);
          var user1 = UserModel.fromJson(map);
          UserManager.deleteUser(user1.id);
        }
        List<Map<String, dynamic>> usersList = [];
        String? existingUsersString = prefs.getString('users_list');
        if (existingUsersString != null) {
          usersList =
              List<Map<String, dynamic>>.from(json.decode(existingUsersString));
        }
        Map<String, dynamic> newUser = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': name,
          'email': email.toLowerCase(),
          'password': password,
          'phone': phoneNumber,
          'registrationDate': DateTime.now().toIso8601String(),
        };
        usersList.add(newUser);
        await prefs.setString('current_user', json.encode(newUser));
        if (!context.mounted) return;
        CustomSnackBar.showSuccess(
            context: context, message: 'Edited successfully!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      } catch (e) {
        debugPrint('Error during Edit: $e');
        CustomSnackBar.showError(
            context: context, message: 'Edit failed: ${e.toString()}');
      }
    }
  }
}
