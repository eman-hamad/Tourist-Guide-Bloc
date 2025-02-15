import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/colors/colors.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final bool showBackBtn;
  const CommonHeader({super.key, required this.title, this.showBackBtn = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Card(
      color: isDarkMode ? kMainColorDark : kMainColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: SizedBox(
        height: 50.h + statusBarHeight,
        child: Column(
          children: [
            SizedBox(height: statusBarHeight),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showBackBtn ? _backBtn(context) : SizedBox(),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backBtn(BuildContext context) {
    return Card(
      margin: REdgeInsets.only(left: 8),
      child: SizedBox(
        width: 35.w,
        height: 35.h,
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: kBlack, size: 20.sp),
        ),
      ),
    );
  }
}
