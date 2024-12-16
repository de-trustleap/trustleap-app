import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuTextContent({super.key, required this.model});

  void updateTextProperties(
      PageBuilderTextProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    if (model.elementType == PageBuilderWidgetType.text &&
        model.properties is PageBuilderTextProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_text_config_content_title,
          children: [
            PagebuilderTextField(
                model: model,
                onChanged: (text) {
                  final updatedProperties =
                      (model.properties as PageBuilderTextProperties)
                          .copyWith(text: text);
                  updateTextProperties(updatedProperties, pagebuilderCubit);
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
