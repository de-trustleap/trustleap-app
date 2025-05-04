import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
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
    Modular.get<RecommendationManagerCubit>().getUser();
  }

  void showDeleteAlert(
      AppLocalizations localizations, String recoID, String userID) {
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
                  _submitDeleteRecommendation(recoID, userID),
              cancelButtonAction: () => CustomNavigator.pop());
        });
  }

  void showFinishAlert(
      AppLocalizations localizations, RecommendationItem recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Empfehlung abschließen",
              message:
                  "Möchtest du die Empfehlung wirklich als abgeschlossen markieren?\nDie Empfehlung wird dann archiviert.",
              actionButtonTitle: "Archivieren",
              cancelButtonTitle: "Abbrechen",
              actionButtonAction: () =>
                  _submitFinishRecommendation(recommendation, true),
              cancelButtonAction: () => CustomNavigator.pop());
        });
  }

  void showFailedAlert(
      AppLocalizations localizations, RecommendationItem recommendation) {
    showDialog(
        context: context,
        builder: (_) {
          return CustomAlertDialog(
              title: "Empfehlung fehlgeschlagen?",
              message:
                  "Möchtest du die Empfehlung wirklich als fehlgeschlagen markieren?\nDie Empfehlung wird dann archiviert.",
              actionButtonTitle: "Archivieren",
              cancelButtonTitle: "Abbrechen",
              actionButtonAction: () =>
                  _submitFinishRecommendation(recommendation, false),
              cancelButtonAction: () => CustomNavigator.pop());
        });
  }

  void _submitDeleteRecommendation(String recoID, String userID) {
    CustomNavigator.pop();
    Modular.get<RecommendationManagerCubit>()
        .deleteRecommendation(recoID, userID);
  }

  void _submitFinishRecommendation(
      RecommendationItem recommendation, bool success) {
    CustomNavigator.pop();
    Modular.get<RecommendationManagerTileCubit>()
        .setFinished(recommendation, success);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    final recoManagerCubit = Modular.get<RecommendationManagerCubit>();

    return BlocConsumer<RecommendationManagerCubit, RecommendationManagerState>(
        bloc: recoManagerCubit,
        listener: (context, state) {
          if (state is RecommendationManagerGetUserSuccessState) {
            currentUser = state.user;
            Modular.get<RecommendationManagerCubit>()
                .getRecommendations(state.user.id.value);
          } else if (state is RecommendationDeleteRecoSuccessState) {
            CustomSnackBar.of(context).showCustomSnackBar(
                localization.recommendation_manager_delete_snackbar);
            Modular.get<RecommendationManagerCubit>()
                .getRecommendations(currentUser?.id.value);
          } else if (state is RecommendationDeleteRecoFailureState) {
            CustomSnackBar.of(context).showCustomSnackBar(
                DatabaseFailureMapper.mapFailureMessage(
                    state.failure, localization),
                SnackBarType.failure);
            Modular.get<RecommendationManagerCubit>()
                .getRecommendations(currentUser?.id.value);
          } else if (state is RecommendationGetRecosSuccessState) {
            if (state.showSetAppointmentSnackBar) {
              CustomSnackBar.of(context)
                  .showCustomSnackBar("Termin wurde erfolgreich gesetzt!");
            } else if (state.showFinishedSnackBar) {
              CustomSnackBar.of(context).showCustomSnackBar(
                  "Deine Empfehlung wurde ins Archiv verschoben!");
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
                    state, responsiveValue, localization));
          }
        });
  }

  Widget _createContainerChildWidget(
      RecommendationManagerState state,
      ResponsiveBreakpointsData responsiveValue,
      AppLocalizations localization) {
    if (state is RecommendationGetRecosNoRecosState) {
      return EmptyPage(
          icon: Icons.person_add,
          title: localization.recommendation_manager_no_data_title,
          subTitle: localization.recommendation_manager_no_data_description,
          buttonTitle: localization.recommendation_manager_no_data_button_title,
          onTap: () {
            CustomNavigator.navigate(
                RoutePaths.homePath + RoutePaths.recommendationsPath);
            Modular.get<MenuCubit>().selectMenu(MenuItems.recommendations);
          });
    } else if (state is RecommendationGetRecosFailureState) {
      return ErrorView(
          title: localization.recommendation_manager_failure_text,
          message: DatabaseFailureMapper.mapFailureMessage(
              state.failure, localization),
          callback: () => {
                Modular.get<RecommendationManagerCubit>()
                    .getRecommendations(currentUser?.id.value)
              });
    } else if (state is RecommendationGetRecosSuccessState) {
      return ListView(children: [
        SizedBox(height: responsiveValue.isMobile ? 40 : 80),
        CenteredConstrainedWrapper(
          child: RecommendationManagerOverview(
              recommendations: state.recoItems,
              isPromoter: currentUser?.role == Role.promoter,
              onAppointmentPressed: (recommendation) {
                Modular.get<RecommendationManagerTileCubit>()
                    .setAppointmentState(recommendation);
              },
              onFinishedPressed: (recommendation) {
                showFinishAlert(localization, recommendation);
              },
              onFailedPressed: (recommendation) {
                showFailedAlert(localization, recommendation);
              },
              onDeletePressed: (recoID, userID) {
                showDeleteAlert(localization, recoID, userID);
              },
              onUpdate: (recommendation, shouldBeDeleted) {
                Modular.get<RecommendationManagerCubit>()
                    .updateReco(recommendation, shouldBeDeleted);
              }),
        )
      ]);
    } else {
      return const LoadingIndicator();
    }
  }
}
