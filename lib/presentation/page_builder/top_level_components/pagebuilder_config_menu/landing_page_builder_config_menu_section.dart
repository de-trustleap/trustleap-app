import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_background.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_id_display.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderConfigMenuSection extends StatelessWidget {
  final PageBuilderSection section;
  const LandingPageBuilderConfigMenuSection({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      const SizedBox(height: 16),
      PagebuilderConfigMenuSectionIDDisplay(sectionID: section.id.value),
      PagebuilderConfigMenuBackground(model: null, section: section),
      const SizedBox(height: 40)
    ]);
  }
}
