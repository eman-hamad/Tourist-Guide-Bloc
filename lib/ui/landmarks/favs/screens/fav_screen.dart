import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/fav_screen_cubit/fav_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/data/places_data/places_data.dart';
import 'package:tourist_guide/ui/landmarks/common/header.dart';
import 'package:tourist_guide/ui/landmarks/favs/widgets/empty_favs.dart';
import 'package:tourist_guide/ui/landmarks/favs/widgets/favs_list.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<FavScreenCubit>().loadFavorites();

    return Column(
      children: [
        Header(title: 'Favorite Places'),
        // BlocBuilder<FavScreenCubit, FavScreenState>(
        //   builder: (context, state) {
        //     if (state is FavScreenLoading) {
        //       return FavsList(
        //         loading: true,
        //         itemsCount: 4,
        //         places: List.filled(4, PlacesData.kDummyData),
        //       );
        //     } //
        //     else if (state is FavScreenLoaded) {
        //       return state.favs.isEmpty
        //           ? const EmptyFavs()
        //           : FavsList(
        //               loading: false,
        //               itemsCount: state.favs.length,
        //               places: state.favs,
        //             );
        //     } //
        //     else if (state is FavScreenError) {
        //       return Center(child: Text(state.errorMsg));
        //     }
        //     return const SizedBox.shrink();
        //   },
        // )
      ],
    );
  }
}
