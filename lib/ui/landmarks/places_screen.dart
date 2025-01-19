import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/utils/user_manager.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

class PlacesScreen extends StatefulWidget {
  final void Function(int)? onNavigate;
  const PlacesScreen({super.key, this.onNavigate});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String userName = 'User';
  String imgPath = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUserImg();
  }

  void _loadUserName() async {
    userName = await UserManager().loadUserName();
    setState(() {});
  }

  void _loadUserImg() async {
    imgPath = UserManager().getImg();
    setState(() {});
  }

// The main UI of the PlacesScreen is built with padding and two main components:
// the header and body. The header displays a personalized greeting, and the body
// contains two sections for places.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: 1.sh - 75,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [_header(), _body()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return SafeArea(
      child: SizedBox(
        height: 0.07.sh,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $userName 👋',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Discover best places to go to vacation 😍',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: kLightBlack,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                widget.onNavigate!(3);
              },
              child: ClipOval(
                child: Container(
                  height: 0.05.sh,
                  width: 0.05.sh,
                  color: kGrey,
                  child: imgPath != ''
                      ? Image.file(File(imgPath))
                      : Image.asset(
                          'assets/images/card_bg.png',
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Column(
        children: [
          _suggestedPlaces(),
          _popularPlaces(),
        ],
      ),
    );
  }

// GridView of Suggested Places
  Widget _suggestedPlaces() {
    return SizedBox(
      height: 0.53.sh - 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.01.sh),
          Text(
            'Suggested Places',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.01.sh),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: PlacesData().suggestedPlaces().length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) => LandmarkCard(
                place: PlacesData().suggestedPlaces()[index],
              ),
            ),
          ),
        ],
      ),
    );
  }

// List of Popular Places
  Widget _popularPlaces() {
    return SizedBox(
      height: 0.41.sh - 75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.01.sh),
          Text(
            'Popular Places',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 0.01.sh),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PlacesData().popularPlaces().length,
              itemBuilder: (context, index) {
                return LandmarkCard(
                  place: PlacesData().popularPlaces()[index],
                );
              },
            ),
          ),
          SizedBox(height: 0.005.sh),
        ],
      ),
    );
  }
}
