import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tourist_guide/data/models/fire_store_goverorate_model.dart';
import 'package:tourist_guide/ui/landmarks/govs/widgets/govs_card.dart';

class GovsGrid extends StatelessWidget {
  final bool loading;
  final int itemCount;
  final List<GovernorateModel> govs;
  const GovsGrid({
    super.key,
    required this.loading,
    required this.itemCount,
    required this.govs,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: REdgeInsets.all(10),
        itemCount: govs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) => Skeletonizer(
          enabled: loading,
          child: Skeletonizer(
            enabled: loading,
            enableSwitchAnimation: loading,
            child: GovernorateCard(gov: govs[index]),
          ),
        ),
      ),
    );
  }
}
