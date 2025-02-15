// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

class MapsWidget extends StatelessWidget {
  final FSLandMark landmMark;
  bool isDarkMode;
  MapsWidget({super.key, required this.landmMark, required this.isDarkMode});

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 2, color: isDarkMode ? kMainColorDark : kMainColor)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GoogleMap(
          markers: {
            Marker(
                markerId: MarkerId("landmark Location"),
                position: LatLng(
                    landmMark.location.latitude, landmMark.location.longitude),
                infoWindow: InfoWindow(title: landmMark.name))
          },
          mapType: MapType.satellite,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                landmMark.location.latitude, landmMark.location.longitude),
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
