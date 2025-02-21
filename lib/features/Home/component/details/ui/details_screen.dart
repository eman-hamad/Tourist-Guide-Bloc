import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/nearby_places.dart';
import '../widgets/place_description.dart';

import '../../../../../data/models/fire_store_landmark_model.dart';
import '../../fav_btn_bloc/fav_btn_bloc.dart';
import '../bloc/details_screen/details_screen_cubit.dart';
import '../bloc/nearbyPlacesCubit/nearby_places_cubit.dart';
import '../widgets/cover_img.dart';
import '../widgets/details_bar.dart';
import '../widgets/maps_widget.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  FSLandMark landMark;
  DetailsScreen({super.key, required this.landMark});

  @override
  Widget build(BuildContext context) {
    //check the theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavBloc.getInstance()),
        BlocProvider(
          create: (context) => DetailsScreenCubit(),
        ),
        BlocProvider(
          create: (context) =>
              NearbyPlacesCubit()..getNearbyPlaces(landamark: landMark),
        )
      ],
      child: Scaffold(
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                AnimatedCoverImage(
                  landMark: landMark,
                ),
                SizedBox(height: 16.h),
                AnimatedDetails(
                  landMark: landMark,
                ),
                SizedBox(height: 16.h),
                AnimatedDescription(landMark: landMark, isDarkMode: isDarkMode),
                SizedBox(height: 16.h),
                AnimatedMaps(landMark: landMark, isDarkMode: isDarkMode),
                AnimatedNearbyPlaces(landMark: landMark, isDarkMode: isDarkMode)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
