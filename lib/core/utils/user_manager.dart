import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const String kUsersKey = 'users_list';
  static const String kCurrentUserKey = 'current_user';
  static const String kIsLoggedInKey = 'isLoggedIn';

  static late SharedPreferences prefs;
  static const String kFavListKey = 'fav';
  // Initializes the SharedPreferences instance and sets up default values if
  // certain keys don't exist.
  Future<void> init() async {
    debugPrint('=====\nInit\n=====');
    prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('fav')) await prefs.setStringList('fav', []);
  }

  // Get all users
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final usersString = prefs.getString(kUsersKey);
    if (usersString != null) {
      return List<Map<String, dynamic>>.from(json.decode(usersString));
    }
    return [];
  }

  // Get current user
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final userString = prefs.getString(kCurrentUserKey);
    if (userString != null) {
      return json.decode(userString);
    }
    return null;
  }

  // Update user
  static Future<bool> updateUser(Map<String, dynamic> updatedUser) async {
    try {
      List<Map<String, dynamic>> usersList = await getAllUsers();

      final index =
          usersList.indexWhere((user) => user['id'] == updatedUser['id']);
      if (index != -1) {
        usersList[index] = updatedUser;
        await prefs.setString(kUsersKey, json.encode(usersList));

        // Update current user if it's the same user
        final currentUser = await getCurrentUser();
        if (currentUser != null && currentUser['id'] == updatedUser['id']) {
          await prefs.setString(kCurrentUserKey, json.encode(updatedUser));
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating user: $e');
      return false;
    }
  }

  // Delete user
  static Future<bool> deleteUser(String userId) async {
    try {
      List<Map<String, dynamic>> usersList = await getAllUsers();

      usersList.removeWhere((user) => user['id'] == userId);
      await prefs.setString(kUsersKey, json.encode(usersList));

      // Logout if current user is deleted
      final currentUser = await getCurrentUser();
      if (currentUser != null && currentUser['id'] == userId) {
        await logout();
      }
      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }

  // Logout
  static Future<void> logout() async {
    await prefs.remove(kCurrentUserKey);
    await prefs.setBool(kIsLoggedInKey, false);
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await prefs.clear();
  }

// Get first name
  Future<String> loadUserName() async {
    String name = '';
    final userString = prefs.getString('current_user');
    if (userString != null) {
      final userData = json.decode(userString);
      if (userData['name'] != null) {
        name = userData['name'].toString().split(' ')[0];
      }
    }
    return name;
  }

// Saves a list of favorite place IDs to SharedPreferences.
  Future<void> setFavPlacesIds({required List<String> ids}) async {
    await prefs.setStringList(kFavListKey, ids);
  }

// Retrieves the list of favorite place IDs.
  List<String> getFavPlacesIds() {
    return prefs.getStringList(kFavListKey)!;
  }

// Get User Image
  String getImg() {
    final imagePath = prefs.getString('img');
    if (imagePath != null) {
      return imagePath;
    }
    return '';
  }
}
