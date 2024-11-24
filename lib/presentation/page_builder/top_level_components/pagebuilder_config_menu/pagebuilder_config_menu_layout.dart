import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_spacing_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuLayout extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuLayout({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);
    return CollapsibleTile(
        title: localization.landingpage_pagebuilder_layout_menu_title,
        children: [
          PagebuilderSpacingControl(
              title: localization.landingpage_pagebuilder_layout_menu_margin,
              spacingType: PageBuilderSpacingType.margin,
              model: model,
              onChanged: (margin) {
                final updatedWidget = model.copyWith(margin: margin);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              }),
          SizedBox(height: 24),
          PagebuilderSpacingControl(
              title: localization.landingpage_pagebuilder_layout_menu_padding,
              spacingType: PageBuilderSpacingType.padding,
              model: model,
              onChanged: (padding) {
                final updatedWidget = model.copyWith(padding: padding);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              })
        ]);
  }
}
