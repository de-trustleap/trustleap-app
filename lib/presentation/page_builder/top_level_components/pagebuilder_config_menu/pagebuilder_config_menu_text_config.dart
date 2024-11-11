import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_font_family_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_text_alignment_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuTextConfig({super.key, required this.model});

  void updateTextProperties(
      PageBuilderTextProperties properties, PagebuilderCubit pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.updateWidget(updatedWidget);
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderCubit = Modular.get<PagebuilderCubit>();

    if (model.elementType == PageBuilderWidgetType.text &&
        model.properties is PageBuilderTextProperties) {
      return CollapsibleTile(title: "Text", children: [
        PagebuilderTextAlignmentControl(
            initialAlignment:
                (model.properties as PageBuilderTextProperties).alignment ??
                    TextAlign.center,
            onSelected: (alignment) {
              final updatedProperties =
                  (model.properties as PageBuilderTextProperties)
                      .copyWith(alignment: alignment);
              updateTextProperties(updatedProperties, pagebuilderCubit);
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
              updateTextProperties(updatedProperties, pagebuilderCubit);
            }),
        SizedBox(height: 20),
        PagebuilderFontFamilyControl(
            initialValue:
                (model.properties as PageBuilderTextProperties).fontFamily ??
                    "",
            onSelected: (fontFamily) {
              final updatedProperties =
                  (model.properties as PageBuilderTextProperties)
                      .copyWith(fontFamily: fontFamily);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            }),
        SizedBox(height: 20),
        PagebuilderNumberDropdown(
            title: "Zeilenhöhe",
            initialValue:
                (model.properties as PageBuilderTextProperties).lineHeight ??
                    1.0,
            numbers: List.generate(31, (index) => double.parse((index * 0.1).toStringAsFixed(1))),
            onSelected: (lineHeight) {
              final updatedProperties =
                  (model.properties as PageBuilderTextProperties)
                      .copyWith(lineHeight: lineHeight);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            })
      ]);
    } else {
      return SizedBox.shrink();
    }
  }
}
// TODO: 