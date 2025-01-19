import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

// ignore: must_be_immutable
class FavoriteButton extends StatefulWidget {
  LandMark place;
  final VoidCallback? refresh;
  FavoriteButton({super.key, required this.place, this.refresh});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

// Displays the favorite icon, allowing users to mark/unmark a place as a favorite.
// Updates the favorite status both in the local list and in shared preferences.
class _FavoriteButtonState extends State<FavoriteButton> {
  List<String> favPlaces = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipOval(
          child: Container(
            width: 0.05.sh,
            height: 0.05.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: kWhite,
            ),
            child: Center(
              child: IconButton(
                icon: Icon(
                  widget.place.fav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 0.025.sh,
                ),
                color: kMainColor,
                onPressed: () {
                  // Id of current place
                  int id = int.parse(widget.place.id);
                  // Change value of fav from kLandmarks list
                  PlacesData.kLandmarks[id].fav = !widget.place.fav;
                  // Get the Ids of fav places from shared prefs
                  // and put them in favPlaces
                  favPlaces = UserManager().getFavPlaces();
                  // Update the favPlaces by add or remove a place
                  PlacesData.kLandmarks[id].fav
                      ? favPlaces.add(widget.place.id)
                      : favPlaces.remove(widget.place.id);
                  // Save the favPlaces after update
                  UserManager().setFavPlaces(ids: favPlaces);
                  // Check if this update comming from FavoritesScreen,
                  // if yes, then update the list

                  setState(() {});
                  if (widget.refresh != null) {
                    widget.refresh!();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
