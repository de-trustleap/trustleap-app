import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/custom_snackbar.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/custom_alert_dialog.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/empty_page.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_overview.dart';
import 'package:finanzbegleiter/route_paths.dart';
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
      final userState = BlocProvider.of<UserObserverCubit>(context).state;
      if (userState is UserObserverSuccess) {
        currentUser = userState.user;
        Modular.get<RecommendationManagerTileCubit>()
            .initializeFavorites(userState.user.favoriteRecommendationIDs);
        Modular.get<RecommendationManagerTileCubit>()
            .setCurrentUser(userState.user);
        _requestRecommendations(userState.user);
      }
    });
  }

  void showDeleteAlert(
      AppLocalizations localizations,
      CustomNavigatorBase navigator,
      String recoID,
      String userID,
      String userRecoID) {
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
                  _submitDeleteRecommendation(recoID, userID, userRecoID),
              cancelButtonAction: () => navigator.pop());
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
              cancelButtonAction: () => navigator.pop());
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
              cancelButtonAction: () => navigator.pop());
        });
  }

  void _submitDeleteRecommendation(
      String recoID, String userID, String userRecoID) {
    CustomNavigator.of(context).pop();
    Modular.get<RecommendationManagerCubit>()
        .deleteRecommendation(recoID, userID, userRecoID);
  }

  void _submitFinishRecommendation(
      UserRecommendation recommendation, bool success) {
    CustomNavigator.of(context).pop();
    Modular.get<RecommendationManagerTileCubit>()
        .setFinished(recommendation, success);
  }

  void _requestRecommendations(CustomUser? user) {
    if (user?.role == Role.company) {
      Modular.get<RecommendationManagerCubit>()
          .getRecommendationsForCompany(user?.id.value);
    } else {
      Modular.get<RecommendationManagerCubit>()
          .getRecommendations(user?.id.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final recoManagerCubit = Modular.get<RecommendationManagerCubit>();

    return BlocConsumer<RecommendationManagerCubit, RecommendationManagerState>(
        bloc: recoManagerCubit,
        listener: (context, state) {
          if (state is RecommendationDeleteRecoSuccessState) {
            CustomSnackBar.of(context).showCustomSnackBar(
                localization.recommendation_manager_delete_snackbar);
            _requestRecommendations(currentUser);
          } else if (state is RecommendationDeleteRecoFailureState) {
            CustomSnackBar.of(context).showCustomSnackBar(
                DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                SnackBarType.failure);
            _requestRecommendations(currentUser);
          } else if (state is RecommendationGetRecosSuccessState) {
            if (state.showFavoriteSnackbar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_manager_favorite_snackbar);
            } else if (state.showPrioritySnackbar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_manager_priority_snackbar);
            } else if (state.showNotesSnackbar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_manager_notes_snackbar);
            } else if (state.showSetAppointmentSnackBar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_manager_scheduled_snackbar);
            } else if (state.showFinishedSnackBar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  localization.recommendation_manager_finished_snackbar);
            }
          }
        },
        builder: (context, state) {
          if (state is RecommendationManagerLoadingState) {
            return const LoadingIndicator();
          } else {
            return Container(
                width: double.infinity,
                decoration: BoxDecoration(color: themeData.colorScheme.surface),
                child: _createContainerChildWidget(
                    state, responsiveValue, localization, navigator));
          }
        });
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
          callback: () => {_requestRecommendations(currentUser)});
    } else if (state is RecommendationGetRecosSuccessState) {
      return ListView(children: [
        SizedBox(height: responsiveValue.isMobile ? 40 : 80),
        CenteredConstrainedWrapper(
          child: RecommendationManagerOverview(
              recommendations: state.recoItems,
              isPromoter: currentUser?.role == Role.promoter,
              favoriteRecommendationIDs: currentUser?.favoriteRecommendationIDs,
              onAppointmentPressed: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setAppointmentState(recommendation);
              },
              onFinishedPressed: (recommendation) {
                showFinishAlert(localization, navigator, recommendation);
              },
              onFailedPressed: (recommendation) {
                showFailedAlert(localization, navigator, recommendation);
              },
              onDeletePressed: (recoID, userID, userRecoID) {
                showDeleteAlert(
                    localization, navigator, recoID, userID, userRecoID);
              },
              onFavoritePressed: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setFavorite(recommendation, currentUser?.id.value ?? '');
              },
              onPriorityChanged: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setPriority(recommendation);
              },
              onUpdate: (recommendation, shouldBeDeleted, settedFavorite,
                  settedPriority, settedNotes) {
                Modular.get<RecommendationManagerCubit>().updateReco(
                    recommendation,
                    shouldBeDeleted,
                    settedFavorite,
                    settedPriority,
                    settedNotes);
              }),
        )
      ]);
    } else {
      return const LoadingIndicator();
    }
  }
}
