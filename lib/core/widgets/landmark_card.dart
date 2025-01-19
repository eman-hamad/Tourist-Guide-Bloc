import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/favoriteButton.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';

class LandmarkCard extends StatefulWidget {
  final LandMark place;
  final VoidCallback? refresh;

  const LandmarkCard({super.key, required this.place, this.refresh});

  @override
  State<LandmarkCard> createState() => _LandmarkCardState();
}

class _LandmarkCardState extends State<LandmarkCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth / 2 - 8,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Stack(
          children: [
            _cardImg(),
            Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FavoriteButton(place: widget.place, refresh: widget.refresh),
                  const Expanded(child: SizedBox()),
                  _aboutPlace(
                    widget.place.name,
                    widget.place.governorate,
                    widget.place.rate,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// Displays the image of the place inside a ClipRRect widget with a rounded border.
// Tapping on the image navigates to the place details page.
  Widget _cardImg() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/details',
            arguments: {'landMark': widget.place});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: widget.place.imgPath[0].image,
          height: 1.sh,
          width: 1.sw,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Displays the name, governorate, and rating of the place in a card format,
// with appropriate icons for location and rating.
  Widget _aboutPlace(String name, String gov, String rate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 0.09.sh,
        width: ScreenUtil().screenWidth - 12,
        decoration: detailsBoxTheme(15),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        color: kLightBlack,
                        size: 0.020.sh,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          gov,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: kLightBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: kLightBlack,
                      size: 0.020.sh,
                      // 18,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      rate,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: kLightBlack,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration detailsBoxTheme(double borderRadius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: kWhite,
    );
  }
}
