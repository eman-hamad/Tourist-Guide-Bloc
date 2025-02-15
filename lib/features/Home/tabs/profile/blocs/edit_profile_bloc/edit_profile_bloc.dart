import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../ui/home.dart';
import '../../../../../../core/widgets/custom_snack_bar.dart';
import '../../../../../../data/firebase/firebase_auth_services.dart';

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
    String? password,
    String phoneNumber,
  ) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        // update data in firebase
        FirebaseService().updateUserData({
          'name': name,
          'email': email,
          'phone': phoneNumber,
        }, password: password );

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
