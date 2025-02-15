import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/firebase_auth_services.dart';
import '../models/fire_store_goverorate_model.dart';
import '../models/fire_store_landmark_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/fire_store_user_model.dart';

class PlacesServices {
  final db = FirebaseFirestore.instance;
  static List<FSLandMark> places = [];
  static List<FSLandMark> placesWithFav = [];

  Future<List<FSLandMark>> getPlaces() async {
    try {
      // Get user doc
      String uId = FirebaseAuth.instance.currentUser!.uid;

      // Get favIds list
      final ids = await db.collection('Users').doc(uId).get().then((snapshot) {
        return FSUser.fromFirestore(snapshot).favPlacesIds;
      });

      places.clear();

      return await db.collection('Landmarks').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          var place = FSLandMark.fromFirestore(doc);
          ids!.contains(place.id) ? place.isFav = true : false;
          places.add(place);
        }

        return places;
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<GovernorateModel>> getGovs() async {
    List<GovernorateModel> govs = [];
    try {
      return await db.collection('Governorates').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          govs.add(GovernorateModel.fromfirestore(doc));
        }
        return govs;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<FSLandMark>> getNearbyPlaces(
      {required FSLandMark landmark}) async {
    List<FSLandMark> nearbyPlaces = [];
    try {
      return await FirebaseFirestore.instance
          .collection('Landmarks')
          .where('governorate', isEqualTo: landmark.governorate)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          if (FSLandMark.fromFirestore(doc).name != landmark.name) {
            nearbyPlaces.add(FSLandMark.fromFirestore(doc));
          }
        }
        return nearbyPlaces;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<FSLandMark>> favPlaces() async {
    // Get user doc
    String uId = FirebaseAuth.instance.currentUser!.uid;

    // Get favIds list
    final ids = await db.collection('Users').doc(uId).get().then((snapshot) {
      return FSUser.fromFirestore(snapshot).favPlacesIds;
    });

    placesWithFav = places.where(
      (place) {
        place.isFav = true;
        return ids!.contains(place.id);
      },
    ).toList();

    placesWithFav = removeDuplicatesByKey(placesWithFav, (place) => place.id);

    return placesWithFav;
  }

  List<T> removeDuplicatesByKey<T, K>(List<T> list, K Function(T) getKey) {
    final seen = <K>{};
    return list.where((item) => seen.add(getKey(item))).toList();
  }

  Future<bool> updateFavPlaces(String favId) async {
    try {
      // Get the list of favorite places ids
      final ids = FirebaseService.cUser!.favPlacesIds!;

      // Check if ids contains the current id
      final isFav = ids.contains(favId);

      // If current id exists, remove it. Otherwise add it
      isFav ? ids.remove(favId) : ids.add(favId);

      // Update the fav ids list in user document
      await db.collection('Users').doc(FirebaseService.cUser!.uid).update(
        {'favPlacesIds': ids},
      );

      // Update places list
      for (var place in places) {
        if (place.id == favId) {
          place.isFav = !isFav;
        }
      }

      return !isFav;
    } catch (e) {
      throw 'Error updating user data: $e';
    }
  }
}
