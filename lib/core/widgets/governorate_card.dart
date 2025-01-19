import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/data/models/governorate_model.dart';
import 'package:tourist_guide/data/models/landmark_model.dart';

class GovernorateCard extends StatefulWidget {
  final Governorate governorate;
  final Function(LandMark)? onRemove;
  const GovernorateCard({
    super.key,
    required this.governorate,
    this.onRemove,
  });

  @override
  State<GovernorateCard> createState() => _GovernorateCardState();
}

class _GovernorateCardState extends State<GovernorateCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth / 2 - 8,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Stack(
          children: [
            _cardImg(widget.governorate.name),
            Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: SizedBox()),
                  _aboutGov(
                    widget.governorate.name,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

// Displays the image of the place inside a ClipRRect widget with a rounded border.
// Tapping on the image navigates to the place details page.
  Widget _cardImg(String govName) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/governate_detials', arguments: govName);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          image: widget.governorate.imgPath[0].image,
          height: 1.sh,
          width: 1.sw,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Displays governorate
  Widget _aboutGov(
    String name,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 0.3.sw,
        height: 0.04.sh,
        decoration: detailsBoxTheme(15),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.place_rounded,
              color: kLightBlack,
              size: 0.020.sh,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration detailsBoxTheme(double borderRadius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: kWhite,
    );
  }
}
