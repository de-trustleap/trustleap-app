import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_image_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:flutter/material.dart';

class PagebuilderSizeControl extends StatelessWidget {
  final PageBuilderWidget model;
  final Function(Size) onChanged;
  const PagebuilderSizeControl(
      {super.key, required this.model, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localization.pagebuilder_layout_menu_size_control_size,
              style: themeData.textTheme.bodySmall),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            PagebuilderNumberStepper(
                initialValue: (model.properties as PageBuilderImageProperties)
                        .width
                        ?.toInt() ??
                    0,
                minValue: 0,
                maxValue: 3000,
                placeholder:
                    localization.pagebuilder_layout_menu_size_control_width,
                onSelected: (width) {
                  final Size size = Size(
                      width.toDouble(),
                      (model.properties as PageBuilderImageProperties).height ??
                          0);
                  onChanged(size);
                }),
            SizedBox(width: 20),
            PagebuilderNumberStepper(
                initialValue: (model.properties as PageBuilderImageProperties)
                        .height
                        ?.toInt() ??
                    0,
                minValue: 0,
                maxValue: 3000,
                placeholder:
                    localization.pagebuilder_layout_menu_size_control_height,
                onSelected: (height) {
                  final Size size = Size(
                      (model.properties as PageBuilderImageProperties).width ??
                          0,
                      height.toDouble());

                  onChanged(size);
                }),
          ])
        ]);
  }
}
