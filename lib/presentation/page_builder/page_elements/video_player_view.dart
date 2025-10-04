import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderVideoPlayerView extends StatelessWidget {
  final PagebuilderVideoPlayerProperties properties;
  final PageBuilderWidget widgetModel;
  const PagebuilderVideoPlayerView(
      {super.key, required this.properties, required this.widgetModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        final width =
            properties.width?.getValueForBreakpoint(breakpoint) ?? 200;
        final height =
            properties.height?.getValueForBreakpoint(breakpoint) ?? 200;

        return LandingPageBuilderWidgetContainer(
          model: widgetModel,
          child: Container(
              width: width,
              height: height,
              color: Colors.black,
              child: const Center(
                  child:
                      Icon(Icons.play_arrow, color: Colors.white, size: 50))),
        );
      },
    );
  }
}
