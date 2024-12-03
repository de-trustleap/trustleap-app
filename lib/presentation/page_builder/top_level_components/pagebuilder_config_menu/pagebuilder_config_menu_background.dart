import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_background.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_contentmode_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_image_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuBackground extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuBackground({super.key, required this.model});

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
              initialColor:
                  model.background?.backgroundColor ?? Colors.transparent,
              onSelected: (color) {
                final backgroundModel = model.background ??
                    PagebuilderBackground(
                        backgroundColor: null,
                        imageProperties: null,
                        overlayColor: null);
                final updatedBackground =
                    backgroundModel.copyWith(backgroundColor: color);
                final updatedWidget =
                    model.copyWith(background: updatedBackground);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              }),
          SizedBox(height: 20),
          PagebuilderImageControl(
              properties: model.background?.imageProperties ??
                  PageBuilderImageProperties(
                      url: null,
                      borderRadius: null,
                      width: null,
                      height: null,
                      alignment: null,
                      contentMode: null),
              widgetModel: model,
              onSelected: (properties) {
                final backgroundModel = model.background ??
                    PagebuilderBackground(
                        backgroundColor: null,
                        imageProperties: null,
                        overlayColor: null);
                final updatedBackground =
                    backgroundModel.copyWith(imageProperties: properties);
                final updatedWidget =
                    model.copyWith(background: updatedBackground);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              },
              onDelete: () {
                final properties = model.background?.imageProperties;
                if (properties != null) {
                  final updatedBackground =
                      model.background!.copyWith(setImagePropertiesNull: true);
                  final updatedWidget =
                      model.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              }),
          if (model.background?.imageProperties != null) ...[
            SizedBox(height: 20),
            PagebuilderContentModeDrowdown(
                title: localization
                    .landingpage_pagebuilder_layout_menu_background_contentmode,
                initialValue: model.background?.imageProperties?.contentMode ??
                    BoxFit.cover,
                values: [BoxFit.cover, BoxFit.fill, BoxFit.contain],
                onSelected: (contentMode) {
                  final properties = model.background!.imageProperties!
                      .copyWith(contentMode: contentMode);
                  final updatedWidget = model.copyWith(
                      background: model.background!
                          .copyWith(imageProperties: properties));
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }),
            SizedBox(height: 20),
            PagebuilderColorControl(
                title: localization
                    .landingpage_pagebuilder_layout_menu_background_overlay,
                initialColor:
                    model.background?.overlayColor ?? Colors.transparent,
                onSelected: (color) {
                  final updatedBackground =
                      model.background!.copyWith(overlayColor: color);
                  final updatedWidget =
                      model.copyWith(background: updatedBackground);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }),
          ]
        ]);
  }
}
// TODO: Hintergrundbild löschen Backend