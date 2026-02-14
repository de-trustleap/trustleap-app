import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_button_config.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_textfield_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuContactFormConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuContactFormConfig(
      {super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.contactForm &&
        model.properties is PageBuilderContactFormProperties) {
      return Column(
        children: [
          CollapsibleTile(
              title: localization
                  .pagebuilder_contact_form_config_name_textfield_title,
              children: [
                PagebuilderConfigMenuTextfieldConfig(
                    properties:
                        (model.properties as PageBuilderContactFormProperties)
                            .nameTextFieldProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties
                                as PageBuilderContactFormProperties)
                            .nameTextFieldProperties
                        : null,
                    onChanged: (properties) {
                      if (model.properties
                          is PageBuilderContactFormProperties) {
                        final updatedProperties = (model.properties
                                as PageBuilderContactFormProperties)
                            .copyWith(nameTextFieldProperties: properties);
                        final updatedWidget =
                            model.copyWith(properties: updatedProperties);
                        pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                      }
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps = model.hoverProperties
                          as PageBuilderContactFormProperties?;

                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PageBuilderContactFormProperties(
                                      email: null,
                                      nameTextFieldProperties: null,
                                      emailTextFieldProperties: null,
                                      phoneTextFieldProperties: null,
                                      messageTextFieldProperties: null,
                                      buttonProperties: null))
                              .copyWith(nameTextFieldProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ]),
          const SizedBox(height: 8),
          CollapsibleTile(
              title: localization
                  .pagebuilder_contact_form_config_email_textfield_title,
              children: [
                PagebuilderConfigMenuTextfieldConfig(
                    properties:
                        (model.properties as PageBuilderContactFormProperties)
                            .emailTextFieldProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties
                                as PageBuilderContactFormProperties)
                            .emailTextFieldProperties
                        : null,
                    onChanged: (properties) {
                      if (model.properties
                          is PageBuilderContactFormProperties) {
                        final updatedProperties = (model.properties
                                as PageBuilderContactFormProperties)
                            .copyWith(emailTextFieldProperties: properties);
                        final updatedWidget =
                            model.copyWith(properties: updatedProperties);
                        pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                      }
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps = model.hoverProperties
                          as PageBuilderContactFormProperties?;

                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PageBuilderContactFormProperties(
                                      email: null,
                                      nameTextFieldProperties: null,
                                      emailTextFieldProperties: null,
                                      phoneTextFieldProperties: null,
                                      messageTextFieldProperties: null,
                                      buttonProperties: null))
                              .copyWith(emailTextFieldProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ]),
          const SizedBox(height: 8),
          CollapsibleTile(
              title: localization
                  .pagebuilder_contact_form_config_phone_textfield_title,
              children: [
                PagebuilderConfigMenuTextfieldConfig(
                    properties:
                        (model.properties as PageBuilderContactFormProperties)
                            .phoneTextFieldProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties
                                as PageBuilderContactFormProperties)
                            .phoneTextFieldProperties
                        : null,
                    onChanged: (properties) {
                      if (model.properties
                          is PageBuilderContactFormProperties) {
                        final updatedProperties = (model.properties
                                as PageBuilderContactFormProperties)
                            .copyWith(phoneTextFieldProperties: properties);
                        final updatedWidget =
                            model.copyWith(properties: updatedProperties);
                        pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                      }
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps = model.hoverProperties
                          as PageBuilderContactFormProperties?;

                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PageBuilderContactFormProperties(
                                      email: null,
                                      nameTextFieldProperties: null,
                                      emailTextFieldProperties: null,
                                      phoneTextFieldProperties: null,
                                      messageTextFieldProperties: null,
                                      buttonProperties: null))
                              .copyWith(phoneTextFieldProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ]),
          const SizedBox(height: 8),
          CollapsibleTile(
              title: localization
                  .pagebuilder_contact_form_config_message_textfield_title,
              children: [
                PagebuilderConfigMenuTextfieldConfig(
                    properties:
                        (model.properties as PageBuilderContactFormProperties)
                            .messageTextFieldProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties
                                as PageBuilderContactFormProperties)
                            .messageTextFieldProperties
                        : null,
                    onChanged: (properties) {
                      if (model.properties
                          is PageBuilderContactFormProperties) {
                        final updatedProperties = (model.properties
                                as PageBuilderContactFormProperties)
                            .copyWith(messageTextFieldProperties: properties);
                        final updatedWidget =
                            model.copyWith(properties: updatedProperties);
                        pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                      }
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps = model.hoverProperties
                          as PageBuilderContactFormProperties?;

                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PageBuilderContactFormProperties(
                                      email: null,
                                      nameTextFieldProperties: null,
                                      emailTextFieldProperties: null,
                                      phoneTextFieldProperties: null,
                                      messageTextFieldProperties: null,
                                      buttonProperties: null))
                              .copyWith(messageTextFieldProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ]),
          const SizedBox(height: 8),
          CollapsibleTile(
              title: localization.pagebuilder_contact_form_config_button_title,
              children: [
                PagebuilderConfigMenuButtonConfig(
                    properties:
                        (model.properties as PageBuilderContactFormProperties)
                            .buttonProperties,
                    hoverProperties: model.hoverProperties != null
                        ? (model.hoverProperties
                                as PageBuilderContactFormProperties)
                            .buttonProperties
                        : null,
                    onChanged: (buttonProperties) {
                      if (model.properties
                          is PageBuilderContactFormProperties) {
                        final updatedProperties = (model.properties
                                as PageBuilderContactFormProperties)
                            .copyWith(buttonProperties: buttonProperties);
                        final updatedWidget =
                            model.copyWith(properties: updatedProperties);
                        pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                      }
                    },
                    onChangedHover: (hoverProps) {
                      final currentHoverProps = model.hoverProperties
                          as PageBuilderContactFormProperties?;

                      final updatedHoverProps = hoverProps == null
                          ? null
                          : (currentHoverProps ??
                                  const PageBuilderContactFormProperties(
                                      email: null,
                                      nameTextFieldProperties: null,
                                      emailTextFieldProperties: null,
                                      phoneTextFieldProperties: null,
                                      messageTextFieldProperties: null,
                                      buttonProperties: null))
                              .copyWith(buttonProperties: hoverProps);

                      final updatedWidget = model.copyWith(
                        hoverProperties: updatedHoverProps,
                        removeHoverProperties: hoverProps == null,
                      );

                      pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                    })
              ])
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
