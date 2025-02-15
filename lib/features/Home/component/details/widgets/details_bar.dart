import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';
import '../bloc/details_screen/details_screen_cubit.dart';
import '../../../../../core/colors/colors.dart';

class AnimatedDetails extends StatelessWidget {
  final FSLandMark landMark;
  const AnimatedDetails({super.key, required this.landMark});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showSecond ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    landMark.name,
                    style:
                        TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.place,
                      color: isDarkMode ? kMainColorDark : kMainColor),
                  Text(
                    landMark.governorate,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: isDarkMode ? kMainColorDark : kMainColor),
                  ),
                  Spacer(),
                  Icon(Icons.star,
                      color: isDarkMode ? kMainColorDark : kMainColor,
                      size: 30),
                  Text(
                    landMark.rate.toString(),
                    style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: isDarkMode ? kDarkTexe : kBlack),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
