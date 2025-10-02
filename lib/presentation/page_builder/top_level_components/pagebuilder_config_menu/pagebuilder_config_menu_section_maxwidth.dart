import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuSectionMaxWidth extends StatelessWidget {
  final PageBuilderSection section;

  const PagebuilderConfigMenuSectionMaxWidth({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    return CollapsibleTile(
      title: localization.pagebuilder_section_maxwidth_title,
      children: [
        PagebuilderNumberStepperControl(
          title: localization.pagebuilder_section_maxwidth,
          initialValue: section.maxWidth?.toInt() ?? 1200,
          minValue: 1,
          maxValue: 10000,
          bigNumbers: true,
          onSelected: (value) {
            final updatedSection = section.copyWith(
              maxWidth: value.toDouble(),
            );
            pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
          },
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: Text(
            localization.pagebuilder_section_background_constrained,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: section.backgroundConstrained ?? false,
          onChanged: (value) {
            final updatedSection = section.copyWith(
              backgroundConstrained: value ?? false,
            );
            pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
