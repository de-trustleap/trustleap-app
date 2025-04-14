import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/clickable_link.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_overview/landing_page_overview_grid.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LandingPageOverview extends StatefulWidget {
  const LandingPageOverview({super.key});

  @override
  State<LandingPageOverview> createState() => _LandingPageOverviewState();
}

class _LandingPageOverviewState extends State<LandingPageOverview> {
  @override
  void initState() {
    super.initState();
    Modular.get<LandingPageObserverCubit>().observeAllLandingPages();
  }

  void submitDeletion(String id, String parentUserID) {
    CustomNavigator.pop();
    Modular.get<LandingPageCubit>().deleteLandingPage(id, parentUserID);
  }

  void submitDuplication(String id) {
    Modular.get<LandingPageCubit>().duplicateLandingPage(id);
  }

  void submitIsActive(String id, bool isActive, String userId) {
    Modular.get<LandingPageCubit>()
        .toggleLandingPageActivity(id, isActive, userId);
  }

  bool showEmptyPage(List<LandingPage> landingPages, CustomUser user) {
    if (landingPages.isNotEmpty) {
      final isOnlyDefault =
          landingPages.length == 1 && (landingPages[0].isDefaultPage ?? false);
      if (isOnlyDefault) {
        return user.role == Role.company ? false : true;
      } else {
        return false;
      }
    } else {
      return user.role == Role.company ? false : true;
    }
  }

  bool showCreateDefaultPage(List<LandingPage> landingPages, CustomUser user) {
    if (landingPages.isEmpty) {
      return user.role == Role.company ? true : false;
    } else {
      final containsDefaultPage =
          landingPages.any((page) => page.isDefaultPage == true);
      if (!containsDefaultPage) {
        return user.role == Role.company ? true : false;
      } else {
        return false;
      }
    }
  }

  List<ClickableLink> _getPromoterLink(List<Promoter> promoters) {
    List<ClickableLink> links = [];
    for (Promoter promoter in promoters) {
      links.add(ClickableLink(
          title: "${promoter.firstName ?? ""} ${promoter.lastName ?? ""}",
          onTap: () {
            CustomNavigator.pop();
            CustomNavigator.navigate(
                "${RoutePaths.homePath}${RoutePaths.editPromoterPath}/${promoter.id.value}");
          }));
    }
    return links;
  }

