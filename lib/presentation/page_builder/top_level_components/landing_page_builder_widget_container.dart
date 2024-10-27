// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageBuilderWidgetContainer extends StatefulWidget {
  final PageBuilderContainerProperties? properties;
  final PageBuilderWidget model;
  final Widget child;

  const LandingPageBuilderWidgetContainer({
    super.key,
    this.properties,
    required this.model,
    required this.child,
  });

  @override
  State<LandingPageBuilderWidgetContainer> createState() =>
      _LandingPageBuilderWidgetContainerState();
}

class _LandingPageBuilderWidgetContainerState
    extends State<LandingPageBuilderWidgetContainer> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final widgetID = widget.model.id.value;

    return BlocBuilder<PagebuilderHoverCubit, String?>(
      builder: (context, hoveredWidgetId) {
        final isHovered = hoveredWidgetId == widgetID;
        return Container(
          constraints: BoxConstraints(
              maxWidth: widget.model.maxWidth ?? double.infinity),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widget.model.padding?.left ?? 0,
                widget.model.padding?.top ?? 0,
                widget.model.padding?.right ?? 0,
                widget.model.padding?.bottom ?? 0),
            child: MouseRegion(
              onEnter: (_) {
                BlocProvider.of<PagebuilderHoverCubit>(context)
                    .setHovered(widgetID);
              },
              onExit: (_) {
                if (BlocProvider.of<PagebuilderHoverCubit>(context).state ==
                    widgetID) {
                  BlocProvider.of<PagebuilderHoverCubit>(context)
                      .setHovered(null);
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isHovered
                            ? themeData.colorScheme.primary
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.model.backgroundColor,
                        borderRadius: widget.properties?.borderRadius != null
                            ? BorderRadius.circular(
                                widget.properties!.borderRadius!)
                            : null,
                        boxShadow: widget.properties?.shadow != null
                            ? [
                                BoxShadow(
                                  color: widget.properties!.shadow!.color ??
                                      Colors.black,
                                  spreadRadius:
                                      widget.properties!.shadow!.spreadRadius ??
                                          0,
                                  blurRadius:
                                      widget.properties!.shadow!.blurRadius ??
                                          0,
                                  offset: widget.properties!.shadow!.offset ??
                                      const Offset(0, 0),
                                ),
                              ]
                            : null,
                      ),
                      alignment: widget.model.alignment ?? Alignment.center,
                      child: widget.child,
                    ),
                  ),
                  if (isHovered) ...[
                    const LandingPageBuilderWidgetEditButton()
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
