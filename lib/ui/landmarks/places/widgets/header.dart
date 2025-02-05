import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/home_cubit/home_cubit.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class Header extends StatelessWidget {
  final String name;
  final Uint8List? imgPath;
  const Header({super.key, required this.name, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 0.07.sh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $name 👋',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? kGrey : kBlack,
                ),
              ),
              Text(
                'Discover best places to go to vacation 😍',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDarkMode
                      ? const Color.fromARGB(116, 250, 250, 250)
                      : kLightBlack,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.read<HomeCubit>().navigateToPage(3),
            child: ClipOval(
              child: Container(
                height: 0.05.sh,
                width: 0.05.sh,
                color: kGrey,
                child: imgPath != null
                    ? Image.memory(
                        imgPath!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        'assets/images/card_bg.png',
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
