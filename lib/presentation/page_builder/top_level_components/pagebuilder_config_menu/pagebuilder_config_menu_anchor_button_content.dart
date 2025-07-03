import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuAnchorButtonContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuAnchorButtonContent(
      {super.key, required this.model});

  void updateTextProperties(PagebuilderAnchorButtonProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();

    if (model.elementType == PageBuilderWidgetType.anchorButton &&
        model.properties is PagebuilderAnchorButtonProperties) {
      return CollapsibleTile(title: "Section ID", children: [
        Text(
            "Gib bitte die Section ID ein, zu welcher gescrollt werden soll. Diese findest du in der jeweiligen Section.",
            style: themeData.textTheme.bodySmall),
        const SizedBox(height: 30),
        PagebuilderTextField(
            initialText: (model.properties as PagebuilderAnchorButtonProperties)
                .sectionID,
            placeholder: "Section ID",
            onChanged: (text) {
              final updatedProperties =
                  (model.properties as PagebuilderAnchorButtonProperties)
                      .copyWith(sectionID: text);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            })
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
