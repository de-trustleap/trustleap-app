// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/helpers/icon_utility.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_icon_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderIconView extends StatelessWidget {
  final PageBuilderIconProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderIconView({
    super.key,
    required this.properties,
    required this.widgetModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        final size = properties.size?.getValueForBreakpoint(breakpoint);

        return LandingPageBuilderWidgetContainer(
          model: widgetModel,
          child: Icon(IconUtility.getIconFromHexCode(properties.code),
              size: size, color: properties.color),
        );
      },
    );
  }
}
