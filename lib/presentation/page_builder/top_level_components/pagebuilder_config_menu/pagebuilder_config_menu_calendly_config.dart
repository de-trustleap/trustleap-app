import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuCalendlyConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuCalendlyConfig({super.key, required this.model});

  void updateCalendlyProperties(PagebuilderCalendlyProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    final properties = model.properties as PagebuilderCalendlyProperties;
    final localization = AppLocalizations.of(context);

    return CollapsibleTile(
        title: localization.pagebuilder_calendly_config_title,
        children: [
          PagebuilderNumberStepperControl(
            title: localization.pagebuilder_calendly_config_width,
            initialValue: properties.width?.toInt() ?? 300,
            minValue: 100,
            maxValue: 1000,
            onSelected: (value) {
              updateCalendlyProperties(
                properties.copyWith(width: value.toDouble()),
                pagebuilderCubit,
              );
            },
          ),
          const SizedBox(height: 16),
          PagebuilderNumberStepperControl(
            title: localization.pagebuilder_calendly_config_height,
            initialValue: properties.height?.toInt() ?? 200,
            minValue: 100,
            maxValue: 800,
            onSelected: (value) {
              updateCalendlyProperties(
                properties.copyWith(height: value.toDouble()),
                pagebuilderCubit,
              );
            },
          ),
          const SizedBox(height: 16),
          PagebuilderNumberStepperControl(
            title: localization.pagebuilder_calendly_config_border_radius,
            initialValue: properties.borderRadius?.toInt() ?? 0,
            minValue: 0,
            maxValue: 50,
            onSelected: (value) {
              updateCalendlyProperties(
                properties.copyWith(borderRadius: value.toDouble()),
                pagebuilderCubit,
              );
            },
          ),
          const SizedBox(height: 16),
          PagebuilderColorControl(
            title: localization.pagebuilder_calendly_config_text_color,
            initialColor: properties.textColor ?? Colors.black,
            onSelected: (color) {
              updateCalendlyProperties(
                properties.copyWith(textColor: color),
                pagebuilderCubit,
              );
            },
          ),
          const SizedBox(height: 16),
          PagebuilderColorControl(
            title: localization.pagebuilder_calendly_config_background_color,
            initialColor: properties.backgroundColor ?? Colors.black,
            onSelected: (color) {
              updateCalendlyProperties(
                properties.copyWith(backgroundColor: color),
                pagebuilderCubit,
              );
            },
          ),
          const SizedBox(height: 16),
          PagebuilderColorControl(
            title: localization.pagebuilder_calendly_config_primary_color,
            initialColor: properties.primaryColor ?? Colors.black,
            onSelected: (color) {
              updateCalendlyProperties(
                properties.copyWith(primaryColor: color),
                pagebuilderCubit,
              );
            },
          ),
        ]);
  }
}
