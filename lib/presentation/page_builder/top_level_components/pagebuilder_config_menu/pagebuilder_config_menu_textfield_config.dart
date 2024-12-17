import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_textfield_properties.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:flutter/material.dart';

class PagebuilderConfigMenuTextfieldConfig extends StatelessWidget {
  final PageBuilderTextFieldProperties? properties;
  final Function(PageBuilderTextFieldProperties?) onChanged;
  const PagebuilderConfigMenuTextfieldConfig(
      {super.key, required this.properties, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PagebuilderNumberStepperControl(
          title: "Breite",
          initialValue: properties?.width?.toInt() ?? 0,
          minValue: 0,
          maxValue: 1000,
          onSelected: (width) {
            onChanged(properties?.copyWith(width: width.toDouble()));
          })
    ]);
  }
}
