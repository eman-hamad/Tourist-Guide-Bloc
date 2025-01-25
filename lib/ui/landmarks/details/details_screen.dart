import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/details_screen/details_screen_cubit.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';
import 'package:tourist_guide/ui/landmarks/details/widgets/cover_img.dart';
import 'package:tourist_guide/ui/landmarks/details/widgets/desc.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final landMark = ModalRoute.of(context)!.settings.arguments as LandMark;

    return BlocProvider(
      create: (context) => DetailsScreenCubit(),
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
                _buildAnimatedDescription(landMark),
                SizedBox(height: 16.h),
                _buildAnimatedText(landMark),
                _buildNearbyPlaces(landMark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCoverImage(LandMark landMark) {
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

  Widget _buildAnimatedDescription(LandMark landMark) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showSecond ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: PlaceDescription(
            name: landMark.name,
            gov: landMark.governorate,
            rate: landMark.rate,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedText(LandMark landMark) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showThird ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Text(
            textAlign: TextAlign.center,
            landMark.description!,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNearbyPlaces(LandMark landMark) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        if (!state.showFourth) return const SizedBox.shrink();

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
                  color: kMainColor,
                ),
              ),
              SizedBox(height: 5.h),
              SizedBox(
                height: 250.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: PlacesData().nearbyPlaces(landMark).length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 200.w,
                      child: LandmarkCard(
                        place: PlacesData().nearbyPlaces(landMark)[index],
                      ),
                    );
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
