import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class PlaceDetails extends StatelessWidget {
  final String name;
  final String gov;
  final double rate;
  const PlaceDetails({
    super.key,
    required this.name,
    required this.gov,
    required this.rate,
  });

  // Widget to display landmark details like name, location, and rating.
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            Icon(Icons.place, color: isDarkMode ? kMainColorDark : kMainColor),
            Text(
              gov,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: isDarkMode ? kMainColorDark : kMainColor),
            ),
            Spacer(),
            Icon(Icons.star,
                color: isDarkMode ? kMainColorDark : kMainColor, size: 30),
            Text(
              rate.toString(),
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDarkMode ? kDarkTexe : kBlack),
            ),
          ],
        ),
      ],
    );
  }
}
