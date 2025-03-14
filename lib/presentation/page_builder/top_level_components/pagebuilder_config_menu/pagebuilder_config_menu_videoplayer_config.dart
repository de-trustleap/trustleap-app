import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderConfigMenuVideoPlayerConfig extends StatelessWidget {
  final PageBuilderWidget model;
  const PagebuilderConfigMenuVideoPlayerConfig(
      {super.key, required this.model});

  void updateVideoPlayerProperties(PagebuilderVideoPlayerProperties properties,
      PagebuilderBloc pagebuilderCubit) {
    final updatedWidget = model.copyWith(properties: properties);
    pagebuilderCubit.add(UpdateWidgetEvent(updatedWidget));
  }

  @override
  Widget build(BuildContext context) {
    final pagebuilderBloc = Modular.get<PagebuilderBloc>();
    final localization = AppLocalizations.of(context);

    if (model.elementType == PageBuilderWidgetType.videoPlayer &&
        model.properties is PagebuilderVideoPlayerProperties) {
      return CollapsibleTile(
          title: localization.landingpage_pagebuilder_video_player_config_title,
          children: [
            PagebuilderSizeControl(
                width: (model.properties as PagebuilderVideoPlayerProperties)
                        .width ??
                    0,
                height: (model.properties as PagebuilderVideoPlayerProperties)
                        .height ??
                    0,
                onChanged: (size) {
                  final updatedProperties =
                      (model.properties as PagebuilderVideoPlayerProperties)
                          .copyWith(width: size.width, height: size.height);
                  updateVideoPlayerProperties(
                      updatedProperties, pagebuilderBloc);
                }),
          ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
