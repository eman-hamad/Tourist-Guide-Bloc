import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_btn_bloc/fav_btn_bloc.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/data/models/fire_store_landmark_model.dart';

class FavoriteButton extends StatelessWidget {
  final FSLandMark place;

  const FavoriteButton({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipOval(
          child: Container(
            width: 0.05.sh,
            height: 0.05.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: kWhite,
            ),
            child: Center(
              child: BlocBuilder<FavBloc, FavState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      place.isFav ? Icons.favorite : Icons.favorite_border,
                      size: 0.025.sh,
                    ),
                    color: kMainColor,
                    onPressed: () {
                      context.read<FavBloc>().add(
                            ToggleFavoriteEvent(placeId: place.id!),
                          );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
