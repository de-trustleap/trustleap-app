import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_icon_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuIconContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuIconContent({super.key, required this.model});

  void updateTextProperties(
      PageBuilderIconProperties properties, PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.icon &&
        model.properties is PageBuilderIconProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_icon_content,
          children: [
            PagebuilderIconControl(
                title: localization
                    .landingpage_pagebuilder_icon_content_change_icon,
                initialIcon:
                    (model.properties as PageBuilderIconProperties).code,
                onSelected: (iconCode) {
                  final updatedProperties =
                      (model.properties as PageBuilderIconProperties)
                          .copyWith(code: iconCode);
                  updateTextProperties(updatedProperties, pagebuilderCubit);
                })
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
