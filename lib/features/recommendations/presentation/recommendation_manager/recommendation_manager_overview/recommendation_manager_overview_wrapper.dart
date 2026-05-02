import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/widgets/compensation_dialog.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_overview.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationManagerOverviewWrapper extends StatefulWidget {
  const RecommendationManagerOverviewWrapper({super.key});

  @override
  State<RecommendationManagerOverviewWrapper> createState() =>
      _RecommendationManagerPageState();
}

class _RecommendationManagerPageState
    extends State<RecommendationManagerOverviewWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  CustomUser? currentUser;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Modular.get<UserObserverCubit>().state;
      if (userState is UserObserverSuccess) {
        currentUser = userState.user;
        Modular.get<RecommendationManagerTileCubit>()
            .setCurrentUser(userState.user);
        _observeRecommendations(userState.user);
      }
    });
  }

  void showDeleteAlert(
      AppLocalizations localizations,
      CustomNavigatorBase navigator,
      UserRecommendation recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.recommendation_manager_delete_alert_title,
              message:
                  localizations.recommendation_manager_delete_alert_description,
              actionButtonTitle: localizations
                  .recommendation_manager_delete_alert_delete_button,
              cancelButtonTitle: localizations
                  .recommendation_manager_delete_alert_cancel_button,
              actionButtonAction: () =>
                  _submitDeleteRecommendation(recommendation),
              cancelButtonAction: () => navigator.pop(),
              icon: Icons.delete_outline,
              isDestructive: true);
        });
  }

  void showCampaignDeleteAlert(
      AppLocalizations localizations,
      CustomNavigatorBase navigator,
      UserRecommendation recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.campaign_manager_delete_alert_title,
              message:
                  localizations.campaign_manager_delete_alert_description,
              actionButtonTitle: localizations
                  .campaign_manager_delete_alert_delete_button,
              cancelButtonTitle: localizations
                  .recommendation_manager_delete_alert_cancel_button,
              actionButtonAction: () =>
                  _submitDeleteRecommendation(recommendation),
              cancelButtonAction: () => navigator.pop(),
              icon: Icons.delete_outline,
              isDestructive: true);
        });
  }

  void showCompensationDialog(UserRecommendation recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            child: CompensationDialog(
              recommendation: recommendation,
            ),
          );
        });
  }

  void showFinishAlert(AppLocalizations localizations,
      CustomNavigatorBase navigator, UserRecommendation recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.recommendation_manager_finish_alert_title,
              message:
                  localizations.recommendation_manager_finish_alert_message,
              actionButtonTitle: localizations
                  .recommendation_manager_finish_alert_archive_button,
              cancelButtonTitle: localizations
                  .recommendation_manager_finish_alert_cancel_button,
              actionButtonAction: () =>
                  _submitFinishRecommendation(recommendation, true),
              cancelButtonAction: () => navigator.pop(),
              icon: Icons.check_circle_outline);
        });
  }

  void showFailedAlert(AppLocalizations localizations,
      CustomNavigatorBase navigator, UserRecommendation recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: localizations.recommendation_manager_failed_alert_title,
              message:
                  localizations.recommendation_manager_failed_alert_description,
              actionButtonTitle: localizations
                  .recommendation_manager_failed_alert_archive_button,
              cancelButtonTitle: localizations
                  .recommendation_manager_failed_alert_cancel_button,
              actionButtonAction: () =>
                  _submitFinishRecommendation(recommendation, false),
              cancelButtonAction: () => navigator.pop(),
              icon: Icons.cancel_outlined,
              isDestructive: true);
        });
  }

  void _submitDeleteRecommendation(UserRecommendation recommendation) {
    CustomNavigator.of(context).pop();
    Modular.get<RecommendationManagerTileCubit>()
        .deleteRecommendation(recommendation);
  }

  void _submitFinishRecommendation(
      UserRecommendation recommendation, bool success) {
    CustomNavigator.of(context).pop();
    Modular.get<RecommendationManagerTileCubit>()
        .setFinished(recommendation, success);
  }

  void _observeRecommendations(CustomUser? user) {
    if (user == null) return;
    Modular.get<RecommendationManagerCubit>()
        .observeRecommendationsForUser(user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final recoManagerCubit = Modular.get<RecommendationManagerCubit>();
    final userObserverCubit = Modular.get<UserObserverCubit>();

    return MultiBlocListener(
        listeners: [
          BlocListener<UserObserverCubit, UserObserverState>(
              bloc: userObserverCubit,
              listener: (context, state) {
                if (state is UserObserverSuccess) {
                  final user = state.user;
                  Modular.get<RecommendationManagerTileCubit>()
                      .setCurrentUser(user);
                  final shouldReobserve = user.id != currentUser?.id ||
                      !listEquals(user.recommendationIDs,
                          currentUser?.recommendationIDs) ||
                      !listEquals(user.registeredPromoterIDs,
                          currentUser?.registeredPromoterIDs);
                  currentUser = user;
                  if (shouldReobserve) {
                    _observeRecommendations(user);
                  }
                }
              }),
          BlocListener<RecommendationManagerTileCubit,
              RecommendationManagerTileState>(
              bloc: Modular.get<RecommendationManagerTileCubit>(),
              listener: (context, state) {
                if (state is RecommendationCompensationSuccessState) {
                  if (state.status ==
                      RecommendationCompensationStatus.manualConfirmed) {
                    showFinishAlert(
                        localization, navigator, state.recommendation);
                  } else if (state.status ==
                      RecommendationCompensationStatus.skipped) {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization.compensation_success_skipped);
                  } else if (state.status ==
                      RecommendationCompensationStatus.voucherSent) {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization.compensation_voucher_sent_snackbar);
                  } else {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization.compensation_success_manual_issued);
                  }
                } else if (state is RecommendationCompensationFailureState) {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      localization.compensation_error, SnackBarType.failure);
                } else if (state is RecommendationSetStatusSuccessState) {
                  if (state.settedNotes == true) {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization.recommendation_manager_notes_snackbar);
                  } else if (state.settedPriority == true) {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization.recommendation_manager_priority_snackbar);
                  } else {
                    CustomSnackBar.of(context).showCustomSnackBar(
                        localization
                            .recommendation_manager_scheduled_snackbar);
                  }
                } else if (state is RecommendationSetFinishedSuccessState) {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      localization.recommendation_manager_finished_snackbar);
                } else if (state is RecommendationManagerTileFavoriteUpdatedState) {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      localization.recommendation_manager_favorite_snackbar);
                } else if (state is RecommendationDeleteSuccessState) {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      localization.recommendation_manager_delete_snackbar);
                } else if (state is RecommendationDeleteFailureState) {
                  CustomSnackBar.of(context).showCustomSnackBar(
                      DatabaseFailureMapper.mapFailureMessage(
                          state.failure, localization),
                      SnackBarType.failure);
                }
              }),
        ],
        child: BlocBuilder<RecommendationManagerCubit, RecommendationManagerState>(
            bloc: recoManagerCubit,
            builder: (context, state) {
              if (state is RecommendationManagerLoadingState) {
                return const LoadingIndicator();
              } else {
                return Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: themeData.colorScheme.surface),
                    child: _createContainerChildWidget(
                        state, responsiveValue, localization, navigator));
              }
            }));
  }

  Widget _createContainerChildWidget(
      RecommendationManagerState state,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localization,
      CustomNavigatorBase navigator) {
    if (state is RecommendationGetRecosNoRecosState) {
      return EmptyPage(
          icon: Icons.person_add,
          title: localization.recommendation_manager_no_data_title,
          subTitle: localization.recommendation_manager_no_data_description,
          buttonTitle: localization.recommendation_manager_no_data_button_title,
          onTap: () {
            navigator
                .navigate(RoutePaths.homePath + RoutePaths.recommendationsPath);
          });
    } else if (state is RecommendationGetRecosFailureState) {
      return ErrorView(
          title: localization.recommendation_manager_failure_text,
          message: DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization),
          callback: () => {_observeRecommendations(currentUser)});
    } else if (state is RecommendationGetRecosSuccessState) {
      return ListView(children: [
        SizedBox(height: responsiveValue.isMobile ? 16 : 80),
        CenteredConstrainedWrapper(
          child: RecommendationManagerOverview(
              recommendations: state.recoItems,
              isPromoter: currentUser?.role == Role.promoter,
              onAppointmentPressed: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setAppointmentState(recommendation);
              },
              onFinishedPressed: (recommendation) {
                if (currentUser?.role == Role.company) {
                  showCompensationDialog(recommendation);
                } else {
                  showFinishAlert(localization, navigator, recommendation);
                }
              },
              onFailedPressed: (recommendation) {
                showFailedAlert(localization, navigator, recommendation);
              },
              onDeletePressed: (recommendation) {
                showDeleteAlert(localization, navigator, recommendation);
              },
              onCampaignDeletePressed: (recommendation) {
                showCampaignDeleteAlert(
                    localization, navigator, recommendation);
              },
              onFavoritePressed: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setFavorite(recommendation, currentUser?.id.value ?? '');
              },
              onPriorityChanged: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setPriority(recommendation);
              }),
        )
      ]);
    } else {
      return const LoadingIndicator();
    }
  }
}
