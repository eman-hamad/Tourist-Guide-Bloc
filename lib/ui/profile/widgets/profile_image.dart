import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/utils/profile_manager.dart';

// profile image component
class ProfileImage extends StatelessWidget {
  ImageProvider<Object>? img;
  ProfileImage({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          child: InkWell(
            onTap: () {
              // call updateAvatar from bloc to upload img
              ProfileManager().uploadImage(context);
            },
            child: Container(
                color: isDarkMode ? kDarkBody : kWhite,
                child: CircleAvatar(radius: 50.r, backgroundImage: img)),
          ),
        ),
      ),
    );
  }
}
