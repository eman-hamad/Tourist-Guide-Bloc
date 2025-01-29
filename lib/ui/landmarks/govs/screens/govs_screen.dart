import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_guide/bloc/data_blocs/gov_screen/gov_screen_cubit.dart';
import 'package:tourist_guide/data/models/fire_store_goverorate_model.dart';
import 'package:tourist_guide/ui/landmarks/common/header.dart';
import 'package:tourist_guide/ui/landmarks/govs/widgets/govs_grid.dart';

class GovernorateScreen extends StatelessWidget {
  const GovernorateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: 'Governorates'),
        BlocBuilder<GovScreenCubit, GovScreenState>(
          builder: (context, state) {
            if (state is GovScreenLoading) {
              return GovsGrid(
                loading: true,
                itemCount: 6,
                govs: List.filled(6, _dummyData),
              );
            } //
            else if (state is GovScreenLoaded) {
              return GovsGrid(
                loading: false,
                itemCount: state.govs.length,
                govs: state.govs,
              );
            } //
            else if (state is GovScreenError) {
              return Center(child: Text(state.errorMsg));
            } //
            return Center(child: Text('Error'));
          },
        ),
      ],
    );
  }

  static final _dummyData = GovernorateModel(
    name: 'Cairo',
    placesIds: [],
    coverImgUrl:
        'https://drive.google.com/uc?id=1pVNGXFANQGB_DnXsmfgnxbP6aZobXtsi',
  );
}
