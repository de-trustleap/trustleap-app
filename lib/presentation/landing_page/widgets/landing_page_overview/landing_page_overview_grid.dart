import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageOverviewGrid extends StatelessWidget {
  const LandingPageOverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    return Placeholder();
    // return Container(
    //   constraints: const BoxConstraints(maxHeight: 600),
    //   child: AnimationLimiter(
    //     child: GridView.count(
    //         crossAxisCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
    //         crossAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
    //         mainAxisSpacing: responsiveValue.largerThan(MOBILE) ? 24 : 12,
    //         shrinkWrap: true,
    //         scrollDirection: Axis.vertical,
    //         physics: const ScrollPhysics(),
    //         childAspectRatio: calculateChildAspectRatio(responsiveValue),
    //         children: List.generate(promoters.length, (index) {
    //           return AnimationConfiguration.staggeredGrid(
    //             position: index,
    //             duration: const Duration(milliseconds: 150),
    //             columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
    //             child: ScaleAnimation(
    //               child: Center(
    //                   child: GridTile(
    //                       child: PromotersOverviewGridTile(
    //                           promoter: promoters[index]))),
    //             ),
    //           );
    //         })),
    //   ),
    // );
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