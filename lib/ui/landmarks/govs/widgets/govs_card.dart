import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class GovernorateCard extends StatelessWidget {
  final Map<String, dynamic> gov;
  const GovernorateCard({super.key, required this.gov});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth / 2 - 8,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Stack(
          children: [
            _cardImg(context, gov['name']),
            _aboutGov(gov['name']),
          ],
        ),
      ),
    );
  }

// Displays the image of the place inside a ClipRRect widget with a rounded border.
  Widget _cardImg(BuildContext context, String govName) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/governate_detials', arguments: govName);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: gov['img'].image,
          height: 1.sh,
          width: 1.sw,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Displays governorate
  Widget _aboutGov(String name) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: 110.w,
        height: 30.h,
        margin: EdgeInsets.all(10.0.r),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.place_rounded,
                color: kLightBlack,
                size: 0.020.sh,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
