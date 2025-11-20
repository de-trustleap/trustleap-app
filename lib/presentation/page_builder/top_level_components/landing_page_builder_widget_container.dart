// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_container_properties.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_controls.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/section_max_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderWidgetContainer extends StatefulWidget {
  final PageBuilderContainerProperties? properties;
  final PageBuilderWidget model;
  final Widget child;
  final int? index;

  const LandingPageBuilderWidgetContainer({
    super.key,
    this.properties,
    required this.model,
    required this.child,
    this.index,
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
    final selectionCubit = Modular.get<PagebuilderSelectionCubit>();
    final hoverCubit = Modular.get<PagebuilderHoverCubit>();

    return BlocSelector<PagebuilderSelectionCubit, String?, bool>(
      bloc: selectionCubit,
      selector: (selectedWidgetId) => selectedWidgetId == widgetID,
      builder: (context, isSelected) {
        return BlocSelector<PagebuilderHoverCubit, String?, bool>(
          bloc: hoverCubit,
          selector: (hoveredWidgetId) => hoveredWidgetId == widgetID,
          builder: (context, isHovered) {
            return BlocBuilder<PagebuilderDragCubit, bool>(
              bloc: Modular.get<PagebuilderDragCubit>(),
              builder: (context, isDragging) {
                final dragCubit = Modular.get<PagebuilderDragCubit>();
                final isLibraryDragTarget =
                    dragCubit.libraryDragTargetContainerId == widgetID;
                final showBorder = (isHovered && !isDragging) ||
                    isSelected ||
                    isLibraryDragTarget;

                return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
                    PagebuilderResponsiveBreakpoint>(
                  bloc: Modular.get<PagebuilderResponsiveBreakpointCubit>(),
                  builder: (context, breakpoint) {
                    final contentMode = widget
                            .model.background?.imageProperties?.contentMode
                            ?.getValueForBreakpoint(breakpoint) ??
                        BoxFit.cover;

                    final containerWidth = widget.properties?.width
                        ?.getValueForBreakpoint(breakpoint);
                    final containerHeight = widget.properties?.height
                        ?.getValueForBreakpoint(breakpoint);

                    return Container(
                      constraints: BoxConstraints(
                        maxWidth: _getEffectiveMaxWidth(context),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            widget.model.margin?.left
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0,
                            widget.model.margin?.top
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0,
                            widget.model.margin?.right
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0,
                            widget.model.margin?.bottom
                                    ?.getValueForBreakpoint(breakpoint) ??
                                0),
                        child: MouseRegion(
                          onEnter: (_) {
                            hoverCubit.setHovered(widgetID);
                          },
                          onExit: (_) {
                            if (!isDragging && hoverCubit.state == widgetID) {
                              hoverCubit.setHovered(null);
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: showBorder
                                      ? Border.all(
                                          color: isSelected
                                              ? themeData.colorScheme.secondary
                                              : themeData.colorScheme.primary,
                                          width: 2.0,
                                        )
                                      : null,
                                ),
                                child: Container(
                                  width: containerWidth,
                                  height: containerHeight,
                                  decoration: BoxDecoration(
                                    color: widget.model.background
                                                ?.backgroundPaint?.isColor ==
                                            true
                                        ? widget.model.background
                                            ?.backgroundPaint?.color
                                        : null,
                                    gradient: widget.model.background
                                                ?.backgroundPaint?.isGradient ==
                                            true
                                        ? widget.model.background
                                            ?.backgroundPaint?.gradient
                                            ?.toFlutterGradient()
                                        : null,
                                    borderRadius: widget
                                                .properties?.border?.radius !=
                                            null
                                        ? BorderRadius.circular(
                                            widget.properties!.border!.radius!)
                                        : null,
                                    border: widget.properties?.border?.width !=
                                                null &&
                                            widget.properties?.border?.color !=
                                                null
                                        ? Border.all(
                                            width: widget
                                                .properties!.border!.width!,
                                            color: widget
                                                .properties!.border!.color!,
                                          )
                                        : null,
                                    boxShadow: widget.properties?.shadow != null
                                        ? [
                                            BoxShadow(
                                              color: widget.properties!.shadow!
                                                      .color ??
                                                  Colors.black,
                                              spreadRadius: widget.properties!
                                                      .shadow!.spreadRadius ??
                                                  0,
                                              blurRadius: widget.properties!
                                                      .shadow!.blurRadius ??
                                                  0,
                                              offset: widget.properties!.shadow!
                                                      .offset ??
                                                  const Offset(0, 0),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Stack(
                                    children: [
                                      if (widget
                                                  .model
                                                  .background
                                                  ?.imageProperties
                                                  ?.localImage ==
                                              null &&
                                          widget.model.background
                                                  ?.imageProperties?.url !=
                                              null) ...[
                                        Positioned.fill(
                                            child: ClipRRect(
                                          borderRadius: widget.properties
                                                      ?.border?.radius !=
                                                  null
                                              ? BorderRadius.circular(widget
                                                  .properties!.border!.radius!)
                                              : BorderRadius.circular(0),
                                          child: Image.network(
                                              widget.model.background!
                                                  .imageProperties!.url!,
                                              fit: contentMode),
                                        ))
                                      ],
                                      if (widget.model.background
                                              ?.imageProperties?.localImage !=
                                          null)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: contentMode,
                                                image: MemoryImage(widget
                                                    .model
                                                    .background!
                                                    .imageProperties!
                                                    .localImage!),
                                              ),
                                              borderRadius: widget.properties
                                                          ?.border?.radius !=
                                                      null
                                                  ? BorderRadius.circular(widget
                                                      .properties!
                                                      .border!
                                                      .radius!)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      if (widget.model.background
                                                  ?.overlayPaint !=
                                              null &&
                                          (widget
                                                      .model
                                                      .background
                                                      ?.imageProperties
                                                      ?.localImage !=
                                                  null ||
                                              widget.model.background
                                                      ?.imageProperties?.url !=
                                                  null)) ...[
                                        Positioned.fill(
                                            child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    borderRadius: widget.properties?.border?.radius != null
                                                        ? BorderRadius.circular(
                                                            widget
                                                                .properties!
                                                                .border!
                                                                .radius!)
                                                        : null,
                                                    color: widget.model.background!.overlayPaint!.isColor == true
                                                        ? widget
                                                            .model
                                                            .background!
                                                            .overlayPaint!
                                                            .color
                                                        : null,
                                                    gradient: widget
                                                                .model
                                                                .background!
                                                                .overlayPaint!
                                                                .isGradient ==
                                                            true
                                                        ? widget
                                                            .model
                                                            .background!
                                                            .overlayPaint!
                                                            .gradient
                                                            ?.toFlutterGradient()
                                                        : null)))
                                      ],
                                      Align(
                                        alignment: widget.model.alignment
                                                ?.getValueForBreakpoint(
                                                    breakpoint) ??
                                            Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            widget.model.padding?.left
                                                    ?.getValueForBreakpoint(
                                                        breakpoint) ??
                                                0,
                                            widget.model.padding?.top
                                                    ?.getValueForBreakpoint(
                                                        breakpoint) ??
                                                0,
                                            widget.model.padding?.right
                                                    ?.getValueForBreakpoint(
                                                        breakpoint) ??
                                                0,
                                            widget.model.padding?.bottom
                                                    ?.getValueForBreakpoint(
                                                        breakpoint) ??
                                                0,
                                          ),
                                          child: widget.child,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (showBorder) ...[
                                LandingPageBuilderWidgetControls(
                                  index: widget.index,
                                  onEdit: () {
                                    Modular.get<PagebuilderSelectionCubit>()
                                        .selectWidget(widgetID);
                                    Modular.get<PagebuilderConfigMenuCubit>()
                                        .openConfigMenu(widget.model);
                                  },
                                  onDelete: () {
                                    Modular.get<PagebuilderBloc>()
                                        .add(DeleteWidgetEvent(widgetID));
                                  },
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  double _getEffectiveMaxWidth(BuildContext context) {
    final widgetMaxWidth = widget.model.maxWidth;
    final sectionProvider = SectionMaxWidthProvider.of(context);
    final sectionMaxWidth = sectionProvider?.sectionMaxWidth;

    if (widgetMaxWidth != null) {
      return widgetMaxWidth;
    }
    if (sectionMaxWidth != null) {
      return sectionMaxWidth;
    }
    return double.infinity;
  }
}
