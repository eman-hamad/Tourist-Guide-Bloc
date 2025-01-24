import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tourist_guide/core/colors/colors.dart';

ThemeData klightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: kWhite,
  textTheme: TextTheme(bodyMedium: TextStyle(color: kBlack)),
  bottomAppBarTheme:
      BottomAppBarTheme(color: const Color.fromARGB(255, 255, 55, 0)),
  iconTheme: const IconThemeData(
    color: kWhite, // Set the default icon color for light theme
    size: 24, // Optional: Set a default icon size
  ),
);
