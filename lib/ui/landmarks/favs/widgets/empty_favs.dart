import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/home_cubit/home_cubit.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class EmptyFavs extends StatelessWidget {
  const EmptyFavs({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline_rounded,
            color: kMainColor,
            size: 80.h,
          ),
          SizedBox(height: 0.02.sh),
          GestureDetector(
            onTap: () => context.read<HomeCubit>().navigateToPage(0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Your Favorite List is Empty! "),
                  TextSpan(
                    text: "Explore Places",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }
}
