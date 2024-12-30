import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuBackground extends StatelessWidget {
  final PageBuilderWidget? model;
  final PageBuilderSection? section;
  const PagebuilderConfigMenuBackground(
      {super.key, required this.model, required this.section});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    return CollapsibleTile(
        title: localization.landingpage_pagebuilder_layout_menu_background,
        children: [
          PagebuilderColorControl(
              title: localization
                  .landingpage_pagebuilder_layout_menu_background_color,
              initialColor: model != null
                  ? (model?.background?.backgroundColor ?? Colors.transparent)
                  : (section?.background?.backgroundColor ??
                      Colors.transparent),
              onSelected: (color) {
                if (model != null) {
                  final backgroundModel = model!.background ??
                      const PagebuilderBackground(
                          backgroundColor: null,
                          imageProperties: null,
                          overlayColor: null);
                  final updatedBackground =
                      backgroundModel.copyWith(backgroundColor: color);
                  final updatedWidget =
                      model!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else if (section != null) {
                  final backgroundModel = section!.background ??
                      const PagebuilderBackground(
                          backgroundColor: null,
                          imageProperties: null,
                          overlayColor: null);
                  final updatedBackground =
                      backgroundModel.copyWith(backgroundColor: color);
                  final updatedSection =
                      section!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
                }
              }),
          const SizedBox(height: 20),
          PagebuilderImageControl(
              properties: model != null
                  ? model?.background?.imageProperties ??
                      const PageBuilderImageProperties(
                          url: null,
                          borderRadius: null,
                          width: null,
                          height: null,
                          contentMode: null,
                          overlayColor: null)
                  : section?.background?.imageProperties ??
                      const PageBuilderImageProperties(
                          url: null,
                          borderRadius: null,
                          width: null,
                          height: null,
                          contentMode: null,
                          overlayColor: null),
              widgetModel: model,
              onSelected: (properties) {
                if (model != null) {
                  final backgroundModel = model?.background ??
                      const PagebuilderBackground(
                          backgroundColor: null,
                          imageProperties: null,
                          overlayColor: null);
                  final updatedBackground =
                      backgroundModel.copyWith(imageProperties: properties);
                  final updatedWidget =
                      model!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else if (section != null) {
                  final backgroundModel = section?.background ??
                      const PagebuilderBackground(
                          backgroundColor: null,
                          imageProperties: null,
                          overlayColor: null);
                  final updatedBackground =
                      backgroundModel.copyWith(imageProperties: properties);
                  final updatedSection =
                      section!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
                }
              },
              onDelete: () {
                final properties = model?.background?.imageProperties;
                if (properties != null && model != null) {
                  final updatedBackground =
                      model!.background!.copyWith(setImagePropertiesNull: true);
                  final updatedWidget =
                      model!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else if (properties != null && section != null) {
                  final updatedBackground = section!.background!
                      .copyWith(setImagePropertiesNull: true);
                  final updatedSection =
                      section!.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
                }
              }),
          if (model?.background?.imageProperties != null ||
              section?.background?.imageProperties != null) ...[
            const SizedBox(height: 20),
            PagebuilderConfigMenuDrowdown(
                title: localization
                    .landingpage_pagebuilder_layout_menu_background_contentmode,
                initialValue: model != null
                    ? model?.background?.imageProperties?.contentMode ??
                        BoxFit.cover
                    : section?.background?.imageProperties?.contentMode ??
                        BoxFit.cover,
                type: PagebuilderDropdownType.contentMode,
                onSelected: (contentMode) {
                  if (model != null) {
                    final properties = model!.background!.imageProperties!
                        .copyWith(contentMode: contentMode);
                    final updatedWidget = model!.copyWith(
                        background: model!.background!
                            .copyWith(imageProperties: properties));
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  } else if (section != null) {
                    final properties = section!.background!.imageProperties!
                        .copyWith(contentMode: contentMode);
                    final updatedSection = section!.copyWith(
                        background: section!.background!
                            .copyWith(imageProperties: properties));
                    pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
                  }
                }),
            const SizedBox(height: 20),
            PagebuilderColorControl(
                title: localization
                    .landingpage_pagebuilder_layout_menu_background_overlay,
                initialColor: model != null
                    ? model?.background?.overlayColor ?? Colors.transparent
                    : section?.background?.overlayColor ?? Colors.transparent,
                onSelected: (color) {
                  if (model != null) {
                    final updatedBackground =
                        model!.background!.copyWith(overlayColor: color);
                    final updatedWidget =
                        model!.copyWith(background: updatedBackground);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  } else if (section != null) {
                    final updatedBackground =
                        section!.background!.copyWith(overlayColor: color);
                    final updatedSection =
                        section!.copyWith(background: updatedBackground);
                    pagebuilderBloc.add(UpdateSectionEvent(updatedSection));
                  }
                }),
          ]
        ]);
  }
}
