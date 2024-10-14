import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_widget_builder.dart';
import 'package:flutter/material.dart';

class LandingPageBuilderSectionBuilder {
  final LandingPageBuilderWidgetBuilder widgetBuilder =
      LandingPageBuilderWidgetBuilder();

  Widget buildSection(PageBuilderSection model) {
    switch (model.layout) {
      case PageBuilderSectionLayout.column:
      default:
        return Container(
          constraints:
              BoxConstraints(maxWidth: model.maxWidth ?? double.infinity),
          color: model.backgroundColor,
          child: Column(
              children: model.widgets != null
                  ? model.widgets!
                      .map((widget) => widgetBuilder.build(widget))
                      .toList()
                  : []),
        );
    }
  }
}
