import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/widgets/landmark_card.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';

class SugPlaces extends StatelessWidget {
  final bool loading;
  final int itemCount;
  final List<FSLandMark> places;
  final bool hasMore;
  final VoidCallback onLoadMore;
  const  SugPlaces({
    super.key,
    required this.loading,
    required this.itemCount,
    required this.places,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.pixels == metrics.maxScrollExtent) {
          onLoadMore();
        }
        return true;
      },
      child: Expanded(
        child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: itemCount + (hasMore ? 1 : 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            return Skeletonizer(
              enabled: loading,
              enableSwitchAnimation: true,
              child: index >= places.length
                  ? Center(child: CircularProgressIndicator())
                  : LandmarkCard(place: places[index]),
            );
          },
        ),
      ),
    );
  }
}
