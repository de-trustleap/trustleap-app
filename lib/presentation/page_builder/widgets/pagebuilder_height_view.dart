import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_height_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderHeightView extends StatelessWidget {
  final PageBuilderWidget model;

  const PageBuilderHeightView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final properties = model.properties as PageBuilderHeightProperties;

    return LandingPageBuilderWidgetContainer(
      model: model,
      child: BlocBuilder<PagebuilderResponsiveBreakpointCubit,
          PagebuilderResponsiveBreakpoint>(
        bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
        builder: (context, breakpoint) {
          final height =
              (properties.height?.getValueForBreakpoint(breakpoint) ?? 40)
                  .toDouble();
          return SizedBox(height: height);
        },
      ),
    );
  }
}
