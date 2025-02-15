import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/features/Home/component/details/bloc/details_screen/details_screen_cubit.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';

class AnimatedDescription extends StatelessWidget {
  final FSLandMark landMark;
  final bool isDarkMode;
  const AnimatedDescription(
      {super.key, required this.landMark, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showThird ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Container(
            height: 250.h,
            padding: REdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.w,
                color: isDarkMode ? kMainColorDark : kMainColor,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: SingleChildScrollView(
              child: Text(
                textAlign: TextAlign.center,
                landMark.description,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
