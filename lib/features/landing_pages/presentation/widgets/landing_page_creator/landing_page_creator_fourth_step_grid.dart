import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_template.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/animated_tile_grid.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_creator_ai_generator_tile.dart';
import 'package:finanzbegleiter/features/landing_pages/presentation/widgets/landing_page_creator/landing_page_creator_fourth_step_grid_tile.dart';
import 'package:flutter/material.dart';

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
    final totalItems =
        landingpageTemplates.length + 1; // +1 for AI Generator tile

    return AnimatedTileGrid(
      itemCount: totalItems,
      gridName: 'template-grid',
      shrinkWrap: true,
      desktopAspectRatio: 0.85,
      mobileAspectRatio: 0.7,
      itemBuilder: (index, tileWidth, tileHeight) {
        // First item is the AI Generator tile
        if (index == 0) {
          return LandingPageCreatorAIGeneratorTile(
            isSelected: isAIGeneratorSelected,
            disabled: disabled,
            onTap: onAIGeneratorTap,
          );
        }

        // Template tiles (shifted by 1)
        final templateIndex = index - 1;
        final isSelected = selectedIndex == templateIndex;
        return LandingPageCreatorFourthStepGridTile(
          template: landingpageTemplates[templateIndex],
          isSelected: isSelected,
          disabled: disabled,
          onTap: () {
            if (!disabled) {
              onSelectIndex(templateIndex);
            }
          },
        );
      },
    );
  }
}
