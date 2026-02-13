import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_video_player_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/custom_collapsible_tile.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_responsive_config_helper.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/pagebuilder_config_menu/pagebuilder_config_menu_elements/pagebuilder_size_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
          PagebuilderResponsiveBreakpoint>(
        bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
        builder: (context, currentBreakpoint) {
          final helper = PagebuilderResponsiveConfigHelper(currentBreakpoint);
          final props = model.properties as PagebuilderVideoPlayerProperties;

          return CollapsibleTile(
              title: localization
                  .landingpage_pagebuilder_video_player_config_title,
              children: [
                PagebuilderSizeControl(
                    width: helper.getValue(props.width) ?? 0,
                    height: helper.getValue(props.height) ?? 0,
                    currentBreakpoint: currentBreakpoint,
                    onChanged: (size) {
                      final updatedProperties = props.copyWith(
                          width: helper.setValue(props.width, size.width),
                          height: helper.setValue(props.height, size.height));
                      updateVideoPlayerProperties(
                          updatedProperties, pagebuilderBloc);
                    }),
              ]);
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
