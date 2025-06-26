import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuFooterConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuFooterConfig({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.footer &&
        model.properties is PagebuilderFooterProperties) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CollapsibleTile(
            title: localization
                .landingpage_pagebuilder_footer_config_privacy_policy,
            children: [
              PagebuilderConfigMenuTextConfig(
                  properties: (model.properties as PagebuilderFooterProperties)
                      .privacyPolicyTextProperties,
                  showHoverTabBar: false,
                  onChanged: (textProperties) {
                    final updatedProperties = (model.properties
                            as PagebuilderFooterProperties)
                        .copyWith(privacyPolicyTextProperties: textProperties);
                    final updatedWidget =
                        model.copyWith(properties: updatedProperties);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  },
                  onChangedHover: (textProperties) {
                    // TODO: PUT INTO FOOTER HOVER
                  })
            ]),
        const SizedBox(height: 10),
        CollapsibleTile(
          title: localization.landingpage_pagebuilder_footer_config_impressum,
          children: [
            PagebuilderConfigMenuTextConfig(
                properties: (model.properties as PagebuilderFooterProperties)
                    .impressumTextProperties,
                showHoverTabBar: false,
                onChanged: (textProperties) {
                  final updatedProperties =
                      (model.properties as PagebuilderFooterProperties)
                          .copyWith(impressumTextProperties: textProperties);
                  final updatedWidget =
                      model.copyWith(properties: updatedProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                },
                onChangedHover: (textProperties) {
                  // TODO: PUT INTO FOOTER HOVER
                })
          ],
        ),
        const SizedBox(height: 10),
        CollapsibleTile(
          title: localization
              .landingpage_pagebuilder_footer_config_initial_information,
          children: [
            PagebuilderConfigMenuTextConfig(
                properties: (model.properties as PagebuilderFooterProperties)
                    .initialInformationTextProperties,
                showHoverTabBar: false,
                onChanged: (textProperties) {
                  final updatedProperties =
                      (model.properties as PagebuilderFooterProperties)
                          .copyWith(
                              initialInformationTextProperties: textProperties);
                  final updatedWidget =
                      model.copyWith(properties: updatedProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                },
                onChangedHover: (textProperties) {
                  // TODO: PUT INTO FOOTER HOVER
                })
          ],
        ),
        const SizedBox(height: 10),
        CollapsibleTile(
          title: localization
              .landingpage_pagebuilder_footer_config_terms_and_conditions,
          children: [
            PagebuilderConfigMenuTextConfig(
                properties: (model.properties as PagebuilderFooterProperties)
                    .termsAndConditionsTextProperties,
                showHoverTabBar: false,
                onChanged: (textProperties) {
                  final updatedProperties =
                      (model.properties as PagebuilderFooterProperties)
                          .copyWith(
                              termsAndConditionsTextProperties: textProperties);
                  final updatedWidget =
                      model.copyWith(properties: updatedProperties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                },
                onChangedHover: (textProperties) {
                  // TODO: PUT INTO FOOTER HOVER
                })
          ],
        ),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
