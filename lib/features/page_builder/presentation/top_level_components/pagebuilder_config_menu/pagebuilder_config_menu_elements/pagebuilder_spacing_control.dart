import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_breakpoint_selector.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum PageBuilderSpacingDirection { top, left, bottom, right }

class PagebuilderSpacingControl extends StatelessWidget {
  final String title;
  final PageBuilderSpacingType spacingType;
  final PageBuilderWidget model;
  final Function(PageBuilderSpacing) onChanged;

  const PagebuilderSpacingControl({
    super.key,
    required this.spacingType,
    required this.title,
    required this.model,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, currentBreakpoint) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: themeData.textTheme.bodySmall),
                const SizedBox(width: 8),
                PagebuilderBreakpointSelector(
                  currentBreakpoint: currentBreakpoint,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStepperRow(
                [
                  PageBuilderSpacingDirection.top,
                  PageBuilderSpacingDirection.left
                ],
                localization,
                currentBreakpoint),
            const SizedBox(height: 16),
            _buildStepperRow([
              PageBuilderSpacingDirection.bottom,
              PageBuilderSpacingDirection.right
            ], localization, currentBreakpoint),
          ],
        );
      },
    );
  }

  Widget _buildStepperRow(
      List<PageBuilderSpacingDirection> directions,
      AppLocalizations localization,
      PagebuilderResponsiveBreakpoint currentBreakpoint) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: directions
          .map((direction) => Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: _buildStepper(direction, localization, currentBreakpoint),
              ))
          .toList(),
    );
  }

  Widget _buildStepper(
      PageBuilderSpacingDirection direction,
      AppLocalizations localization,
      PagebuilderResponsiveBreakpoint currentBreakpoint) {
    final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);

    double getValue() {
      final spacing = _getSpacing();
      switch (direction) {
        case PageBuilderSpacingDirection.top:
          return helper.getValue(spacing?.top) ?? 0.0;
        case PageBuilderSpacingDirection.left:
          return helper.getValue(spacing?.left) ?? 0.0;
        case PageBuilderSpacingDirection.bottom:
          return helper.getValue(spacing?.bottom) ?? 0.0;
        case PageBuilderSpacingDirection.right:
          return helper.getValue(spacing?.right) ?? 0.0;
      }
    }

    void updateValue(double value) {
      final spacing = _getSpacing() ??
          const PageBuilderSpacing(
              top: PagebuilderResponsiveOrConstant.constant(0.0),
              bottom: PagebuilderResponsiveOrConstant.constant(0.0),
              left: PagebuilderResponsiveOrConstant.constant(0.0),
              right: PagebuilderResponsiveOrConstant.constant(0.0));
      final updatedSpacing = spacing.copyWith(
        top: direction == PageBuilderSpacingDirection.top
            ? helper.setValue(spacing.top, value)
            : spacing.top,
        left: direction == PageBuilderSpacingDirection.left
            ? helper.setValue(spacing.left, value)
            : spacing.left,
        bottom: direction == PageBuilderSpacingDirection.bottom
            ? helper.setValue(spacing.bottom, value)
            : spacing.bottom,
        right: direction == PageBuilderSpacingDirection.right
            ? helper.setValue(spacing.right, value)
            : spacing.right,
      );
      onChanged(updatedSpacing);
    }

    return PagebuilderNumberStepper(
      initialValue: getValue().toInt(),
      minValue: 0,
      maxValue: 1000,
      placeholder: _getLabel(direction, localization),
      onSelected: (value) => updateValue(value.toDouble()),
    );
  }

  PageBuilderSpacing? _getSpacing() {
    return spacingType == PageBuilderSpacingType.padding
        ? model.padding
        : model.margin;
  }

  String _getLabel(
      PageBuilderSpacingDirection direction, AppLocalizations localization) {
    switch (direction) {
      case PageBuilderSpacingDirection.top:
        return localization.landingpage_pagebuilder_layout_spacing_top;
      case PageBuilderSpacingDirection.left:
        return localization.landingpage_pagebuilder_layout_spacing_left;
      case PageBuilderSpacingDirection.bottom:
        return localization.landingpage_pagebuilder_layout_spacing_bottom;
      case PageBuilderSpacingDirection.right:
        return localization.landingpage_pagebuilder_layout_spacing_right;
    }
  }
}
