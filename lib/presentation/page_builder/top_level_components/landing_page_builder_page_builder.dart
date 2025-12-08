import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_zoom/pagebuilder_zoom_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/responsive/pagebuilder_responsive_breakpoint_size.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_section_builder.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_add_section_button.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_config_menu/landing_page_builder_config_menu.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorder_dimming_overlay.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_reorderable_element.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/pagebuilder_responsive_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderPageBuilder extends StatefulWidget {
  final PageBuilderPage model;
  final PagebuilderConfigMenuCubit? configMenuCubit;
  final bool isResponsivePreviewOpen;
  final VoidCallback onResponsivePreviewClose;
  final LandingPage? landingPage;

  const LandingPageBuilderPageBuilder({
    super.key,
    required this.model,
    this.configMenuCubit,
    required this.isResponsivePreviewOpen,
    required this.onResponsivePreviewClose,
    this.landingPage,
  });

  @override
  State<LandingPageBuilderPageBuilder> createState() =>
      _LandingPageBuilderPageBuilderState();
}

class _LandingPageBuilderPageBuilderState
    extends State<LandingPageBuilderPageBuilder> {
  late PagebuilderConfigMenuCubit pageBuilderMenuCubit;
  bool _isConfigMenuOpen = true;

  @override
  void initState() {
    super.initState();
    pageBuilderMenuCubit =
        widget.configMenuCubit ?? Modular.get<PagebuilderConfigMenuCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BlocConsumer<PagebuilderConfigMenuCubit, PagebuilderConfigMenuState>(
            bloc: pageBuilderMenuCubit,
            listener: (context, state) {
              if (state is PageBuilderConfigMenuOpenedState ||
                  state is PageBuilderSectionConfigMenuOpenedState) {
                setState(() {
                  _isConfigMenuOpen = true;
                });
              } else if (state is PageBuilderPageMenuOpenedState) {
                setState(() {
                  _isConfigMenuOpen = true;
                });
              } else if (state is PageBuilderConfigMenuClosedState) {
                setState(() {
                  _isConfigMenuOpen = false;
                });
              }
            },
            builder: (context, state) {
              if (state is PageBuilderPageMenuOpenedState) {
                return LandingPageBuilderConfigMenu(
                    key: ValueKey(state.id),
                    isOpen: _isConfigMenuOpen,
                    menuState: state,
                    model: null,
                    section: null,
                    landingPage: widget.landingPage,
                    closeMenu: () {
                      setState(() {
                        _isConfigMenuOpen = false;
                      });
                    });
              } else if (state is PageBuilderConfigMenuOpenedState) {
                return LandingPageBuilderConfigMenu(
                    key: ValueKey(state.model.id),
                    isOpen: _isConfigMenuOpen,
                    menuState: state,
                    model: state.model,
                    section: null,
                    landingPage: widget.landingPage,
                    closeMenu: () {
                      Modular.get<PagebuilderSelectionCubit>()
                          .selectWidget(null);
                      pageBuilderMenuCubit.closeConfigMenu();
                      setState(() {
                        _isConfigMenuOpen = false;
                      });
                    });
              } else if (state is PageBuilderSectionConfigMenuOpenedState) {
                return LandingPageBuilderConfigMenu(
                    key: ValueKey(state.model.id),
                    isOpen: _isConfigMenuOpen,
                    menuState: state,
                    model: null,
                    section: state.model,
                    allSections: widget.model.sections ?? [],
                    landingPage: widget.landingPage,
                    closeMenu: () {
                      Modular.get<PagebuilderSelectionCubit>()
                          .selectWidget(null);
                      pageBuilderMenuCubit.closeConfigMenu();
                      setState(() {
                        _isConfigMenuOpen = false;
                      });
                    });
              } else if (state is PageBuilderConfigMenuClosedState) {
                return LandingPageBuilderConfigMenu(
                    key: ValueKey(state.id),
                    isOpen: false,
                    menuState: state,
                    model: null,
                    section: null,
                    landingPage: widget.landingPage,
                    closeMenu: () {});
              } else {
                return const SizedBox.shrink();
              }
            }),
        Expanded(
          child: BlocBuilder<PagebuilderZoomCubit, PagebuilderZoomLevel>(
            bloc: Modular.get<PagebuilderZoomCubit>(),
            builder: (context, zoomLevel) {
              return PagebuilderReorderDimmingOverlay(
                zoomScale: zoomLevel.scale,
                child: Column(
                  children: [
                    if (widget.isResponsivePreviewOpen)
                      PagebuilderResponsiveToolbar(
                        onClose: widget.onResponsivePreviewClose,
                      ),
                    Expanded(
                      child: BlocBuilder<PagebuilderResponsiveBreakpointCubit,
                          PagebuilderResponsiveBreakpoint>(
                        bloc:
                            Modular.get<PagebuilderResponsiveBreakpointCubit>(),
                        builder: (context, breakpoint) {
                          final maxWidth =
                              PagebuilderResponsiveBreakpointSize.getWidth(
                                  breakpoint);

                          return Container(
                            color: const Color(0xFF323232),
                            alignment: Alignment.topCenter,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Center(
                                  child: ClipRect(
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      heightFactor: zoomLevel.scale,
                                      child: Transform(
                                        transform: Matrix4.diagonal3Values(
                                            zoomLevel.scale,
                                            zoomLevel.scale,
                                            1.0),
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          width: maxWidth,
                                          color: widget.model.backgroundColor,
                                          child: Column(
                                            children: [
                                              if (widget.model.sections !=
                                                      null &&
                                                  widget.model.sections!
                                                      .isNotEmpty)
                                                PagebuilderReorderableElement<
                                                    PageBuilderSection>(
                                                  containerId: "page-sections",
                                                  items: widget.model.sections!,
                                                  getItemId: (section) =>
                                                      section.id.value,
                                                  isSection: (section) => true,
                                                  onReorder:
                                                      (oldIndex, newIndex) {
                                                    Modular.get<
                                                            PagebuilderBloc>()
                                                        .add(
                                                            ReorderSectionsEvent(
                                                                oldIndex,
                                                                newIndex));
                                                  },
                                                  buildChild: (section,
                                                          index) =>
                                                      LandingPageBuilderSectionView(
                                                    model: section,
                                                    index: index,
                                                    landingPage:
                                                        widget.landingPage,
                                                  ),
                                                ),
                                              const PagebuilderAddSectionButton(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
