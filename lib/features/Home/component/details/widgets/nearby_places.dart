import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/features/Home/component/details/bloc/nearbyPlacesCubit/nearby_places_cubit.dart';

import '../../../../../core/../../../core/colors/colors.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';
import '../bloc/details_screen/details_screen_cubit.dart';

class AnimatedNearbyPlaces extends StatelessWidget {
  final FSLandMark landMark;
  final bool isDarkMode;
  const AnimatedNearbyPlaces(
      {super.key, required this.landMark, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
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
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10),
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
                    return Skeletonizer(child: Container(width: 200));
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
}
