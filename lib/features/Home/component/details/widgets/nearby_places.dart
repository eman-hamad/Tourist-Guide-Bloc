import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';
import '../bloc/nearbyPlacesCubit/nearby_places_cubit.dart';

class AnimatedNearbyPlaces extends StatelessWidget {
  final FSLandMark landMark;
  final bool isDarkMode;
  const AnimatedNearbyPlaces(
      {super.key, required this.landMark, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyPlacesCubit, NearbyPlacesState>(
      builder: (context, state) {
        if (state is NearbyPlacesLoading) {
          return SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is NearbyPlacesError) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                state.errorMsg,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        if (state is NearbyPlacesLoaded) {
          return SizedBox(
            height: 250,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.nearbyPlaces.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200,
                  child: LandmarkCard(place: state.nearbyPlaces[index]),
                );
              },
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
