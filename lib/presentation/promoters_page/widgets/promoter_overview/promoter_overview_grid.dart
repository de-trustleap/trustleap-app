// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterOverviewGrid extends StatelessWidget {
  final ScrollController controller;
  final List<Promoter> promoters;

  const PromoterOverviewGrid({
    super.key,
    required this.controller,
    required this.promoters,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: AnimationLimiter(
        child: GridView.count(
            crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
            crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
            mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
            shrinkWrap: true,
            controller: controller,
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            childAspectRatio: calculateChildAspectRatio(responsiveValue),
            children: List.generate(promoters.length, (index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                  child: Center(
                      child: GridTile(
                          child: PromotersOverviewGridTile(
                              promoter: promoters[index]))),
                ),
              );
            })),
      ),
    );
  }

  double calculateChildAspectRatio(ResponsiveBreakpointsData responsiveValue) {
    if (responsiveValue.isDesktop) {
      return 0.85;
    } else if (responsiveValue.isTablet) {
      return 0.67;
    } else {
      return 0.6;
    }
  }
}
