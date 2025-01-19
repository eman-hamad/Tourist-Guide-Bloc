// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/favoriteButton.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  //using singleTricler because using  one animation controller.
  late final AnimationController
      _controller; // Controller for managing animations.
  late final List<Animation<double>>
      _fadeAnimations; // Fade animations for various elements.

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 5 seconds.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Create staggered fade animations..
    _fadeAnimations = List.generate(
      4,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.25,
            (index + 1) * 0.25,
            curve: Curves.easeIn,
          ),
        ),
      ),
    );

    // Start the animations.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    LandMark landMark = arguments["landMark"];

    return Scaffold(
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              FadeTransition(
                opacity: _fadeAnimations[0],
                child: _coverImage(context, landMark), // Cover image widget
              ),
              SizedBox(height: 16.h),
              FadeTransition(
                opacity: _fadeAnimations[1],
                child: _placeDetails(landMark), // Landmark details section
              ),
              SizedBox(height: 16.h),
              FadeTransition(
                opacity: _fadeAnimations[2],
                child: Text(
                  textAlign: TextAlign.center,
                  landMark.description!,
                  overflow: TextOverflow.fade,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                ),
              ),
              // Check if there are nearby places and display them if available.
              PlacesData().nearbyPlaces(landMark).isNotEmpty
                  ? FadeTransition(
                      opacity: _fadeAnimations[3],
                      child: _similiarPlaces(landMark),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display landmark details like name, location, and rating.
  Widget _placeDetails(LandMark landMark) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              landMark.name,
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.place, color: kMainColor),
            Text(
              landMark.governorate,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: kMainColor),
            ),
            Spacer(),
            Icon(Icons.star, color: kMainColor, size: 30),
            Text(
              landMark.rate,
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

  // Widget to display the cover image with a back button and favorite button.
  Widget _coverImage(BuildContext context, LandMark landMark) {
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
        _backButton(context), // Back button to navigate to the previous screen.
        Positioned(
          right: 15,
          bottom: 10,
          child: FavoriteButton(
            place: landMark,
            refresh: () => setState(() {}),
          ),
        ),
      ],
    );
  }

  // Widget for a back button.
  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Image.asset(
        'assets/images/arrowBack.png',
        width: 100.w,
        height: 100.h,
      ),
    );
  }

  // Widget to display similar places in a horizontal list.
  Widget _similiarPlaces(LandMark landmark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 30.h),
        Text(
          'Nearby Places',
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: kMainColor),
        ),
        SizedBox(height: 5),
        SizedBox(
          height: 250.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: PlacesData().nearbyPlaces(landmark).length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 200.w,
                child: LandmarkCard(
                  place: PlacesData().nearbyPlaces(landmark)[index],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
