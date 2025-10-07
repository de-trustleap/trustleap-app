import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_hover_config_tabbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuIconConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuIconConfig({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.icon &&
        model.properties is PageBuilderIconProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_icon_config_icon_title,
          children: [
            PagebuilderHoverConfigTabBar<PageBuilderIconProperties>(
              properties: model.properties as PageBuilderIconProperties,
              hoverProperties: model.hoverProperties != null
                  ? model.hoverProperties as PageBuilderIconProperties
                  : null,
              hoverEnabled: model.hoverProperties != null,
              onHoverEnabledChanged: (enabled) {
                if (enabled) {
                  final hoverProperties =
                      (model.properties as PageBuilderIconProperties)
                          .deepCopy();
                  final updatedWidget =
                      model.copyWith(hoverProperties: hoverProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget =
                      model.copyWith(removeHoverProperties: true);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              onChanged: (updated, isHover) {
                if (isHover) {
                  final updatedWidget =
                      model.copyWith(hoverProperties: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                } else {
                  final updatedWidget = model.copyWith(properties: updated);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                }
              },
              configBuilder: (props, disabled, onChangedLocal) =>
                  _buildIconConfigUI(
                      props, disabled, localization, onChangedLocal),
            )
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildIconConfigUI(
      PageBuilderIconProperties? props,
      bool disabled,
      AppLocalizations localization,
      Function(PageBuilderIconProperties?) onChangedLocal) {
    if (disabled) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

        return Column(children: [
          PagebuilderColorControl(
              title: localization.landingpage_pagebuilder_icon_config_color,
              initialColor: props?.color ?? Colors.black,
              enableGradients: false,
              onColorSelected: (color) {
                onChangedLocal(props?.copyWith(color: color));
              }),
          const SizedBox(height: 20),
          PagebuilderNumberStepperControl(
              title: localization.landingpage_pagebuilder_icon_config_size,
              initialValue: helper.getValue(props?.size)?.toInt() ?? 0,
              minValue: 0,
              maxValue: 1000,
              showResponsiveButton: true,
              currentBreakpoint: currentBreakpoint,
              onSelected: (size) {
                final updatedSize =
                    helper.setValue(props?.size, size.toDouble());
                onChangedLocal(props?.copyWith(size: updatedSize));
              })
        ]);
      },
    );
  }
}
