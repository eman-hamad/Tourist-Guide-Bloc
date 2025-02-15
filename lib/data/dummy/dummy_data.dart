import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fire_store_landmark_model.dart';

final kDummyData = FSLandMark(
  id: '0',
  imgUrls: ['https://drive.google.com/uc?id=1pVNGXFANQGB_DnXsmfgnxbP6aZobXtsi'],
  name: 'Sphinx',
  governorate: 'Giza',
  rate: 5.0,
  // fav: true,
  description: '',
  location: GeoPoint(0, 0),
);
