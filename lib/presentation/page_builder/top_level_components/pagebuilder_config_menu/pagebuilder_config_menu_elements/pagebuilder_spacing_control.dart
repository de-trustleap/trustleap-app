import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_spacing.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_number_stepper.dart';
import 'package:flutter/material.dart';

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: themeData.textTheme.bodySmall),
        const SizedBox(height: 16),
        _buildStepperRow([
          PageBuilderSpacingDirection.top,
          PageBuilderSpacingDirection.left
        ]),
        const SizedBox(height: 16),
        _buildStepperRow([
          PageBuilderSpacingDirection.bottom,
          PageBuilderSpacingDirection.right
        ]),
      ],
    );
  }

  Widget _buildStepperRow(List<PageBuilderSpacingDirection> directions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: directions
          .map((direction) => Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: _buildStepper(direction),
              ))
          .toList(),
    );
  }

  Widget _buildStepper(PageBuilderSpacingDirection direction) {
    double getValue() {
      final spacing = _getSpacing();
      switch (direction) {
        case PageBuilderSpacingDirection.top:
          return spacing?.top ?? 0.0;
        case PageBuilderSpacingDirection.left:
          return spacing?.left ?? 0.0;
        case PageBuilderSpacingDirection.bottom:
          return spacing?.bottom ?? 0.0;
        case PageBuilderSpacingDirection.right:
          return spacing?.right ?? 0.0;
      }
    }

    void updateValue(double value) {
      final spacing = _getSpacing() ??
          const PageBuilderSpacing(top: 0, bottom: 0, left: 0, right: 0);
      final updatedSpacing = spacing.copyWith(
        top: direction == PageBuilderSpacingDirection.top ? value : spacing.top,
        left: direction == PageBuilderSpacingDirection.left
            ? value
            : spacing.left,
        bottom: direction == PageBuilderSpacingDirection.bottom
            ? value
            : spacing.bottom,
        right: direction == PageBuilderSpacingDirection.right
            ? value
            : spacing.right,
      );
      onChanged(updatedSpacing);
    }

    return PagebuilderNumberStepper(
      initialValue: getValue().toInt(),
      minValue: 0,
      maxValue: 1000,
      placeholder: _getLabel(direction),
      onSelected: (value) => updateValue(value.toDouble()),
    );
  }

  PageBuilderSpacing? _getSpacing() {
    return spacingType == PageBuilderSpacingType.padding
        ? model.padding
        : model.margin;
  }

  String _getLabel(PageBuilderSpacingDirection direction) {
    switch (direction) {
      case PageBuilderSpacingDirection.top:
        return "Oben";
      case PageBuilderSpacingDirection.left:
        return "Links";
      case PageBuilderSpacingDirection.bottom:
        return "Unten";
      case PageBuilderSpacingDirection.right:
        return "Rechts";
    }
  }
}
