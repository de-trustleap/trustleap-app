import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_calendly_properties.dart';
import 'package:finanzbegleiter/features/page_builder/domain/entities/pagebuilder_widget.dart';
import 'package:finanzbegleiter/features/page_builder/presentation/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagebuilderCalendly extends StatelessWidget {
  final PagebuilderCalendlyProperties properties;
  final PageBuilderWidget widgetModel;
  final int? index;

  const PagebuilderCalendly({
    super.key,
    required this.properties,
    required this.widgetModel,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
        PagebuilderResponsiveBreakpoint>(
      bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
      builder: (context, breakpoint) {
        final width = properties.width?.getValueForBreakpoint(breakpoint);
        final height = properties.height?.getValueForBreakpoint(breakpoint);

        return LandingPageBuilderWidgetContainer(
          model: widgetModel,
          index: index,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(properties.borderRadius ?? 0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(properties.borderRadius ?? 0),
              child: Image.asset(
                'assets/images/calendly_logo.png',
                width: width,
                height: height,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}