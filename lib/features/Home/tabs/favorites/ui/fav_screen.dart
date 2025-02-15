import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/dummy/dummy_data.dart';
import '../bloc/fav_screen_cubit.dart';
import '../widgets/empty_favs.dart';
import '../widgets/favs_list.dart';
import '../../../widgets/common_header.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonHeader(title: 'Favorite Places'),
        BlocBuilder<FavScreenCubit, FavScreenState>(
          builder: (context, state) {
            if (state is FavScreenLoading) {
              return FavsList(
                loading: true,
                itemsCount: 4,
                places: List.filled(4, kDummyData),
              );
            } else if (state is FavScreenLoaded) {
              return state.favs.isEmpty
                  ? const EmptyFavs()
                  : FavsList(
                      loading: false,
                      itemsCount: state.favs.length,
                      places: state.favs,
                    );
            } else if (state is FavScreenError) {
              return Center(child: Text(state.errorMsg));
            }
            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
