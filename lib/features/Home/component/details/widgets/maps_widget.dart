// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:tourist_guide/features/Home/component/details/bloc/details_screen/details_screen_cubit.dart';

class AnimatedMaps extends StatelessWidget {
  final FSLandMark landMark;
  final bool isDarkMode;
  const AnimatedMaps(
      {super.key, required this.landMark, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showFourth ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2,
                color: isDarkMode ? kMainColorDark : kMainColor,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                markers: {
                  Marker(
                    markerId: MarkerId("landmark Location"),
                    position: LatLng(landMark.location.latitude,
                        landMark.location.longitude),
                    infoWindow: InfoWindow(title: landMark.name),
                  )
                },
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      landMark.location.latitude, landMark.location.longitude),
                  zoom: 14.4746,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
