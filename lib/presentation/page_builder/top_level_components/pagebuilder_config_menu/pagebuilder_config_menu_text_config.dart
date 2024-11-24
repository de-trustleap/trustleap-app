import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_font_family_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_text_alignment_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_text_shadow_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuTextConfig({super.key, required this.model});

  void updateTextProperties(
      PageBuilderTextProperties properties, PagebuilderBloc pagebuilderBloc) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    if (model.elementType == PageBuilderWidgetType.text &&
        model.properties is PageBuilderTextProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_text_config_text_title,
          children: [
            PagebuilderTextAlignmentControl(
                initialAlignment:
                    (model.properties as PageBuilderTextProperties).alignment ??
                        TextAlign.center,
                onSelected: (alignment) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(alignment: alignment);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            PagebuilderColorControl(
                initialColor:
                    (model.properties as PageBuilderTextProperties).color ??
                        Colors.black,
                onSelected: (color) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(color: color);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            PagebuilderFontFamilyControl(
                initialValue: (model.properties as PageBuilderTextProperties)
                        .fontFamily ??
                    "",
                onSelected: (fontFamily) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(fontFamily: fontFamily);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text(localization.landingpage_pagebuilder_text_config_fontsize,
            style: themeData.textTheme.bodySmall),
                        PagebuilderNumberStepper(
                initialValue: (model.properties as PageBuilderTextProperties)
                        .fontSize
                        ?.round() ??
                    0,
                minValue: 0,
                maxValue: 1000,
                onSelected: (fontSize) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(fontSize: fontSize.toDouble());
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            ]),
            SizedBox(height: 20),
            PagebuilderNumberDropdown(
                title:
                    localization.landingpage_pagebuilder_text_config_lineheight,
                initialValue: (model.properties as PageBuilderTextProperties)
                        .lineHeight ??
                    1.0,
                numbers: List.generate(31,
                    (index) => double.parse((index * 0.1).toStringAsFixed(1))),
                onSelected: (lineHeight) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(lineHeight: lineHeight);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            PagebuilderNumberDropdown(
                title: localization
                    .landingpage_pagebuilder_text_config_letterspacing,
                initialValue: (model.properties as PageBuilderTextProperties)
                        .letterSpacing ??
                    1.0,
                numbers: List.generate(31,
                    (index) => double.parse((index * 0.1).toStringAsFixed(1))),
                onSelected: (letterSpacing) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(letterSpacing: letterSpacing);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                }),
            SizedBox(height: 20),
            PagebuilderTextShadowControl(
                initialShadow:
                    (model.properties as PageBuilderTextProperties).textShadow,
                onSelected: (shadow) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(textShadow: shadow);
                  updateTextProperties(updatedProperties, pagebuilderBloc);
                })
          ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
