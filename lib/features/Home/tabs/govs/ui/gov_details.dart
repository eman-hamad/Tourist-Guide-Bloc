import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/dummy/dummy_data.dart';
import '../bloc/gov_details_cubit/gov_details_cubit.dart';
import '../widgets/details_list.dart';
import '../../../widgets/common_header.dart';

class GovernorateDetails extends StatelessWidget {
  const GovernorateDetails({super.key});

  @override
  Widget build(BuildContext context) {
    String govName = ModalRoute.of(context)!.settings.arguments as String;
    context.read<GovDetailsCubit>().getDetails(govName);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonHeader(title: 'Land Marks in $govName', showBackBtn: true),
          BlocBuilder<GovDetailsCubit, GovDetailsState>(
            builder: (context, state) {
              if (state is GovDetailsLoading) {
                return DetailsList(
                  loading: true,
                  itemsCount: 4,
                  places: List.filled(4, kDummyData),
                );
              } //
              else if (state is GovDetailsLoaded) {
                return DetailsList(
                  loading: false,
                  itemsCount: state.govs.length,
                  places: state.govs,
                );
              } //
              else if (state is GovDetailsError) {
                return Center(child: Text(state.errorMsg));
              } //
              else {
                return Center(child: Text('Error: $state'));
              }
            },
          ),
        ],
      ),
    );
  }
}
