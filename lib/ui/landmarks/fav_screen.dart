import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // List of favorite landmarks retrieved from PlacesData
  List<LandMark> favList = PlacesData().favoritePlaces();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        // Checks if the favorite places list is empty
        body: PlacesData().favoritePlaces().isEmpty
            ? _noFav(isDarkMode) // Display placeholder if no favorites
            : SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        "Favorite Places",
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? kWhite : kBlack),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.r),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: PlacesData().favoritePlaces().length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0 ? 10.w : 0, right: 10.w),
                              child: SizedBox(
                                width: 0.85.sw,
                                // Displays each favorite place using LandmarkCard
                                child: LandmarkCard(
                                  place: favList[index],
                                  // Refreshes the list of favorite places when a change is made
                                  refresh: () => setState(() {
                                    favList = PlacesData().favoritePlaces();
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Widget displayed when there are no favorite places
  Widget _noFav(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            color:
                isDarkMode ? kMainColorDark : Color.fromARGB(170, 222, 114, 84),
            size: 150,
          ),
          Text(
            "Add Your Favorite Places",
            style: TextStyle(
              color: isDarkMode ? kDarkTexe : Color.fromARGB(170, 222, 114, 84),
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
            ),
          )
        ],
      ),
    );
  }
}
