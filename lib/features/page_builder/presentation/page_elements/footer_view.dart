import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/page_elements/textstyle_parser.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderFooterView extends StatelessWidget {
  final PagebuilderFooterProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;
  final LandingPage? landingPage;

  const PagebuilderFooterView({
    super.key,
    required this.properties,
    required this.widgetModel,
    this.index,
    this.landingPage,
  });

  bool _shouldShow(String? landingPageValue) {
    return landingPageValue != null && landingPageValue.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyleParser parser = TextStyleParser();

    // Erstelle Liste der sichtbaren Einträge
    final List<Widget> visibleItems = [];

    if (properties.privacyPolicyTextProperties != null &&
        _shouldShow(landingPage?.privacyPolicy)) {
      visibleItems.add(
        Text(properties.privacyPolicyTextProperties!.text ?? "",
            style: parser.getTextStyleFromProperties(
                properties.privacyPolicyTextProperties),
            textAlign:
                properties.privacyPolicyTextProperties?.alignment?.getValue() ??
                    TextAlign.center),
      );
    }

    if (properties.impressumTextProperties != null &&
        _shouldShow(landingPage?.impressum)) {
      visibleItems.add(
        Text(properties.impressumTextProperties!.text ?? "",
            style: parser.getTextStyleFromProperties(
                properties.impressumTextProperties),
            textAlign:
                properties.impressumTextProperties?.alignment?.getValue() ??
                    TextAlign.center),
      );
    }

    if (properties.initialInformationTextProperties != null &&
        _shouldShow(landingPage?.initialInformation)) {
      visibleItems.add(
        Text(properties.initialInformationTextProperties!.text ?? "",
            style: parser.getTextStyleFromProperties(
                properties.initialInformationTextProperties),
            textAlign: properties
                    .initialInformationTextProperties?.alignment?.getValue() ??
                TextAlign.center),
      );
    }

    if (properties.termsAndConditionsTextProperties != null &&
        _shouldShow(landingPage?.termsAndConditions)) {
      visibleItems.add(
        Text(properties.termsAndConditionsTextProperties!.text ?? "",
            style: parser.getTextStyleFromProperties(
                properties.termsAndConditionsTextProperties),
            textAlign: properties
                    .termsAndConditionsTextProperties?.alignment?.getValue() ??
                TextAlign.center),
      );
    }

    // Füge Trennzeichen zwischen den Einträgen ein
    final List<Widget> children = [];
    for (int i = 0; i < visibleItems.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: 8));
        children.add(
          Text("|",
              style: parser.getTextStyleFromProperties(
                  properties.impressumTextProperties ??
                      properties.privacyPolicyTextProperties)),
        );
        children.add(const SizedBox(width: 8));
      }
      children.add(visibleItems[i]);
    }

    return LandingPageBuilderWidgetContainer(
        model: widgetModel,
        index: index,
        child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: children));
  }
}
