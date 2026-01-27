import 'package:finanzbegleiter/domain/entities/landing_page_template.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_ai_generator_tile.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_creator/landing_page_creator_fourth_step_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageCreatorFourthStepGrid extends StatelessWidget {
  final List<LandingPageTemplate> landingpageTemplates;
  final int? selectedIndex;
  final bool isAIGeneratorSelected;
  final Function(int) onSelectIndex;
  final VoidCallback onAIGeneratorTap;
  final bool disabled;
  const LandingPageCreatorFourthStepGrid({
    super.key,
    required this.landingpageTemplates,
    required this.selectedIndex,
    required this.isAIGeneratorSelected,
    required this.onSelectIndex,
    required this.onAIGeneratorTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final totalItems = landingpageTemplates.length + 1; // +1 for AI Generator tile

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
          children: List.generate(totalItems, (index) {
            // First item is the AI Generator tile
            if (index == 0) {
              return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 150),
                  columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                  child: ScaleAnimation(
                      child: Center(
                          child: GridTile(
                              child: LandingPageCreatorAIGeneratorTile(
                                  isSelected: isAIGeneratorSelected,
                                  disabled: disabled,
                                  onTap: onAIGeneratorTap)))));
            }

            // Template tiles (shifted by 1)
            final templateIndex = index - 1;
            final isSelected = selectedIndex == templateIndex;
            return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 150),
                columnCount: responsiveValue.largerThan(MOBILE) ? 3 : 2,
                child: ScaleAnimation(
                    child: Center(
                        child: GridTile(
                            child: LandingPageCreatorFourthStepGridTile(
                                template: landingpageTemplates[templateIndex],
                                isSelected: isSelected,
                                disabled: disabled,
                                onTap: () {
                                  if (!disabled) {
                                    onSelectIndex(templateIndex);
                                  }
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
