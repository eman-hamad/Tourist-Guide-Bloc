import 'package:cloud_firestore/cloud_firestore.dart';

class FSUser {
  String uid;
  String name;
  String email;
  String phone;
  List<String>? favPlacesIds;

  FSUser(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phone,
      this.favPlacesIds});

  factory FSUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FSUser(
        uid: doc.id,
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        favPlacesIds: (data['favPlacesIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList());
  }

  Map<String, dynamic> toFirestore() => {
        "Uid": uid,
        "name": name,
        "email": email,
        "phone": phone,
        "favPlacesIds": favPlacesIds
      };
}
