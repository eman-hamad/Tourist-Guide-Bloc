import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/data/models/user_model.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadSavedImage>(loadSavedImage);
    on<GetData>(getData);
    on<PickImage>(pickImage);
    on<LoadHeaderData>(getHeaderData);
  }

  User user = User(email: "", id: "", name: "", password: "", phone: "");
  File image = File("");
  String firstName = "";
  File headerImage = File("");
// func to save image in shared
  void loadSavedImage(LoadSavedImage event, Emitter<ProfileState> emit) async {
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
  Future<void> getData(GetData event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      final existingUserString = prefs.getString('current_user');

      if (existingUserString != null) {
        final userData = jsonDecode(existingUserString);
        user = User.fromJson(userData);
      }

      emit(ProfileLoaded(user: user, image: image));
    } on Exception catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

// func to pick image from gallery and emit states when all is done
  Future<void> pickImage(PickImage event, Emitter<ProfileState> emit) async {
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

  Future<void> getHeaderData(
      LoadHeaderData event, Emitter<ProfileState> emit) async {
    try {

      User currentUser =
          User(email: "", id: "", name: "", password: "", phone: "");
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      final existingUserString = prefs.getString('current_user');

      if (existingUserString != null) {
        final userData = jsonDecode(existingUserString);
        currentUser = User.fromJson(userData);
        String fullName = currentUser.name;
        List<String> nameParts = fullName.split(" ");
        firstName = nameParts[0];
      }

      final String? imagePath = prefs.getString('img');

      if (imagePath != null && File(imagePath).existsSync()) {
        headerImage = File(imagePath);
      }
      await Future.delayed(Duration(seconds: 3));
      emit(HeaderLoaded(firstName: firstName, image: headerImage));
    } on Exception catch (e) {
      emit(HeaderDataError(e.toString()));
    }
  }
}
