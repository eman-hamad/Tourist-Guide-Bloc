import 'package:flutter/cupertino.dart';
import 'package:tourist_guide/data/models/governorate_model.dart';

class GovernorateData {
  static List<Governorate> governorateList = [
    Governorate(
        imgPath: [Image.asset('assets/images/pyramids3.jpg')], name: 'Giza'),
    Governorate(
        imgPath: [Image.asset('assets/images/GrandMuseum.jpg')], name: 'Cairo'),
    Governorate(
        imgPath: [Image.asset('assets/images/Karnak.jpg')], name: 'Luxor'),
    Governorate(
        imgPath: [Image.asset('assets/images/minya1.jpg')], name: 'Minya')
  ];
}
