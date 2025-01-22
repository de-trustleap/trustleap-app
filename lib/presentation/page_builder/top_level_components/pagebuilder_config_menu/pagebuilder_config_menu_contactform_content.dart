import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_contact_form_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuContactFormContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuContactFormContent(
      {super.key, required this.model});

  void updateTextProperties(PageBuilderContactFormProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.contactForm &&
        model.properties is PageBuilderContactFormProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_contactform_content_email,
          children: [
            Text(
                localization
                    .landingpage_pagebuilder_contactform_content_email_subtitle,
                style: themeData.textTheme.bodySmall),
            const SizedBox(height: 30),
            PagebuilderTextField(
                initialText:
                    (model.properties as PageBuilderContactFormProperties)
                        .email,
                placeholder: localization
                    .landingpage_pagebuilder_contactform_content_email_placeholder,
                onChanged: (text) {
                  final updatedProperties =
                      (model.properties as PageBuilderContactFormProperties)
                          .copyWith(email: text);
                  updateTextProperties(updatedProperties, pagebuilderCubit);
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
