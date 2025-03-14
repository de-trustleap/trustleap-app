import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';

class PagebuilderVideoPlayerView extends StatelessWidget {
  final PagebuilderVideoPlayerProperties properties;
  final PageBuilderWidget widgetModel;
  const PagebuilderVideoPlayerView(
      {super.key, required this.properties, required this.widgetModel});

  @override
  Widget build(BuildContext context) {
    return LandingPageBuilderWidgetContainer(
      model: widgetModel,
      child: Container(
          width: properties.width ?? 200,
          height: properties.height ?? 200,
          color: Colors.black,
          child: const Center(
              child: Icon(Icons.play_arrow, color: Colors.white, size: 50))),
    );
  }
}
