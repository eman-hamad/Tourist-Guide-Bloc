import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/widgets/favorite_button.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';

class CoverImg extends StatelessWidget {
  final LandMark landMark;
  const CoverImg({super.key, required this.landMark});

  // Widget to display the cover image with a back button and favorite button.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400.h,
          child: CarouselSlider.builder(
            itemCount: landMark.imgPath.length,
            itemBuilder: (context, index, realIndex) => ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: Image(
                image: landMark.imgPath[index].image,
                fit: BoxFit.cover,
                height: 400.h,
                width: double.infinity,
              ),
            ),
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 1,
              height: 400.h,
            ),
          ),
        ),
        _backBtn(context), // Back button to navigate to the previous screen.
        Positioned(
          right: 15,
          bottom: 10,
          child: FavoriteButton(place: landMark),
        ),
      ],
    );
  }

  Widget _backBtn(BuildContext context) {
    return Card(
      margin: REdgeInsets.all(12),
      child: SizedBox(
        width: 35.w,
        height: 35.h,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
    );
  }
}
