import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_faq_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/pagebuilder_faq_item_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderFaqView extends StatelessWidget {
  final PageBuilderFaqProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;

  const PagebuilderFaqView({
    super.key,
    required this.properties,
    required this.widgetModel,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final items = properties.items ?? [];

    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      index: index,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            PagebuilderFaqItemWidget(
              item: items[i],
              properties: properties,
              isLast: i == items.length - 1,
            ),
        ],
      ),
    );
  }
}
