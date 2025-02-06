import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/bloc/details_screen/details_screen_cubit.dart';
import 'package:tourist_guide/bloc/details_screen/nearbyPlacesCubit/nearby_places_cubit.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:tourist_guide/ui/landmarks/details/widgets/cover_img.dart';
import 'package:tourist_guide/ui/landmarks/details/widgets/detailsBar.dart';
import 'package:tourist_guide/ui/landmarks/details/widgets/maps_widget.dart';

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
        BlocProvider(create: (_) => FavBloc()),
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
                _buildAnimatedCoverImage(landMark),
                SizedBox(height: 16.h),
                _buildAnimatedDetails(landMark),
                SizedBox(height: 16.h),
                _buildAnimatedDescription(landMark, isDarkMode),
                SizedBox(height: 16.h),
                _buildAnimatedMaps(landMark, isDarkMode),
                _buildNearbyPlaces(landMark, isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCoverImage(FSLandMark landMark) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showFirst ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: CoverImg(landMark: landMark),
        );
      },
    );
  }

  Widget _buildAnimatedDetails(FSLandMark landMark) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showSecond ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: PlaceDetails(
            name: landMark.name,
            gov: landMark.governorate,
            rate: landMark.rate,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedMaps(FSLandMark landMark, bool isDarkMode) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showFourth ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: MapsWidget(
            landmMark: landMark,
            isDarkMode: isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDescription(FSLandMark landMark, bool isDarkMode) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showThird ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Container(
            height: 250.h,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.w,
                    color: isDarkMode ? kMainColorDark : kMainColor),
                borderRadius: BorderRadius.circular(20.r)),
            child: SingleChildScrollView(
              child: Text(
                textAlign: TextAlign.center,
                landMark.description,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearbyPlaces(FSLandMark landMark, isDarkMode) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        if (!state.showFifth) return const SizedBox.shrink();

        return AnimatedOpacity(
          opacity: state.showFourth ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 30.h),
              Text(
                'Nearby Places',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? kMainColorDark : kMainColor,
                ),
              ),
              SizedBox(height: 5.h),
              SizedBox(
                height: 250.h,
                child: BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
                    builder: (context, state) {
                  if (state is NearbyPlacesLoaded) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.nearbyPlaces.length,
                      itemBuilder: (context, index) {
                        return LandmarkCard(place: state.nearbyPlaces[index]);
                      },
                    );
                  }
                  if (state is NearbyPlacesError) {
                    return Text(state.errorMsg);
                  }

                  return Skeletonizer(
                      child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: 200,
                  ));
                }),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
