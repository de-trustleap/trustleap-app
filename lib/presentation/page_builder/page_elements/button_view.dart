// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_button_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_or_constant_extensions.dart';
import 'package:finanzbegleiter/infrastructure/models/model_helper/alignment_mapper.dart';
import 'package:finanzbegleiter/presentation/page_builder/page_elements/pagebuilder_html_renderer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageBuilderButtonView extends StatelessWidget {
  final PageBuilderButtonProperties properties;
  final PageBuilderWidget widgetModel;

  const PageBuilderButtonView({
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
        final width =
            properties.width?.getValueForBreakpoint(breakpoint);
        final height =
            properties.height?.getValueForBreakpoint(breakpoint);

        return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: properties.backgroundPaint?.isColor == true
                ? properties.backgroundPaint?.color
                : null,
            gradient: properties.backgroundPaint?.isGradient == true
                ? properties.backgroundPaint?.gradient?.toFlutterGradient()
                : null,
            borderRadius: BorderRadius.circular(properties.border?.radius ?? 0),
            border: properties.border?.width != null &&
                    properties.border?.color != null
                ? Border.all(
                    width: properties.border!.width!,
                    color: properties.border!.color!,
                  )
                : null),
        alignment: AlignmentMapper.getAlignmentFromTextAlignment(
            properties.textProperties?.alignment?.getValue()),
        child: PagebuilderHtmlRenderer(
            textProperties: properties.textProperties,
            useInlineDisplay: true));
      },
    );
  }
}
