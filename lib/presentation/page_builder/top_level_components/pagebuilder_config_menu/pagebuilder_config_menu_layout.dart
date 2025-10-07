import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_config_menu_dropdown.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_spacing_control.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_width_percentage_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuLayout extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuLayout({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);
        final validator = PagebuilderWidthPercentageValidator(
          currentWidget: model,
          pagebuilderBloc: pagebuilderBloc,
        );

        final showWarning = validator.shouldShowWarning(currentBreakpoint);
        final totalWidth = validator.getTotalWidth(currentBreakpoint);

        return CollapsibleTile(
            title: localization.landingpage_pagebuilder_layout_menu_title,
            children: [
              PagebuilderSpacingControl(
                  title:
                      localization.landingpage_pagebuilder_layout_menu_margin,
                  spacingType: PageBuilderSpacingType.margin,
                  model: model,
                  onChanged: (margin) {
                    final updatedWidget = model.copyWith(margin: margin);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  }),
              const SizedBox(height: 24),
              PagebuilderSpacingControl(
                  title:
                      localization.landingpage_pagebuilder_layout_menu_padding,
                  spacingType: PageBuilderSpacingType.padding,
                  model: model,
                  onChanged: (padding) {
                    final updatedWidget = model.copyWith(padding: padding);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  }),
              const SizedBox(height: 24),
              PagebuilderConfigMenuDrowdown(
                  title: localization
                      .landingpage_pagebuilder_layout_menu_alignment,
                  initialValue: model.alignment ?? Alignment.center,
                  type: PagebuilderDropdownType.alignment,
                  onSelected: (alignment) {
                    final updatedWidget = model.copyWith(alignment: alignment);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  }),
              if (model.widthPercentage != null) ...[
                const SizedBox(height: 20),
                PagebuilderNumberStepperControl(
                    title: localization
                        .landingpage_pagebuilder_layout_menu_width_percentage,
                    initialValue:
                        helper.getValue(model.widthPercentage)?.toInt() ?? 0,
                    minValue: 0,
                    maxValue: 99,
                    showResponsiveButton: true,
                    currentBreakpoint: currentBreakpoint,
                    onSelected: (width) {
                      final updatedWidth = helper.setValue(
                          model.widthPercentage, width.toDouble());
                      final updatedWidget =
                          model.copyWith(widthPercentage: updatedWidth);
                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    }),
                if (showWarning) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.orange, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded,
                            color: Colors.orange, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            localization
                                .landingpage_pagebuilder_layout_menu_width_warning(
                                    totalWidth?.toStringAsFixed(0) ?? '0'),
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ]
            ]);
      },
    );
  }
}
