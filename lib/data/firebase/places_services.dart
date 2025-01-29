import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

class PlacesServices {
  final db = FirebaseFirestore.instance;
  List<FSLandMark> places = [];

  Future<List<FSLandMark>> getPlaces() async {
    try {
      return await db.collection('Landmarks').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          places.add(FSLandMark.fromFirestore(doc));
        }
        return places;
      });
    } catch (e) {
      throw e.toString();
    }
  }
}
