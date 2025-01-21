import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_third_step_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorThirdStepGrid extends StatelessWidget {
  final List<LandingPageTemplate> landingpageTemplates;
  final int? selectedIndex;
  final Function(int) onSelectIndex;
  const LandingPageCreatorThirdStepGrid(
      {super.key,
      required this.landingpageTemplates,
      required this.selectedIndex,
      required this.onSelectIndex});

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
          children: List.generate(landingpageTemplates.length, (index) {
            final isSelected = selectedIndex == index;
            return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                    child: Center(
                        child: GridTile(
                            child: LandingPageCreatorThirdStepGridTile(
                                template: landingpageTemplates[index],
                                isSelected: isSelected,
                                onTap: () {
                                  onSelectIndex(index);
                                })))));
          }),
        )));
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
