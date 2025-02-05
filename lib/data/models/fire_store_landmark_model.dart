import 'package:cloud_firestore/cloud_firestore.dart';

class FSLandMark {
  String? id;
  List<String> imgUrls;
  String name;
  String governorate;
  double rate;
  String description;
  GeoPoint location;
  bool isFav;

  FSLandMark({
    this.id,
    required this.imgUrls,
    required this.name,
    required this.governorate,
    required this.rate,
    required this.description,
    required this.location,
    this.isFav = false,
  });

  factory FSLandMark.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FSLandMark(
      id: doc.id,
      imgUrls: List<String>.from(data['imgUrls']),
      name: data['name'],
      governorate: data['governorate'],
      rate: data['rate'],
      description: data['description'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        'imgUrls': imgUrls,
        'name': name,
        'governorate': governorate,
        'rate': rate,
        'description': description,
        'location': location,
      };
}
