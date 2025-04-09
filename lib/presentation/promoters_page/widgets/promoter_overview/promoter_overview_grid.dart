// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Promoter> promoters;
  final Function(String) deletePressed;

  const PromoterOverviewGrid(
      {super.key,
      required this.controller,
      required this.promoters,
      required this.deletePressed});

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 1000),
      child: LayoutBuilder(builder: (context, constraints) {
        int crossAxisCount = (constraints.maxWidth / 250).floor().clamp(2, 4);

        return AnimationLimiter(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: constraints.maxWidth / crossAxisCount,
                crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
                mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
                childAspectRatio: calculateChildAspectRatio(responsiveValue),
              ),
              itemCount: promoters.length,
              shrinkWrap: true,
              controller: controller,
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 150),
                  columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                  child: ScaleAnimation(
                    child: Center(
                        child: GridTile(
                            child: PromotersOverviewGridTile(
                                promoter: promoters[index],
                                deletePressed: deletePressed))),
                  ),
                );
              }),
        );
      }),
    );
  }

  double calculateChildAspectRatio(ResponsiveBreakpointsData responsiveValue) {
    if (responsiveValue.isDesktop) {
      return 0.8;
    } else if (responsiveValue.isTablet) {
      return 0.67;
    } else {
      return 0.5;
    }
  }
}
