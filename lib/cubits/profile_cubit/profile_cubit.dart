import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/data/models/user_model.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  User user = User(email: "", id: "", name: "", password: "", phone: "");
  File image = File("");
// func to save image in shared
  void loadSavedImage() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? imagePath = prefs.getString('img');

      if (imagePath != null && File(imagePath).existsSync()) {
        emit(ProfileImageLoaded(image: File(imagePath)));
      } else {
        emit(ProfileInitial());
      }
    } catch (e) {
      emit(ProfileImageError('Failed to load saved image: ${e.toString()}'));
    }
  }

// func to get user data from shared preferences
  Future<void> getData() async {
    try {
      emit(ProfileLoading());
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      final existingUserString = prefs.getString('current_user');
      //  final imagePath = prefs.getString('img');

      if (existingUserString != null) {
        final userData = jsonDecode(existingUserString);
        user = User.fromJson(userData);
      }

      // if (imagePath != null) {
      //   image = File(imagePath);
      // }

      emit(ProfileLoaded(user: user, image: image));
    } on Exception catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

// func to pick image from gallery and emit states when all is done
  Future<void> pickImage() async {
    try {
      emit(ProfileImageLoading());
      SharedPreferences? prefs = await SharedPreferences.getInstance();

      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();

        final String newPath = '${directory.path}/${pickedFile.name}';
        final File savedImage = await File(pickedFile.path).copy(newPath);

        prefs.setString('img', savedImage.path);

        image = savedImage;
        emit(ProfileImageLoaded(image: savedImage));
        emit(ProfileImageUploaded(image: savedImage));
      }
    } on Exception catch (e) {
      emit(ProfileImageError(e.toString()));
    }
  }
}
