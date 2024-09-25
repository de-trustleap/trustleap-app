import 'package:finanzbegleiter/application/landingpages/pagebuilder/pagebuilder_cubit.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/navigation/navigation_cubit.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_content.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_appbar.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_html_events.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_builder/landing_page_builder_page_builder.dart';
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

  @override
  void initState() {
    super.initState();

    id = Modular.args.params["id"] ?? "";
    htmlEvents = LandingPageBuilderHtmlEvents();
    print("COLLAPSE MENU");
    BlocProvider.of<MenuCubit>(context).collapseMenu(true);
    Modular.get<PagebuilderCubit>().getLandingPage(id);
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
              actionButtonAction: () => Modular.to.pop());
        });
  }

  void _showNavigationDialog(BuildContext context, String route) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Seite verlassen?",
              message:
                  "Möchtest du die Seite wirklich verlassen?\nNicht gespeicherte Änderungen gehen verloren",
              actionButtonTitle: "Verlassen",
              actionButtonAction: () async {
                Modular.to.pop();
                await Future.delayed(const Duration(milliseconds: 100));
                Modular.to.navigate(route);
              },
              cancelButtonTitle: "Abbrechen",
              cancelButtonAction: () {
                Modular.to.pop();
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final pageBuilderCubit = Modular.get<PagebuilderCubit>();

    return MultiBlocListener(
        listeners: [
          BlocListener<PagebuilderCubit, PagebuilderState>(
              bloc: pageBuilderCubit,
              listener: (context, state) {
                if (state is GetLandingPageAndUserSuccessState) {
                  pageBuilderContent = state.content;
                  if (!state.saveLoading && state.saveFailure != null) {
                    _showSaveFailureDialog(localization);
                    htmlEvents.disableLeavePageListeners();
                    isUpdated = false;
                  } else if (!state.saveLoading &&
                      state.saveSuccessful != null) {
                    CustomSnackBar.of(context).showCustomSnackBar(localization
                        .landingpage_pagebuilder_save_success_snackbar);
                    htmlEvents.disableLeavePageListeners();
                    isUpdated = false;
                  } else if (state.isUpdated != null && state.isUpdated!) {
                    htmlEvents.enableLeavePageListeners();
                    isUpdated = true;
                  }
                }
              }),
          BlocListener<NavigationCubit, NavigationState>(
              listener: (context, state) {
            if (state is NavigationCheckState) {
              if (isUpdated) {
                _showNavigationDialog(context, state.route);
              } else {
                Modular.to.navigate(state.route);
              }
            }
          })
        ],
        child: BlocBuilder<PagebuilderCubit, PagebuilderState>(
            bloc: pageBuilderCubit,
            builder: (context, state) {
              if (state is GetLandingPageFailureState) {
                return ErrorView(
                    title: localization
                        .landingpage_pagebuilder_container_request_error,
                    message: DatabaseFailureMapper.mapFailureMessage(
                        state.failure, localization),
                    callback: () =>
                        {Modular.get<PagebuilderCubit>().getLandingPage(id)});
              } else if (state is GetLandingPageAndUserSuccessState) {
                if (state.content.user?.id !=
                    state.content.landingPage?.ownerID) {
                  return ErrorView(
                      title: localization
                          .landingpage_pagebuilder_container_permission_error_title,
                      message: localization
                          .landingpage_pagebuilder_container_permission_error_message,
                      callback: () =>
                          {Modular.get<PagebuilderCubit>().getLandingPage(id)});
                } else {
                  return Scaffold(
                      appBar: LandingPageBuilderAppBar(
                          content: state.content, isLoading: state.saveLoading),
                      body: state.content.content != null
                          ? LandingPageBuilderPageBuilder()
                              .buildPage(state.content.content!)
                          : const Text("FEHLER!"));
                }
              } else {
                return const LoadingIndicator();
              }
            }));
  }
}
