import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_background.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_custom_css.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_maxwidth.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_name.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_section_visible_on.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final localization = AppLocalizations.of(context);

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PagebuilderSwitchControl(
              title: localization.pagebuilder_section_full_height,
              isActive: helper.getValue(section.fullHeight) ?? false,
              showResponsiveButton: true,
              currentBreakpoint: currentBreakpoint,
              onSelected: (value) {
                final updatedFullHeight =
                    helper.setValue(section.fullHeight, value);
                final updatedSection =
                    section.copyWith(fullHeight: updatedFullHeight);
                pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
              },
            ),
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
      },
    );
  }
}
