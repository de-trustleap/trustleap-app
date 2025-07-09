import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/page_builder/landing_page_builder_appbar.dart';
import 'package:finanzbegleiter/presentation/page_builder/landing_page_builder_html_events.dart';
import 'package:finanzbegleiter/presentation/page_builder/pagebuilder_widget_finder.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_hierarchy_helper.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_hierarchy_overlay.dart';
import 'package:finanzbegleiter/presentation/page_builder/top_level_components/landing_page_builder_page_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageBuilderView extends StatefulWidget {
  const LandingPageBuilderView({super.key});

  @override
  State<LandingPageBuilderView> createState() => _LandingPageBuilderViewState();
}

class _LandingPageBuilderViewState extends State<LandingPageBuilderView> {
  late PagebuilderContent pageBuilderContent;
  late String id;
  late LandingPageBuilderHtmlEvents htmlEvents;
  bool isUpdated = false;
  bool _isHierarchyOverlayOpen = false;
  final widgetFinder = PagebuilderWidgetFinder();
  final pageBuilderMenuCubit = Modular.get<PagebuilderConfigMenuCubit>();

  @override
  void initState() {
    super.initState();

    id = Modular.args.params["id"] ?? "";
    htmlEvents = LandingPageBuilderHtmlEvents();
    BlocProvider.of<MenuCubit>(context).collapseMenu(true);
    Modular.get<PagebuilderBloc>().add(GetLandingPageEvent(id));
  }

  @override
  void dispose() {
    if (kIsWeb) {
      htmlEvents.removeListener();
    }
    super.dispose();
  }

  void _showSaveFailureDialog(AppLocalizations localizations) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title:
                  localizations.landingpage_pagebuilder_save_error_alert_title,
              message: localizations
                  .landingpage_pagebuilder_save_error_alert_message,
              actionButtonTitle:
                  localizations.landingpage_pagebuilder_save_error_alert_button,
              actionButtonAction: () => CustomNavigator.pop());
        });
  }

  PageBuilderWidget? findSectionByWidgetId(
      PagebuilderContent content, UniqueID widgetId) {
    for (var section in content.content?.sections ?? []) {
      for (var widget in section.widgets ?? []) {
        if (widget.id == widgetId) {
          return section;
        }
        // Falls das Widget ein Container ist und Kinder hat, durchsuche die Kinder auch
        if (widget.children != null) {
          for (var child in widget.children!) {
            if (child.id == widgetId) {
              return section;
            }
          }
        }
      }
    }
    // Wenn nichts gefunden wird, gebe null zurück
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pageBuilderCubit = Modular.get<PagebuilderBloc>();

    return BlocProvider(
      create: (context) => Modular.get<PagebuilderSelectionCubit>(),
      child: BlocConsumer<PagebuilderBloc, PagebuilderState>(
        bloc: pageBuilderCubit,
        listener: (context, state) {
          if (state is GetLandingPageAndUserSuccessState) {
            pageBuilderContent = state.content;
            if (!state.saveLoading && state.saveFailure != null) {
              _showSaveFailureDialog(localization);
              htmlEvents.disableLeavePageListeners();
              isUpdated = false;
            } else if (!state.saveLoading && state.saveSuccessful != null) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.landingpage_pagebuilder_save_success_snackbar);
              htmlEvents.disableLeavePageListeners();
              isUpdated = false;
            } else if (state.isUpdated != null && state.isUpdated!) {
              htmlEvents.enableLeavePageListeners(localization);
              isUpdated = true;
              final configMenuCubit = Modular.get<PagebuilderConfigMenuCubit>();
              final currentState = configMenuCubit.state;
              if (currentState is PageBuilderConfigMenuOpenedState &&
                  state.content.content != null) {
                final updatedModel = widgetFinder.findWidgetById(
                    state.content.content!, currentState.model.id);
                if (updatedModel != null) {
                  configMenuCubit.openConfigMenu(updatedModel);
                }
              } else if (currentState
                      is PageBuilderSectionConfigMenuOpenedState &&
                  state.content.content != null) {
                final updatedSection = widgetFinder.findSectionById(
                    state.content.content!, currentState.model.id);
                if (updatedSection != null) {
                  configMenuCubit.openSectionConfigMenu(updatedSection);
                }
              }
            }
          }
        },
        builder: (context, state) {
          if (state is GetLandingPageFailureState) {
            return ErrorView(
                title: localization
                    .landingpage_pagebuilder_container_request_error,
                message: DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                callback: () => {
                      Modular.get<PagebuilderBloc>()
                        ..add(GetLandingPageEvent(id))
                    });
          } else if (state is GetLandingPageAndUserSuccessState) {
            if (state.content.user?.id != state.content.landingPage?.ownerID) {
              return ErrorView(
                  title: localization
                      .landingpage_pagebuilder_container_permission_error_title,
                  message: localization
                      .landingpage_pagebuilder_container_permission_error_message,
                  callback: () => {
                        Modular.get<PagebuilderBloc>()
                          ..add(GetLandingPageEvent(id))
                      });
            } else {
              return Scaffold(
                    appBar: LandingPageBuilderAppBar(
                      content: state.content, 
                      isLoading: state.saveLoading,
                      isHierarchyOpen: _isHierarchyOverlayOpen,
                      onHierarchyToggle: () {
                        setState(() {
                          _isHierarchyOverlayOpen = !_isHierarchyOverlayOpen;
                        });
                      },
                    ),
                    body: Stack(
                      children: [
                        state.content.content != null
                            ? LandingPageBuilderPageBuilder(
                                model: state.content.content!,
                                configMenuCubit: pageBuilderMenuCubit,
                              )
                            : const Text("FEHLER!"),
                      // Hierarchy overlay
                      if (_isHierarchyOverlayOpen && state.content.content != null)
                        LandingPageBuilderHierarchyOverlay(
                          page: state.content.content!,
                          onClose: () {
                            setState(() {
                              _isHierarchyOverlayOpen = false;
                            });
                          },
                          onItemSelected: (widgetId, isSection) {
                            final hierarchyHelper = LandingPageBuilderHierarchyHelper(
                              page: state.content.content!,
                              configMenuCubit: pageBuilderMenuCubit,
                              selectionCubit: BlocProvider.of<PagebuilderSelectionCubit>(context),
                            );
                            hierarchyHelper.onHierarchyItemSelected(widgetId, isSection);
                          },
                        ),
                      ],
                    ),
                  );
            }
          } else {
            return const LoadingIndicator();
          }
        }),
      );
  }
}
