import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/favorite_button.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

class CoverImg extends StatelessWidget {
  final FSLandMark landMark;
  const CoverImg({super.key, required this.landMark});

  // Widget to display the cover image with a back button and favorite button.
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        SizedBox(
          height: 400.h,
          child: CarouselSlider.builder(
            itemCount: landMark.imgUrls.length,
            itemBuilder: (context, index, realIndex) => ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: 400.h,
                width: double.infinity,
                imageUrl: landMark.imgUrls[index],
                placeholder: (context, url) => Skeletonizer(
                  enabled: true,
                  child: Container(
                    color: Colors.grey[500],
                    height: 400,
                    width: double.infinity,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              viewportFraction: 1,
              height: 400.h,
            ),
          ),
        ),
        _backBtn(context,
            isDarkMode), // Back button to navigate to the previous screen.
        Positioned(
          right: 15,
          bottom: 10,
          child: FavoriteButton(place: landMark),
        ),
      ],
    );
  }

  Widget _backBtn(BuildContext context, isDarkMode) {
    return Card(
      color: isDarkMode ? kBlack : kWhite,
      margin: REdgeInsets.all(12),
      child: SizedBox(
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: isDarkMode ? kWhite : kBlack,
        ),
      ),
    );
  }
}
