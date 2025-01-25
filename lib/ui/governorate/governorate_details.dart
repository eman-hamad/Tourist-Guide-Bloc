import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/landmark_card.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';

class GovernorateDetails extends StatelessWidget {
  static const routeName = '/governate_detials';

  const GovernorateDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    String argument = ModalRoute.of(context)!.settings.arguments as String;
    List<LandMark> landmarks = PlacesData().getGoverLandmarks(argument);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  _backButton(context),
                  Expanded(
                    child: Text(
                      'Land Marks in $argument',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? kWhite : kBlack,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.02.sh),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: landmarks.length,
                  itemBuilder: (context, index) => SizedBox(
                    height: 0.3.sh,
                    child: LandmarkCard(place: landmarks[index]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Image.asset(
        'assets/images/arrowBack.png',
        width: 40.w,
        height: 40.h,
      ),
    );
  }
}
