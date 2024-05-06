// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview_grid_tile.dart';

class LandingPageOverviewGrid extends StatelessWidget {
  final List<LandingPage> landingpages;
  LandingPageOverviewGrid({
    Key? key,
    required this.landingpages,
  }) : super(key: key);

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
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            childAspectRatio: calculateChildAspectRatio(responsiveValue),
            children: List.generate(landingpages.length, (index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                  child: Center(
                      child: GridTile(
                          child: LandingPageOverviewGridTile(
                              landingPage: landingpages[index]))),
                ),
              );
            })),
      ),
    );
  }
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
