import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_anchor_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_button_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuAnchorButtonConfig extends StatelessWidget {
  final PageBuilderWidget model;

  const PagebuilderConfigMenuAnchorButtonConfig({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.anchorButton &&
        model.properties is PagebuilderAnchorButtonProperties) {
      final properties = model.properties as PagebuilderAnchorButtonProperties;
      final hoverProperties =
          model.hoverProperties as PagebuilderAnchorButtonProperties?;

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CollapsibleTile(
          title: localization.pagebuilder_anchor_button_config_title,
          children: [
            PagebuilderConfigMenuButtonConfig(
              properties: properties.buttonProperties,
              hoverProperties: hoverProperties?.buttonProperties,
              onChanged: (updatedButtonProperties) {
                final updatedProperties = properties.copyWith(
                  buttonProperties: updatedButtonProperties,
                );
                final updatedWidget =
                    model.copyWith(properties: updatedProperties);
                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              },
              onChangedHover: (updatedHoverButtonProperties) {
                final updatedHoverProperties =
                    updatedHoverButtonProperties == null
                        ? null
                        : (hoverProperties ??
                                PagebuilderAnchorButtonProperties(
                                  sectionName: properties.sectionName,
                                  buttonProperties: null,
                                ))
                            .copyWith(
                                buttonProperties: updatedHoverButtonProperties);

                final updatedWidget = model.copyWith(
                  hoverProperties: updatedHoverProperties,
                  removeHoverProperties: updatedHoverButtonProperties == null,
                );

                pagebuilderBloc.add(UpdateWidgetEvent(updatedWidget));
              },
            ),
          ],
        ),
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
