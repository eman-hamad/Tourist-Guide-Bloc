import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';
import 'package:tourist_guide/data/models/user_model.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadSavedImage>(loadSavedImage);
    on<LoadProfile>(loadProfile);
    on<UpdateAvatar>(updateAvatar);
    on<LoadHeaderData>(getHeaderData);
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseService().currentUser;

  File image = File("");
  String firstName = "";
  File headerImage = File("");
  FSUser? firebaseUser = FSUser(
    uid: "",
    email: "",
    name: "",
    phone: "",
  );
// func to load image from firebase
  void loadSavedImage(LoadSavedImage event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      print("No user found");
      return;
    }
    try {
      emit(ProfileLoading());
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists) {
        String imagePath = doc.get('image');
        image = File(imagePath);

        emit(ProfileImageLoaded(image: File(imagePath)));
      } else {
        emit(ProfileInitial());
      }
    } catch (e) {
      emit(ProfileImageError('Failed to load saved image: ${e.toString()}'));
    }
  }

// func to get user data from firebase
  Future<void> loadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      print("No user found");
      return;
    }
    try {
      emit(ProfileLoading());
      firebaseUser = await FirebaseService().getUserData(currentUser!.uid);

      emit(ProfileLoaded(user: firebaseUser, image: image));
    } on Exception catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

// func to pick image from gallery and emit states when all is done
  Future<void> updateAvatar(
      UpdateAvatar event, Emitter<ProfileState> emit) async {
    if (currentUser == null) {
      print("No user found");
      return;
    }
    try {
      emit(ProfileImageLoading());

      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();

        final String newPath = '${directory.path}/${pickedFile.name}';
        final File savedImage = await File(pickedFile.path).copy(newPath);

        // Save user image to Firestore
        await _firestore
            .collection('Users')
            .doc(currentUser!.uid)
            .set({'image': savedImage.path}, SetOptions(merge: true));

        image = savedImage;
        emit(ProfileImageLoaded(image: savedImage));
        emit(ProfileImageUploaded(image: savedImage));
      }
    } on Exception catch (e) {
      emit(ProfileImageError(e.toString()));
    }
  }

// get header data from firebase
  Future<void> getHeaderData(
      LoadHeaderData event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());

      if (currentUser == null) {
        print("No user found");
        return;
      }

      FSUser? fUser = await FirebaseService().getUserData(currentUser!.uid);

      if (fUser != null) {
        String fullName = fUser.name;
        List<String> nameParts = fullName.split(" ");
        firstName = nameParts[0];

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser!.uid)
            .get();

        if (doc.exists) {
          String imagePath = doc.get('image');
          headerImage = File(imagePath);
        }
      }

      await Future.delayed(Duration(milliseconds: 500));
      emit(HeaderLoaded(firstName: firstName, image: headerImage));
    } on Exception catch (e) {
      emit(HeaderDataError(e.toString()));
    }
  }
}
