import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';

class FavsList extends StatelessWidget {
  final bool loading;
  final int itemsCount;
  final List<FSLandMark> places;
  const FavsList({
    super.key,
    required this.places,
    required this.loading,
    required this.itemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemsCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: REdgeInsets.only(
              top: 10,
              bottom: 10,
              left: index == 0 ? 10.w : 0,
              right: 10.w,
            ),
            child: Skeletonizer(
              enabled: loading,
              enableSwitchAnimation: loading,
              child: SizedBox(
                  width: 0.85.sw,
                  child: LandmarkCard(place: places[index]),
                  ),
            ),
          );
        },
      ),
    );
  }
}
