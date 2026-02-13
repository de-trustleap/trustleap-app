import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_footer_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuFooterConfig extends StatelessWidget {
  final PageBuilderWidget model;
  final LandingPage? landingPage;

  const PagebuilderConfigMenuFooterConfig({
    super.key,
    required this.model,
    this.landingPage,
  });

  bool _shouldShow(String? landingPageValue) {
    return landingPageValue != null && landingPageValue.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.footer &&
        model.properties is PagebuilderFooterProperties) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_shouldShow(landingPage?.privacyPolicy)) ...[
          CollapsibleTile(
              title: localization
                  .landingpage_pagebuilder_footer_config_privacy_policy,
              children: [
                PagebuilderConfigMenuTextConfig(
                    properties: (model.properties as PagebuilderFooterProperties)
                        .privacyPolicyTextProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties as PagebuilderFooterProperties)
                            .privacyPolicyTextProperties
                        : null,
                    onChanged: (textProperties) {
                      final updatedProperties = (model.properties
                              as PagebuilderFooterProperties)
                          .copyWith(privacyPolicyTextProperties: textProperties);
                      final updatedWidget =
                          model.copyWith(properties: updatedProperties);
                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps =
                          model.hoverProperties as PagebuilderFooterProperties?;
                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PagebuilderFooterProperties(
                                      privacyPolicyTextProperties: null,
                                      impressumTextProperties: null,
                                      initialInformationTextProperties: null,
                                      termsAndConditionsTextProperties: null))
                              .copyWith(privacyPolicyTextProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ]),
          const SizedBox(height: 10),
        ],
        if (_shouldShow(landingPage?.impressum)) ...[
          CollapsibleTile(
            title: localization.landingpage_pagebuilder_footer_config_impressum,
            children: [
              PagebuilderConfigMenuTextConfig(
                  properties: (model.properties as PagebuilderFooterProperties)
                      .impressumTextProperties,
                  hoverProperties: model.hoverProperties != null
                      ? (model.hoverProperties as PagebuilderFooterProperties)
                          .impressumTextProperties
                      : null,
                  onChanged: (textProperties) {
                    final updatedProperties =
                        (model.properties as PagebuilderFooterProperties)
                            .copyWith(impressumTextProperties: textProperties);
                    final updatedWidget =
                        model.copyWith(properties: updatedProperties);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  },
                  onChangedHover: (hoverProps) {
                    final currentHoverProps =
                        model.hoverProperties as PagebuilderFooterProperties?;
                    final updatedHoverProps = hoverProps == null
                        ? null
                        : (currentHoverProps ??
                                const PagebuilderFooterProperties(
                                    privacyPolicyTextProperties: null,
                                    impressumTextProperties: null,
                                    initialInformationTextProperties: null,
                                    termsAndConditionsTextProperties: null))
                            .copyWith(impressumTextProperties: hoverProps);

                    final updatedWidget = model.copyWith(
                      hoverProperties: updatedHoverProps,
                      removeHoverProperties: hoverProps == null,
                    );

                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  })
            ],
          ),
          const SizedBox(height: 10),
        ],
        if (_shouldShow(landingPage?.initialInformation)) ...[
          CollapsibleTile(
            title: localization
                .landingpage_pagebuilder_footer_config_initial_information,
            children: [
              PagebuilderConfigMenuTextConfig(
                  properties: (model.properties as PagebuilderFooterProperties)
                      .initialInformationTextProperties,
                  hoverProperties: model.hoverProperties != null
                      ? (model.hoverProperties as PagebuilderFooterProperties)
                          .initialInformationTextProperties
                      : null,
                  onChanged: (textProperties) {
                    final updatedProperties =
                        (model.properties as PagebuilderFooterProperties)
                            .copyWith(
                                initialInformationTextProperties: textProperties);
                    final updatedWidget =
                        model.copyWith(properties: updatedProperties);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  },
                  onChangedHover: (hoverProps) {
                    final currentHoverProps =
                        model.hoverProperties as PagebuilderFooterProperties?;
                    final updatedHoverProps = hoverProps == null
                        ? null
                        : (currentHoverProps ??
                                const PagebuilderFooterProperties(
                                    privacyPolicyTextProperties: null,
                                    impressumTextProperties: null,
                                    initialInformationTextProperties: null,
                                    termsAndConditionsTextProperties: null))
                            .copyWith(
                                initialInformationTextProperties: hoverProps);

                    final updatedWidget = model.copyWith(
                      hoverProperties: updatedHoverProps,
                      removeHoverProperties: hoverProps == null,
                    );

                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  })
            ],
          ),
          const SizedBox(height: 10),
        ],
        if (_shouldShow(landingPage?.termsAndConditions)) ...[
          CollapsibleTile(
            title: localization
                .landingpage_pagebuilder_footer_config_terms_and_conditions,
            children: [
              PagebuilderConfigMenuTextConfig(
                  properties: (model.properties as PagebuilderFooterProperties)
                      .termsAndConditionsTextProperties,
                  hoverProperties: model.hoverProperties != null
                      ? (model.hoverProperties as PagebuilderFooterProperties)
                          .termsAndConditionsTextProperties
                      : null,
                  onChanged: (textProperties) {
                    final updatedProperties =
                        (model.properties as PagebuilderFooterProperties)
                            .copyWith(
                                termsAndConditionsTextProperties: textProperties);
                    final updatedWidget =
                        model.copyWith(properties: updatedProperties);
                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  },
                  onChangedHover: (hoverProps) {
                    final currentHoverProps =
                        model.hoverProperties as PagebuilderFooterProperties?;
                    final updatedHoverProps = hoverProps == null
                        ? null
                        : (currentHoverProps ??
                                const PagebuilderFooterProperties(
                                    privacyPolicyTextProperties: null,
                                    impressumTextProperties: null,
                                    initialInformationTextProperties: null,
                                    termsAndConditionsTextProperties: null))
                            .copyWith(
                                termsAndConditionsTextProperties: hoverProps);

                    final updatedWidget = model.copyWith(
                      hoverProperties: updatedHoverProps,
                      removeHoverProperties: hoverProps == null,
                    );

                    pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                  })
            ],
          ),
        ],
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
