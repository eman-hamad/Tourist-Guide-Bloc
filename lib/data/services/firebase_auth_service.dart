import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourist_guide/data/models/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> login(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _getUserData(userCredential.user?.uid);
  }

  Future<UserModel?> signup(String email, String password, String name, String phone) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = UserModel(
      id: userCredential.user!.uid,
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    await _firestore.collection('Users').doc(user.id).set(user.toMap());
    return user;
  }

  Future<UserModel?> _getUserData(String? uid) async {
    if (uid == null) return null;
    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(uid).get();
    return userDoc.exists ? UserModel.fromFirestore(userDoc) : null;
  }
}