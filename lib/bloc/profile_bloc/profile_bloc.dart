import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourist_guide/data/biometric_auth_service.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateAvatar>(updateAvatar);
    on<LoadHeaderData>(getHeaderData);
    on<SubscribeProfile>(_subscribeProfile);
    on<ImageRemoved>((removeImage));
    on<AuthenticateWithBiometrics>(_authenticateWithBiometrics);

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
  Uint8List? image;
  String firstName = "";
  Uint8List? headerImage;
  FSUser? firebaseUser = FSUser(
    uid: "",
    email: "",
    name: "",
    phone: "",
  );
  StreamSubscription<FSUser?>? _userSubscription;
  final BiometricAuth _biometricAuth = BiometricAuth();
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

          // Decode the Base64 string back to Uint8List
          if (user.image.isNotEmpty) {
            image = base64Decode(user.image);
          }

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
  Future<void> _authenticateWithBiometrics(
      AuthenticateWithBiometrics event, Emitter<ProfileState> emit) async {
    emit(BiometricAuthenticationRequired());

    bool isAvailable = await _biometricAuth.isBiometricAvailable();
    if (!isAvailable) {
      emit(BiometricAuthenticationFailure(
          'Biometric authentication not available.'));
      return;
    }

    bool isAuthenticated = await _biometricAuth.authenticate();
    if (isAuthenticated) {
      emit(BiometricAuthenticationSuccess());
    } else {
      emit(BiometricAuthenticationFailure('Authentication failed.'));
    }
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
        File imagePath = File(pickedFile.path);
        Uint8List? imageBytes = await imagePath.readAsBytes();

        // Encode from Uint8List to Base64
        String encodedImage = base64Encode(imageBytes);

        // Save user image to Firestore
        await _firestore
            .collection('Users')
            .doc(currentUser!.uid)
            .set({'image': encodedImage}, SetOptions(merge: true));

        // image = savedImage;
        image = imageBytes;

        emit(ProfileImageLoaded(image: Uint8List.fromList(imageBytes)));
        emit(ProfileImageUploaded(image: Uint8List.fromList(imageBytes)));
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
          if (imagePath.isNotEmpty) {
            headerImage = base64Decode(imagePath);
          }
        }
      }

      await Future.delayed(Duration(milliseconds: 500));
      emit(HeaderLoaded(firstName: firstName, image: headerImage));
    } on Exception catch (e) {
      emit(HeaderDataError(e.toString()));
    }
  }

  // remove profile pic
  Future<void> removeImage(
      ImageRemoved event, Emitter<ProfileState> emit) async {
    await FirebaseService().removeImageField();
    emit(ProfileImageRemoved());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
