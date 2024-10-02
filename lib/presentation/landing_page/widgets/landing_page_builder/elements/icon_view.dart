// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PageBuilderIconView extends StatelessWidget {
  final PageBuilderIconProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderIconView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  IconData _getIconFromHexCode(String? hexCode) {
    int codePoint =
        int.tryParse(hexCode?.replaceFirst("0x", "") ?? "", radix: 16) ?? 0;
    return IconData(codePoint, fontFamily: 'MaterialIcons');
  }

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      child: Icon(_getIconFromHexCode(properties.code),
          size: properties.size, color: properties.color),
    );
  }
}
