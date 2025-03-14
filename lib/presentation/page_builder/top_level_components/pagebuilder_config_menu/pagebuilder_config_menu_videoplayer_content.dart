import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuVideoPlayerContent extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuVideoPlayerContent(
      {super.key, required this.model});

  void updateTextProperties(PagebuilderVideoPlayerProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final pagebuilderCubit = Modular.get<PagebuilderBloc>();
    if (model.elementType == PageBuilderWidgetType.videoPlayer &&
        model.properties is PagebuilderVideoPlayerProperties) {
      return CollapsibleTile(title: "Youtube Link", children: [
        Text(
            "Gib hier bitte den Youtube Link an, über den dein Video erreichbar ist.",
            style: themeData.textTheme.bodySmall),
        const SizedBox(height: 30),
        PagebuilderTextField(
            initialText:
                (model.properties as PagebuilderVideoPlayerProperties).link,
            placeholder: "Youtube Link",
            onChanged: (text) {
              final updatedProperties =
                  (model.properties as PagebuilderVideoPlayerProperties)
                      .copyWith(link: text);
              updateTextProperties(updatedProperties, pagebuilderCubit);
            })
      ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
