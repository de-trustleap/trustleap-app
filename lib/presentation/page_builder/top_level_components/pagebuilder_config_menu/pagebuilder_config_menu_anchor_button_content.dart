import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_text/pagebuilder_html_text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class PagebuilderConfigMenuAnchorButtonContent extends StatefulWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuAnchorButtonContent(
      {super.key, required this.model});

  @override
  State<PagebuilderConfigMenuAnchorButtonContent> createState() =>
      _PagebuilderConfigMenuAnchorButtonContentState();
}

class _PagebuilderConfigMenuAnchorButtonContentState
    extends State<PagebuilderConfigMenuAnchorButtonContent> {
  final HtmlEditorController htmlController = HtmlEditorController();

  @override
  void dispose() {
    htmlController.disable();
    super.dispose();
  }

  void updateTextProperties(PagebuilderAnchorButtonProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = widget.model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();

    if (widget.model.elementType == PageBuilderWidgetType.anchorButton &&
        widget.model.properties is PagebuilderAnchorButtonProperties) {
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
              (widget.model.properties as PagebuilderAnchorButtonProperties)
                  .sectionName;
          final properties =
              widget.model.properties as PagebuilderAnchorButtonProperties;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollapsibleTile(
                title: "Button Titel",
                children: [
                  PagebuilderHTMLTextEditor(
                    controller: htmlController,
                    initialHtml:
                        properties.buttonProperties?.textProperties?.text ?? "",
                    onChanged: (html) {
                      final updatedTextProperties = properties
                          .buttonProperties?.textProperties
                          ?.copyWith(text: html);
                      final updatedButtonProperties =
                          properties.buttonProperties?.copyWith(
                        textProperties: updatedTextProperties,
                      );
                      final updatedProperties = properties.copyWith(
                        buttonProperties: updatedButtonProperties,
                      );
                      updateTextProperties(updatedProperties, pagebuilderCubit);
                    },
                  )
                ],
              ),
              const SizedBox(height: 20),
              CollapsibleTile(
                  title: localization
                      .pagebuilder_anchor_button_content_section_name,
                  children: [
                    Text(
                        localization
                            .pagebuilder_anchor_button_content_section_name_subtitle,
                        style: themeData.textTheme.bodySmall),
                    const SizedBox(height: 30),
                    availableSectionNames.isNotEmpty
                        ? UnderlinedDropdown<String>(
                            value: availableSectionNames
                                    .contains(currentSectionName)
                                ? currentSectionName
                                : null,
                            hint: localization
                                .pagebuilder_anchor_button_content_section_name_placeholder,
                            items: availableSectionNames.map((sectionName) {
                              return DropdownMenuItem<String>(
                                value: sectionName,
                                child: Text(sectionName),
                              );
                            }).toList(),
                            onChanged: (selectedSectionName) {
                              if (selectedSectionName != null) {
                                final updatedProperties = (widget
                                            .model.properties
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
                  ]),
            ],
          );
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
