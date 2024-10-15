import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_widget_builder.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderSectionView extends StatefulWidget {
  final PageBuilderSection model;

  const LandingPageBuilderSectionView({super.key, required this.model});

  @override
  State<LandingPageBuilderSectionView> createState() =>
      _LandingPageBuilderSectionViewState();
}

class _LandingPageBuilderSectionViewState
    extends State<LandingPageBuilderSectionView> {
  final LandingPageBuilderWidgetBuilder widgetBuilder =
      LandingPageBuilderWidgetBuilder();
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    switch (widget.model.layout) {
      case PageBuilderSectionLayout.column:
      default:
        return MouseRegion(
          onEnter: (_) => setState(() {
            _isHovered = true;
          }),
          onExit: (_) => setState(() {
            _isHovered = false;
          }),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: widget.model.maxWidth ?? double.infinity),
            decoration: BoxDecoration(
              color: widget.model.backgroundColor,
              border: Border.all(
                color: _isHovered
                    ? themeData.colorScheme.primary
                    : Colors.transparent,
                width: 2.0,
              ),
            ),
            child: Column(
                children: widget.model.widgets != null
                    ? widget.model.widgets!
                        .map((widget) => widgetBuilder.build(widget))
                        .toList()
                    : []),
          ),
        );
    }
  }
}
