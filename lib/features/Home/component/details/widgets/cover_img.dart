import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/colors/colors.dart';
import '../../../../../core/widgets/favorite_button.dart';
import '../../../../../data/models/fire_store_landmark_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/details_screen/details_screen_cubit.dart';

class AnimatedCoverImage extends StatelessWidget {
  final FSLandMark landMark;
  const AnimatedCoverImage({super.key, required this.landMark});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DetailsScreenCubit, DetailsScreenState>(
      builder: (context, state) {
        return AnimatedOpacity(
          opacity: state.showFirst ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
          child: Stack(
            children: [
              SizedBox(
                height: 400.h,
                child: CarouselSlider.builder(
                  itemCount: landMark.imgUrls.length,
                  itemBuilder: (context, index, realIndex) => ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      height: 400.h,
                      width: double.infinity,
                      imageUrl: landMark.imgUrls[index],
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: Container(
                          color: Colors.grey[500],
                          height: 400,
                          width: double.infinity,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    viewportFraction: 1,
                    height: 400.h,
                  ),
                ),
              ),
              _backBtn(context, isDarkMode),
              Positioned(
                right: 15,
                bottom: 10,
                child: FavoriteButton(place: landMark),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _backBtn(BuildContext context, bool isDarkMode) {
    return Card(
      color: isDarkMode ? kBlack : kWhite,
      margin: REdgeInsets.all(12),
      child: SizedBox(
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: isDarkMode ? kWhite : kBlack,
        ),
      ),
    );
  }
}