  void showDeleteAlertWithPromoterCheck(
      String id,
      String parentUserID,
      List<String> associatedUsersIDs,
      AppLocalizations localization,
      ThemeData themeData) {
    final landingPageCubit = Modular.get<LandingPageCubit>();

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<LandingPageCubit, LandingPageState>(
          bloc: landingPageCubit,
          builder: (context, state) {
            if (state is GetPromotersLoadingState) {
              return CustomAlertDialog(
                title: "",
                message: "",
                isLoading: true,
                actionButtonTitle: localization.cancel_buttontitle,
                actionButtonAction: () => CustomNavigator.pop(),
              );
            } else if (state is GetPromotersSuccessState) {
              if (state.promoters.isEmpty) {
                return CustomAlertDialog(
                  title: localization.landingpage_delete_alert_title,
                  message: localization.landingpage_delete_alert_msg,
                  actionButtonTitle: localization.delete_buttontitle,
                  cancelButtonTitle: localization.cancel_buttontitle,
                  actionButtonAction: () => submitDeletion(id, parentUserID),
                  cancelButtonAction: () => CustomNavigator.pop(),
                );
              } else {
                return CustomAlertDialog(
                  title: localization.landingpage_delete_alert_title,
                  messageWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            localization
                                .landingpage_delete_alert_msg_promoter_warning,
                            style: themeData.textTheme.bodyMedium),
                        ..._getPromoterLink(state.promoters),
                        Text(
                            localization
                                .landingpage_delete_alert_msg_promoter_warning_continue,
                            style: themeData.textTheme.bodyMedium)
                      ]),
                  message: "",
                  actionButtonTitle: localization.delete_buttontitle,
                  cancelButtonTitle: localization.cancel_buttontitle,
                  actionButtonAction: () => submitDeletion(id, parentUserID),
                  cancelButtonAction: () => CustomNavigator.pop(),
                );
              }
            } else {
              return CustomAlertDialog(
                title: localization.landingpage_delete_alert_title,
                message: localization.landingpage_delete_alert_msg,
                actionButtonTitle: localization.delete_buttontitle,
                cancelButtonTitle: localization.cancel_buttontitle,
                actionButtonAction: () => submitDeletion(id, parentUserID),
                cancelButtonAction: () => CustomNavigator.pop(),
              );
            }
          },
        );
      },
    );

    landingPageCubit.getPromoters(associatedUsersIDs, id);
  }

  @override
  Widget build(BuildContext context) {
    final landingPageCubit = Modular.get<LandingPageCubit>();
    final landingPageObserverCubit = Modular.get<LandingPageObserverCubit>();
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return BlocConsumer<LandingPageCubit, LandingPageState>(
      bloc: landingPageCubit,
      listener: (context, state) {
        if (state is DeleteLandingPageSuccessState) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.landingpage_success_delete_snackbar_message);
        } else if (state is DuplicateLandingPageSuccessState) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.landingpage_snackbar_success_duplicated);
        } else if (state is ToggleLandingPageActivitySuccessState) {
          CustomSnackBar.of(context).showCustomSnackBar(state.isActive == true
              ? localization.landingpage_snackbar_success_toggled_enabled
              : localization.landingpage_snackbar_success_toggled_disabled);
        } else if (state is ToggleLandingPageActivityFailureState) {
          CustomSnackBar.of(context).showCustomSnackBar(
              localization.landingpage_snackbar_failure_toggled,
              SnackBarType.failure);
        }
      },
      builder: (context, state) {
        return BlocBuilder<LandingPageObserverCubit, LandingPageObserverState>(
          bloc: landingPageObserverCubit,
          builder: (context, observerState) {
            if (state is DeleteLandingPageLoadingState ||
                state is DuplicateLandingPageLoadingState ||
                state is ToggleLandingPageActivityLoadingState) {
              return const LoadingIndicator();
            } else if (observerState is LandingPageObserverSuccess) {
              if (showEmptyPage(
                  observerState.landingPages, observerState.user)) {
                return EmptyPage(
                    icon: Icons.note_add,
                    title: localization.landingpage_overview_empty_page_title,
                    subTitle:
                        localization.landingpage_overview_empty_page_subtitle,
                    buttonTitle: localization.landingpage_create_buttontitle,
                    onTap: () {
                      CustomNavigator.navigate(RoutePaths.homePath +
                          RoutePaths.landingPageCreatorPath);
                    });
              } else if (showCreateDefaultPage(
                  observerState.landingPages, observerState.user)) {
                return EmptyPage(
                    icon: Icons.note_add,
                    title:
                        localization.landingpage_overview_no_default_page_title,
                    subTitle: localization
                        .landingpage_overview_no_default_page_subtitle,
                    buttonTitle: localization
                        .landingpage_overview_no_default_page_button_title,
                    onTap: () {
                      CustomNavigator.pushNamed(
                          "${RoutePaths.homePath}${RoutePaths.landingPageCreatorPath}",
                          arguments: {
                            "landingPage": null,
                            "createDefaultPage": true,
                          });
                    });
              } else {
                return CardContainer(
                    maxWidth: 1200,
                    child: Column(
                      children: [
                        SelectableText(localization.landingpage_overview_title,
                            style: themeData.textTheme.headlineLarge!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        LandingPageOverviewGrid(
                            landingpages: observerState.landingPages,
                            user: observerState.user,
                            deletePressed: (landingPageID, parentUserID,
                                    associatedUsersIDs) =>
                                showDeleteAlertWithPromoterCheck(
                                    landingPageID,
                                    parentUserID,
                                    associatedUsersIDs,
                                    localization,
                                    themeData),
                            duplicatePressed: (landinPageID) =>
                                submitDuplication(landinPageID),
                            isActivePressed:
                                (landinPageID, landingPageIsActive) =>
                                    submitIsActive(
                                        landinPageID,
                                        landingPageIsActive,
                                        observerState.user.id.value))
                      ],
                    ));
              }
            } else if (observerState is LandingPageObserverFailure) {
              return ErrorView(
                  title: localization.landingpage_overview_error_view_title,
                  message: DatabaseFailureMapper.mapFailureMessage(
                      observerState.failure, localization),
                  callback: () => {
                        Modular.get<LandingPageObserverCubit>()
                            .observeAllLandingPages()
                      });
            } else {
              return const LoadingIndicator();
            }
          },
        );
      },
    );
  }
}
