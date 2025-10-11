import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_background.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_custom_css.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_maxwidth.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_name.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_visible_on.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderConfigMenuSection extends StatelessWidget {
  final PageBuilderSection section;
  final List<PageBuilderSection> allSections;

  const LandingPageBuilderConfigMenuSection({
    super.key,
    required this.section,
    required this.allSections,
  });

  List<String> _getExistingSectionNames() {
    return allSections
        .where((s) => s.id.value != section.id.value)
        .map((s) => s.name)
        .where((name) => name != null)
        .cast<String>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    return ListView(children: [
      const SizedBox(height: 16),
      PagebuilderConfigMenuSectionName(
        sectionName: section.name,
        existingSectionNames: _getExistingSectionNames(),
        onChanged: (newName) {
          final updatedSection = section.copyWith(name: newName);
          pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
        },
      ),
      const SizedBox(height: 8),
      PagebuilderConfigMenuSectionMaxWidth(section: section),
      const SizedBox(height: 8),
      PagebuilderConfigMenuBackground(model: null, section: section),
      const SizedBox(height: 8),
      PagebuilderConfigMenuCustomCSS(model: null, section: section),
      const SizedBox(height: 8),
      PagebuilderConfigMenuSectionVisibleOn(section: section),
      const SizedBox(height: 40)
    ]);
  }
}
