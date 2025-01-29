import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/data/models/fire_store_user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with email and password
  Future<FSUser?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      // Create user with email and password
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Create FSUser instance
        FSUser fsUser = FSUser(
          uid: user.uid,
          name: name,
          email: email,
          phone: phone,
          favPlacesIds: [],
        );

        // Save user data to Firestore
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .set(fsUser.toFirestore());

        return fsUser;
      }
      return null;
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  // Sign In with email and password
  Future<FSUser?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot doc = await _firestore
            .collection('Users')
            .doc(user.uid)
            .get();

        return FSUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }

  // Get user data
  Future<FSUser?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('Users')
          .doc(uid)
          .get();

      if (doc.exists) {
        return FSUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      rethrow;
    }
  }

  // Update user data
  Future<void> updateUserData(FSUser user) async {
    try {
      await _firestore
          .collection('Users')
          .doc(user.uid)
          .update(user.toFirestore());
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}