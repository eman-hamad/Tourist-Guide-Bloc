import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_guide/data/models/fire_store_goverorate_model.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

class PlacesServices {
  final db = FirebaseFirestore.instance;
  static List<FSLandMark> places = [];

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
}
