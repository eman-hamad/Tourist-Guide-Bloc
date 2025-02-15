import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors/colors.dart';

ThemeData klightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: kWhite,
  textTheme: TextTheme(
    bodyMedium: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
  ),
  iconTheme: IconThemeData(color: kWhite, size: 24),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: REdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      backgroundColor: kMainColor,
      elevation: 1,
      side: BorderSide(color: kLightBlack, width: 0.5),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: kGrey,
        width: 1.5,
      ),
    ),
    labelStyle: TextStyle(color: kMainColor),
    hintStyle: TextStyle(color: kMainColor.withAlpha(150)),
    prefixIconColor: kMainColor,
  ),
);
