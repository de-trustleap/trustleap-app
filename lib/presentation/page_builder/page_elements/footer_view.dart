import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/textstyle_parser.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderFooterView extends StatelessWidget {
  final PagebuilderFooterProperties properties;
  final PageBuilderWidget widgetModel;
  const PagebuilderFooterView(
      {super.key, required this.properties, required this.widgetModel});

  @override
  Widget build(BuildContext context) {
    final TextStyleParser parser = TextStyleParser();

    return LandingPageBuilderWidgetContainer(
        model: widgetModel,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (properties.privacyPolicyTextProperties != null) ...[
                Text(properties.privacyPolicyTextProperties?.text ?? "",
                    style: parser.getTextStyleFromProperties(
                        properties.privacyPolicyTextProperties),
                    textAlign:
                        properties.privacyPolicyTextProperties?.alignment ??
                            TextAlign.center)
              ],
              if (properties.impressumTextProperties != null) ...[
                const SizedBox(width: 8),
                Text("|",
                    style: parser.getTextStyleFromProperties(
                        properties.impressumTextProperties)),
                const SizedBox(width: 8),
                Text(properties.impressumTextProperties?.text ?? "",
                    style: parser.getTextStyleFromProperties(
                        properties.impressumTextProperties),
                    textAlign: properties.impressumTextProperties?.alignment ??
                        TextAlign.center),
              ],
              if (properties.initialInformationTextProperties != null) ...[
                const SizedBox(width: 8),
                Text("|",
                    style: parser.getTextStyleFromProperties(
                        properties.impressumTextProperties)),
                const SizedBox(width: 8),
                Text(properties.initialInformationTextProperties?.text ?? "",
                    style: parser.getTextStyleFromProperties(
                        properties.initialInformationTextProperties),
                    textAlign: properties
                            .initialInformationTextProperties?.alignment ??
                        TextAlign.center),
              ],
              if (properties.termsAndConditionsTextProperties != null) ...[
                const SizedBox(width: 8),
                Text("|",
                    style: parser.getTextStyleFromProperties(
                        properties.impressumTextProperties)),
                const SizedBox(width: 8),
                Text(properties.termsAndConditionsTextProperties?.text ?? "",
                    style: parser.getTextStyleFromProperties(
                        properties.termsAndConditionsTextProperties),
                    textAlign: properties
                            .termsAndConditionsTextProperties?.alignment ??
                        TextAlign.center),
              ]
            ]));
  }
}
