import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/custom_page_route.dart';
import 'package:tourist_guide/core/widgets/favorite_button.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/ui/landmarks/details/details_screen.dart';

class LandmarkCard extends StatelessWidget {
  final LandMark place;
  final bool isFavs;

  const LandmarkCard({super.key, required this.place, this.isFavs = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DetailsScreen(landMark: place),
        //     ));
        Navigator.of(context).push(
          CustomPageRoute(
            child: DetailsScreen(
              landMark: place,
            ),
            type: PageTransitionType.slideRight,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOutCubic,
          ),
        );
      },
      child: SizedBox(
        width: ScreenUtil().screenWidth / 2 - 8,
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Stack(
            children: [
              _cardImg(context),
              Padding(
                padding: EdgeInsets.all(10.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FavoriteButton(place: place, isFavs: isFavs),
                    const Expanded(child: SizedBox()),
                    _aboutPlace(
                      place.name,
                      place.governorate,
                      place.rate,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardImg(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image(
        image: place.imgPath[0].image,
        height: 1.sh,
        width: 1.sw,
        fit: BoxFit.cover,
      ),
    );
  }

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
