// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class GovernorateModel {
  String? id;
  String name;
  List<String> placesIds;
  String coverImgUrl;

  GovernorateModel({
     this.id,
    required this.name,
    required this.placesIds,
    required this.coverImgUrl,
  });

  factory GovernorateModel.fromfirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return GovernorateModel(
        id: doc.id,
        name: data['name'],
        placesIds: List<String>.from(data['placesIds']),
        coverImgUrl: data['coverImgUrl']);
  }

  Map<String, dynamic> toFirestore() =>
      {'name': name, 'coverImgUrl': coverImgUrl, 'placesIds': placesIds};
}
