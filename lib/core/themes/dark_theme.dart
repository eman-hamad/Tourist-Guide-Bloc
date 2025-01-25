import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

ThemeData kDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: kDarkBody,
  textTheme: TextTheme(bodyMedium: TextStyle(color: kDarkTexe)),
  iconTheme: IconThemeData(color: kWhite, size: 24),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: REdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      backgroundColor: kMainColorDark,
      elevation: 1,
      side: BorderSide(color: kGrey, width: 0.5),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kDarkBody,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: kDarkTexe,
        width: 1.5,
      ),
    ),
    labelStyle: TextStyle(color: kMainColorDark),
    hintStyle: TextStyle(color: kMainColorDark.withAlpha(150)),
    prefixIconColor: kMainColorDark,
  ),
  cardColor: kMainColorDark,
);
