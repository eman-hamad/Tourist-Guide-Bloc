import 'package:flutter/material.dart';

class LandMark {
  late String id;
  late List<Image> imgPath;
  late String name;
  late String governorate;
  late String rate;
  late bool fav;
  late String? description;
// Constructor to create a Place object from a list of shared preferences data.
  LandMark(
      {required this.id,
      required this.imgPath,
      required this.name,
      required this.governorate,
      required this.rate,
      required this.fav,
      this.description});

// Maps the data fields like name, governorate, rate, and fav from the list.
  LandMark.fromSharedPrefs(List<String> userData) {
    name = userData[0];
    name = userData[0];
    name = userData[1];
    governorate = userData[2];
    rate = userData[3];
    fav = false;
  }
}
