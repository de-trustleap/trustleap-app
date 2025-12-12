import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_colors.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_picker/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_shadow_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_switch_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuCalendlyConfig extends StatelessWidget {
  final PageBuilderWidget model;
  final PageBuilderGlobalColors? globalColors;
  const PagebuilderConfigMenuCalendlyConfig({super.key, required this.model, this.globalColors});

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

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        return CollapsibleTile(
            title: localization.pagebuilder_calendly_config_title,
            children: [
              PagebuilderNumberStepperControl(
                title: localization.pagebuilder_calendly_config_width,
                initialValue: helper.getValue(properties.width)?.toInt() ?? 300,
                minValue: 100,
                maxValue: 1000,
                showResponsiveButton: true,
                currentBreakpoint: currentBreakpoint,
                onSelected: (value) {
                  final updatedWidth =
                      helper.setValue(properties.width, value.toDouble());
                  updateCalendlyProperties(
                    properties.copyWith(width: updatedWidth),
                    pagebuilderCubit,
                  );
                },
              ),
              const SizedBox(height: 16),
              if (!(properties.useIntrinsicHeight ?? false)) ...[
                PagebuilderNumberStepperControl(
                  title: localization.pagebuilder_calendly_config_height,
                  initialValue:
                      helper.getValue(properties.height)?.toInt() ?? 200,
                  minValue: 100,
                  maxValue: 800,
                  showResponsiveButton: true,
                  currentBreakpoint: currentBreakpoint,
                  onSelected: (value) {
                    final updatedHeight =
                        helper.setValue(properties.height, value.toDouble());
                    updateCalendlyProperties(
                      properties.copyWith(height: updatedHeight),
                      pagebuilderCubit,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
              PagebuilderSwitchControl(
                title: localization.pagebuilder_calendly_config_dynamic_height,
                isActive: properties.useIntrinsicHeight ?? false,
                onSelected: (value) {
                  updateCalendlyProperties(
                    properties.copyWith(useIntrinsicHeight: value),
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
                  enableOpacity: false,
                  enableGradients: false,
                  globalColors: globalColors,
                  selectedGlobalColorToken: properties.textColorToken,
                  onColorSelected: (color, {token}) {
                    updateCalendlyProperties(
                      properties.copyWith(textColor: color, textColorToken: token),
                      pagebuilderCubit,
                    );
                  }),
              const SizedBox(height: 16),
              PagebuilderColorControl(
                  title:
                      localization.pagebuilder_calendly_config_background_color,
                  initialColor: properties.backgroundColor ?? Colors.black,
                  enableGradients: false,
                  enableOpacity: false,
                  globalColors: globalColors,
                  selectedGlobalColorToken: properties.backgroundColorToken,
                  onColorSelected: (color, {token}) {
                    updateCalendlyProperties(
                      properties.copyWith(backgroundColor: color, backgroundColorToken: token),
                      pagebuilderCubit,
                    );
                  }),
              const SizedBox(height: 16),
              PagebuilderColorControl(
                  title: localization.pagebuilder_calendly_config_primary_color,
                  initialColor: properties.primaryColor ?? Colors.black,
                  enableGradients: false,
                  enableOpacity: false,
                  globalColors: globalColors,
                  selectedGlobalColorToken: properties.primaryColorToken,
                  onColorSelected: (color, {token}) {
                    updateCalendlyProperties(
                      properties.copyWith(primaryColor: color, primaryColorToken: token),
                      pagebuilderCubit,
                    );
                  }),
              const SizedBox(height: 16),
              PagebuilderShadowControl(
                title: localization
                    .landingpage_pagebuilder_container_config_container_shadow,
                initialShadow: properties.shadow,
                showSpreadRadius: true,
                onSelected: (shadow) {
                  updateCalendlyProperties(
                    properties.copyWith(shadow: shadow),
                    pagebuilderCubit,
                  );
                },
              ),
            ]);
      },
    );
  }
}
