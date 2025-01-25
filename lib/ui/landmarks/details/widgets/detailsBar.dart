import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class PlaceDetails extends StatelessWidget {
  final String name;
  final String gov;
  final String rate;
  const PlaceDetails({
    super.key,
    required this.name,
    required this.gov,
    required this.rate,
  });

  // Widget to display landmark details like name, location, and rating.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.place, color: kMainColor),
            Text(
              gov,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: kMainColor),
            ),
            Spacer(),
            Icon(Icons.star, color: kMainColor, size: 30),
            Text(
              rate,
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }
}
