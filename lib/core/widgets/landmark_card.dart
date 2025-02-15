import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/features/Home/component/details/ui/details_screen.dart';
import '../colors/colors.dart';
import 'custom_page_route.dart';
import 'favorite_button.dart';
import '../../data/models/fire_store_landmark_model.dart';

class LandmarkCard extends StatelessWidget {
  final FSLandMark place;

  const LandmarkCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                    FavoriteButton(place: place),
                    const Expanded(child: SizedBox()),
                    _aboutPlace(
                      place.name,
                      place.governorate,
                      place.rate.toString(),
                      context,
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
      child: CachedNetworkImage(
        imageUrl: place.imgUrls[0],
        placeholder: (context, url) => Center(
          child: Skeletonizer(
              child: Container(
            color: Colors.grey[700],
            width: 1.sw,
            height: 1.sh,
          )),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 1.sh,
        width: 1.sw,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _aboutPlace(
      String name, String gov, String rate, BuildContext context) {
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
                  color: kBlack),
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
