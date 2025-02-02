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
    on<UpdateAvatar>(updateAvatar);
    on<LoadHeaderData>(getHeaderData);
    on<SubscribeProfile>(_subscribeProfile);
    on<ProfileUpdated>((event, emit) {
      emit(ProfileLoaded(user: event.user, image: image));
    });
    on<ProfileSubscriptionError>((event, emit) {
      emit(ProfileError(event.errorMessage));
    });
    on<ImageUpdated>((event, emit) {
      emit(ProfileImageLoaded(image: event.image));
    });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseService().currentUser;
  FSUser? cUser;
  File image = File("");
  String firstName = "";
  File headerImage = File("");
  FSUser? firebaseUser = FSUser(
    uid: "",
    email: "",
    name: "",
    phone: "",
  );
  StreamSubscription<FSUser?>? _userSubscription;
  void _subscribeProfile(SubscribeProfile event, Emitter<ProfileState> emit) {
    if (currentUser == null) {
      print("No user found");
      return;
    }

    _userSubscription?.cancel();
    _userSubscription = getUserDataStream(currentUser!.uid).listen(
      (user) {
        if (user != null) {
          firebaseUser = user;

          String fullName = user.name;
          List<String> nameParts = fullName.split(" ");
          firstName = nameParts[0];
          image = File(user.image);

          add(ProfileUpdated(user: user));
          add(ImageUpdated(image: image));
        } else {
          add(ProfileSubscriptionError("User data not found"));
        }
      },
      onError: (error) {
        add(ProfileSubscriptionError(error.toString()));
      },
    );
  }

  Stream<FSUser?> getUserDataStream(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map((DocumentSnapshot doc) {
      if (doc.exists) {
        cUser = FSUser.fromFirestore(doc);
        return cUser;
      }
      return null;
    });
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

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
