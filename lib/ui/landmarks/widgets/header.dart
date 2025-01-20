import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class Header extends StatelessWidget {
  final String name;
  final String imgPath;
  const Header({super.key, required this.name, required this.imgPath});

  @override
  Widget build(BuildContext context) {
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
                'Hi,  👋',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Discover best places to go to vacation 😍',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: kLightBlack,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // widget.onNavigate!(3);
            },
            child: ClipOval(
              child: Container(
                height: 0.05.sh,
                width: 0.05.sh,
                color: kGrey,
                child: imgPath != ''
                    ? Image.file(File(imgPath))
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
