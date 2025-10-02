import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuAnchorButtonContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuAnchorButtonContent(
      {super.key, required this.model});

  void updateTextProperties(PagebuilderAnchorButtonProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.anchorButton &&
        model.properties is PagebuilderAnchorButtonProperties) {
      return BlocBuilder<PagebuilderBloc, PagebuilderState>(
        bloc: pagebuilderCubit,
        builder: (context, state) {
          List<String> availableSectionNames = [];

          if (state is GetLandingPageAndUserSuccessState) {
            final sections = state.content.content?.sections ?? [];
            availableSectionNames = sections
                .where((section) =>
                    section.name != null && section.name!.isNotEmpty)
                .map((section) => section.name!)
                .toList();
          }

          final currentSectionName =
              (model.properties as PagebuilderAnchorButtonProperties)
                  .sectionName;

          return CollapsibleTile(
              title:
                  localization.pagebuilder_anchor_button_content_section_name,
              children: [
                Text(
                    localization
                        .pagebuilder_anchor_button_content_section_name_subtitle,
                    style: themeData.textTheme.bodySmall),
                const SizedBox(height: 30),
                availableSectionNames.isNotEmpty
                    ? UnderlinedDropdown<String>(
                        value:
                            availableSectionNames.contains(currentSectionName)
                                ? currentSectionName
                                : null,
                        items: availableSectionNames.map((sectionName) {
                          return DropdownMenuItem<String>(
                            value: sectionName,
                            child: Text(sectionName),
                          );
                        }).toList(),
                        onChanged: (selectedSectionName) {
                          if (selectedSectionName != null) {
                            final updatedProperties = (model.properties
                                    as PagebuilderAnchorButtonProperties)
                                .copyWith(sectionName: selectedSectionName);
                            updateTextProperties(
                                updatedProperties, pagebuilderCubit);
                          }
                        },
                      )
                    : Text(
                        localization
                            .pagebuilder_anchor_button_content_no_sections_available,
                        style: themeData.textTheme.bodySmall?.copyWith(
                          color: themeData.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ]);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
