import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/widgets/landmark_card.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';

class PopPlaces extends StatelessWidget {
  final bool loading;
  final int itemCount;
  final List<FSLandMark> places;
  const PopPlaces({
    super.key,
    required this.loading,
    required this.itemCount,
    required this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => Skeletonizer(
          enabled: loading,
          enableSwitchAnimation: true,
          child: LandmarkCard(place: places[index]),
        ),
      ),
    );
  }
}
