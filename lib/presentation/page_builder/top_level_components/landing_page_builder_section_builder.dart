import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_factory.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_section_controls.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_widget_builder.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_invisible_color_filter.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/section_max_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageBuilderSectionView extends StatefulWidget {
  final PageBuilderSection model;
  final int index;
  final LandingPage? landingPage;

  const LandingPageBuilderSectionView({
    super.key,
    required this.model,
    required this.index,
    this.landingPage,
  });

  @override
  State<LandingPageBuilderSectionView> createState() =>
      _LandingPageBuilderSectionViewState();
}

class _LandingPageBuilderSectionViewState
    extends State<LandingPageBuilderSectionView> {
  late final LandingPageBuilderWidgetBuilder widgetBuilder;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    widgetBuilder =
        LandingPageBuilderWidgetBuilder(landingPage: widget.landingPage);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final selectionCubit = Modular.get<PagebuilderSelectionCubit>();
    final breakpointCubit = Modular.get<PagebuilderResponsiveBreakpointCubit>();

    switch (widget.model.layout) {
      case PageBuilderSectionLayout.column:
      default:
        final shouldConstrainBackground =
            widget.model.backgroundConstrained ?? false;
        final outerMaxWidth =
            shouldConstrainBackground ? widget.model.maxWidth : null;

        return RepaintBoundary(
          child: Center(
              child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: outerMaxWidth ?? double.infinity),
            child: BlocBuilder<PagebuilderDragCubit, PagebuilderDragCubitState>(
              bloc: Modular.get<PagebuilderDragCubit>(),
              builder: (context, dragState) {
                final isDragging = dragState.isDragging;
                return MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      _isHovered = true;
                    });
                  },
                  onExit: (_) {
                    if (!isDragging) {
                      setState(() {
                        _isHovered = false;
                      });
                    }
                  },
                  child: GestureDetector(
                    onDoubleTap: () {
                      Modular.get<PagebuilderSelectionCubit>()
                          .selectWidget(widget.model.id.value);
                      Modular.get<PagebuilderConfigMenuCubit>()
                          .openSectionConfigMenu(widget.model);
                    },
                    child:
                        BlocSelector<PagebuilderSelectionCubit, String?, bool>(
                      bloc: selectionCubit,
                      selector: (selectedSectionId) =>
                          selectedSectionId == widget.model.id.value,
                      builder: (context, isSelected) {
                        final dragCubit = Modular.get<PagebuilderDragCubit>();
                        final isLibraryDragTarget =
                            dragCubit.state.libraryDragTargetContainerId ==
                                widget.model.id.value;
                        final showBorder = (_isHovered && !isDragging) ||
                            isSelected ||
                            isLibraryDragTarget;

                        return BlocBuilder<PagebuilderResponsiveBreakpointCubit,
                            PagebuilderResponsiveBreakpoint>(
                          bloc: breakpointCubit,
                          builder: (context, breakpoint) {
                            final contentMode = widget.model.background
                                    ?.imageProperties?.contentMode
                                    ?.getValueForBreakpoint(breakpoint) ??
                                BoxFit.cover;
                            final isVisibleOnCurrentBreakpoint =
                                widget.model.visibleOn == null ||
                                    widget.model.visibleOn!
                                        .contains(breakpoint);
                            final viewportHeight = responsiveValue.screenHeight;
                            final isFullHeight = widget.model.fullHeight
                                    ?.getValueForBreakpoint(breakpoint) ??
                                false;

                            return Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                PagebuilderInvisibleColorFilter(
                                  isVisible: isVisibleOnCurrentBreakpoint,
                                  child: Container(
                                    width: double.infinity,
                                    constraints: isFullHeight
                                        ? BoxConstraints(
                                            minHeight: viewportHeight,
                                          )
                                        : null,
                                    decoration: BoxDecoration(
                                      color: widget.model.background
                                                  ?.backgroundPaint?.isColor ==
                                              true
                                          ? widget.model.background
                                              ?.backgroundPaint?.color
                                          : null,
                                      gradient: widget
                                                  .model
                                                  .background
                                                  ?.backgroundPaint
                                                  ?.isGradient ==
                                              true
                                          ? widget.model.background
                                              ?.backgroundPaint?.gradient
                                              ?.toFlutterGradient()
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
                                            child: Image.network(
                                                widget.model.background!
                                                    .imageProperties!.url!,
                                                fit: contentMode),
                                          )
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
                                                widget
                                                        .model
                                                        .background
                                                        ?.imageProperties
                                                        ?.url !=
                                                    null)) ...[
                                          Positioned.fill(
                                              child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color: widget
                                                                  .model
                                                                  .background!
                                                                  .overlayPaint!
                                                                  .isColor ==
                                                              true
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
                                        Container(
                                          alignment: Alignment.center,
                                          child: shouldConstrainBackground
                                              ? SectionMaxWidthProvider(
                                                  sectionMaxWidth:
                                                      widget.model.maxWidth,
                                                  child: widget.model.widgets !=
                                                              null &&
                                                          widget.model.widgets!
                                                              .isNotEmpty
                                                      ? PagebuilderReorderableElement<
                                                          PageBuilderWidget>(
                                                          containerId: widget
                                                              .model.id.value,
                                                          items: widget
                                                              .model.widgets!,
                                                          getItemId: (widget) =>
                                                              widget.id.value,
                                                          isContainer: (widget) =>
                                                              widget
                                                                  .elementType ==
                                                              PageBuilderWidgetType
                                                                  .container,
                                                          onReorder: (oldIndex,
                                                              newIndex) {
                                                            Modular.get<
                                                                    PagebuilderBloc>()
                                                                .add(ReorderWidgetEvent(
                                                                    widget
                                                                        .model
                                                                        .id
                                                                        .value,
                                                                    oldIndex,
                                                                    newIndex));
                                                          },
                                                          onAddWidget:
                                                              (widgetLibraryData,
                                                                  targetWidgetId,
                                                                  position) {
                                                            final newWidget =
                                                                PagebuilderWidgetFactory
                                                                    .createDefaultWidget(
                                                                        widgetLibraryData
                                                                            .widgetType);
                                                            Modular.get<
                                                                    PagebuilderBloc>()
                                                                .add(
                                                                    AddWidgetAtPositionEvent(
                                                              newWidget:
                                                                  newWidget,
                                                              targetWidgetId:
                                                                  targetWidgetId,
                                                              position:
                                                                  position,
                                                            ));
                                                          },
                                                          buildChild: (widget,
                                                                  index) =>
                                                              widgetBuilder
                                                                  .build(
                                                                      widget),
                                                        )
                                                      : const SizedBox.shrink(),
                                                )
                                              : ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      maxWidth: widget
                                                              .model.maxWidth ??
                                                          double.infinity),
                                                  child:
                                                      SectionMaxWidthProvider(
                                                    sectionMaxWidth:
                                                        widget.model.maxWidth,
                                                    child: widget.model
                                                                    .widgets !=
                                                                null &&
                                                            widget
                                                                .model
                                                                .widgets!
                                                                .isNotEmpty
                                                        ? PagebuilderReorderableElement<
                                                            PageBuilderWidget>(
                                                            containerId: widget
                                                                .model.id.value,
                                                            items: widget
                                                                .model.widgets!,
                                                            getItemId:
                                                                (widget) =>
                                                                    widget.id
                                                                        .value,
                                                            isContainer: (widget) =>
                                                                widget
                                                                    .elementType ==
                                                                PageBuilderWidgetType
                                                                    .container,
                                                            onReorder:
                                                                (oldIndex,
                                                                    newIndex) {
                                                              Modular.get<
                                                                      PagebuilderBloc>()
                                                                  .add(ReorderWidgetEvent(
                                                                      widget
                                                                          .model
                                                                          .id
                                                                          .value,
                                                                      oldIndex,
                                                                      newIndex));
                                                            },
                                                            onAddWidget:
                                                                (widgetLibraryData,
                                                                    targetWidgetId,
                                                                    position) {
                                                              final newWidget =
                                                                  PagebuilderWidgetFactory
                                                                      .createDefaultWidget(
                                                                          widgetLibraryData
                                                                              .widgetType);
                                                              Modular.get<
                                                                      PagebuilderBloc>()
                                                                  .add(
                                                                      AddWidgetAtPositionEvent(
                                                                newWidget:
                                                                    newWidget,
                                                                targetWidgetId:
                                                                    targetWidgetId,
                                                                position:
                                                                    position,
                                                              ));
                                                            },
                                                            buildChild: (widget,
                                                                    index) =>
                                                                widgetBuilder
                                                                    .build(
                                                                        widget),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                if (showBorder)
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isSelected
                                                ? themeData
                                                    .colorScheme.secondary
                                                : themeData.colorScheme.primary,
                                            width: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (showBorder) ...[
                                  LandingPageBuilderSectionControls(
                                    index: widget.index,
                                    onEditPressed: () {
                                      Modular.get<PagebuilderSelectionCubit>()
                                          .selectWidget(widget.model.id.value);
                                      Modular.get<PagebuilderConfigMenuCubit>()
                                          .openSectionConfigMenu(widget.model);
                                    },
                                    onDeletePressed: () {
                                      Modular.get<PagebuilderBloc>().add(
                                          DeleteSectionEvent(
                                              widget.model.id.value));
                                    },
                                    onDuplicatePressed: () {
                                      Modular.get<PagebuilderBloc>().add(
                                          DuplicateSectionEvent(
                                              widget.model.id.value));
                                    },
                                  )
                                ]
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          )),
        );
    }
  }
}
