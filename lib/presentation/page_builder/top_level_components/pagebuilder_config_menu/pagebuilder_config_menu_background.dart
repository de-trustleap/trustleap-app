import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_color_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuBackground extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuBackground({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();

    return CollapsibleTile(title: "Hintergrund", children: [
      PagebuilderColorControl(
          title: "Hintergrundfarbe",
          initialColor: model.backgroundColor ?? Colors.transparent,
          onSelected: (color) {
            final updatedWidget = model.copyWith(backgroundColor: color);
            pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
          }),
    ]);
  }
}
