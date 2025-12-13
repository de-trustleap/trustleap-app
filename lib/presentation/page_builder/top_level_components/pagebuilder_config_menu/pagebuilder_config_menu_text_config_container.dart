import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_global_styles.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_text_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_text_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuTextConfigContainer extends StatelessWidget {
  final PageBuilderWidget model;
  final PageBuilderGlobalStyles? globalStyles;

  const PagebuilderConfigMenuTextConfigContainer({
    super.key,
    required this.model,
    this.globalStyles,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    if (model.elementType == PageBuilderWidgetType.text &&
        model.properties is PageBuilderTextProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_text_config_text_title,
          children: [
            PagebuilderConfigMenuTextConfig(
                properties: model.properties as PageBuilderTextProperties,
                hoverProperties: model.hoverProperties != null
                    ? model.hoverProperties as PageBuilderTextProperties
                    : null,
                showHoverTabBar: true,
                hideColorPicker: true,
                globalStyles: globalStyles,
                onChanged: (properties) {
                  final updatedWidget = model.copyWith(properties: properties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                },
                onChangedHover: (properties) {
                  final updatedWidget = properties == null
                      ? model.copyWith(removeHoverProperties: true)
                      : model.copyWith(hoverProperties: properties);
                  pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
