import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/governorate_card.dart';
import 'package:tourist_guide/data/places_data/governorate_data.dart';

class GovernorateScreen extends StatelessWidget {
  const GovernorateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: REdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Text(
              'Governorates',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? kWhite : kBlack,
              ),
            ),
            SizedBox(height: 0.02.sh),
            Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: GovernorateData.governorateList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) => GovernorateCard(
                        governorate: GovernorateData.governorateList[index],
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
