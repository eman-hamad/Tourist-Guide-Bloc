import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/profile_bloc/profile_bloc.dart';
import 'package:tourist_guide/core/colors/colors.dart';

// image's profile component
class ProfileImage extends StatelessWidget {
  Widget? img;
  ProfileImage({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          child: InkWell(
            onTap: () {
              // call pickImage from bloc to upload img
              context.read<ProfileBloc>().add(UpdateAvatar());
            },
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60.0.r)),
                  border: Border.all(
                    color: kMainColor,
                    width: 8.w,
                    style: BorderStyle.solid,
                  ),
                ),
                child: img),
          ),
        ),
      ),
    );
  }
}
