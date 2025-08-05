import 'package:finanzbegleiter/application/dashboard/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_tutorial/dashboard_tutorial_step.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardTutorialStepListPromoter extends StatelessWidget {
  final int currentStep;
  final CustomUser user;
  final VoidCallback onUserUpdate;

  const DashboardTutorialStepListPromoter({
    super.key,
    required this.currentStep,
    required this.user,
    required this.onUserUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardTutorialCubit>();

    return Column(
      children: [
        DashboardTutorialStep(
          stepIndex: 0,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_email_verification_title,
          content:
              localization.dashboard_tutorial_step_email_verification_content,
          buttonText: localization.dashboard_tutorial_button_to_profile,
          buttonAction: () => CustomNavigator.navigate(
              RoutePaths.homePath + RoutePaths.profilePath),
          isLast: false,
          user: user,
          onUserUpdate: onUserUpdate,
        ),
        DashboardTutorialStep(
          stepIndex: 1,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_contact_data_title,
          content: localization.dashboard_tutorial_step_contact_data_content,
          buttonText: localization.dashboard_tutorial_button_to_profile,
          buttonAction: () {
            CustomNavigator.navigate(
                RoutePaths.homePath + RoutePaths.profilePath);
            cubit.setStep(user, 8); // Jump to backend step 8
          },
          isLast: false,
          user: user,
          onUserUpdate: onUserUpdate,
        ),
        DashboardTutorialStep(
          stepIndex: 2,
          currentStep: _mapCurrentStep(currentStep),
          title: localization.dashboard_tutorial_step_recommendation_title,
          content: localization.dashboard_tutorial_step_recommendation_content,
          buttonText:
              localization.dashboard_tutorial_button_make_recommendation,
          buttonAction: () => CustomNavigator.navigate(
              RoutePaths.homePath + RoutePaths.recommendationsPath),
          isLast: false,
          user: user,
          onUserUpdate: onUserUpdate,
        ),
        DashboardTutorialStep(
          stepIndex: 3,
          currentStep: _mapCurrentStep(currentStep),
          title:
              localization.dashboard_tutorial_step_recommendation_manager_title,
          content: localization
              .dashboard_tutorial_step_recommendation_manager_content,
          buttonText:
              localization.dashboard_tutorial_button_to_recommendation_manager,
          buttonAction: () {
            CustomNavigator.navigate(
                RoutePaths.homePath + RoutePaths.recommendationManagerPath);
            cubit.setStep(user, 10);
          },
          isLast: false,
          user: user,
          onUserUpdate: onUserUpdate,
        ),
        DashboardTutorialStep(
          stepIndex: 4,
          currentStep: _mapCurrentStep(currentStep),
          title: localization.dashboard_tutorial_step_complete_title,
          content: localization.dashboard_tutorial_step_complete_content,
          buttonText: null,
          buttonAction: null,
          isLast: true,
          user: user,
          onUserUpdate: onUserUpdate,
        ),
      ],
    );
  }

  int _mapCurrentStep(int backendStep) {
    switch (backendStep) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 8:
        return 2;
      case 9:
        return 3;
      case 10:
        return 4;
      default:
        return backendStep;
    }
  }
}
