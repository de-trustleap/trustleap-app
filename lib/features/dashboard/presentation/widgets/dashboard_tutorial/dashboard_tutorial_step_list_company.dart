import 'package:finanzbegleiter/features/dashboard/application/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_tutorial/dashboard_tutorial_step.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardTutorialStepListCompany extends StatelessWidget {
  final int currentStep;
  final CustomUser user;

  const DashboardTutorialStepListCompany({
    super.key,
    required this.currentStep,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardTutorialCubit>();
    final navigator = CustomNavigator.of(context);

    return Column(
      children: [
        DashboardTutorialStep(
          stepIndex: 0,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_email_verification_title,
          content:
              localization.dashboard_tutorial_step_email_verification_content,
          buttonText: localization.dashboard_tutorial_button_to_profile,
          buttonAction: () {
            navigator.navigate(RoutePaths.homePath + RoutePaths.profilePath);
            cubit.setStep(user, 1);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 1,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_contact_data_title,
          content: localization.dashboard_tutorial_step_contact_data_content,
          buttonText: localization.dashboard_tutorial_button_to_profile,
          buttonAction: () {
            navigator.navigate(RoutePaths.homePath + RoutePaths.profilePath);
            cubit.setStep(user, 2);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 2,
          currentStep: currentStep,
          title:
              localization.dashboard_tutorial_step_company_registration_title,
          content:
              localization.dashboard_tutorial_step_company_registration_content,
          buttonText: localization.dashboard_tutorial_button_to_profile,
          buttonAction: () {
            navigator.navigate(RoutePaths.homePath + RoutePaths.profilePath);
            cubit.setStep(user, 3);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 3,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_company_approval_title,
          content:
              localization.dashboard_tutorial_step_company_approval_content,
          buttonText: null,
          buttonAction: null,
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 4,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_default_landingpage_title,
          content:
              localization.dashboard_tutorial_step_default_landingpage_content,
          buttonText: localization.dashboard_tutorial_button_to_landingpages,
          buttonAction: () {
            navigator
                .navigate(RoutePaths.homePath + RoutePaths.landingPagePath);
            cubit.setStep(user, 5);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 5,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_landingpage_title,
          content: localization.dashboard_tutorial_step_landingpage_content,
          buttonText: localization.dashboard_tutorial_button_to_landingpages,
          buttonAction: () {
            navigator
                .navigate(RoutePaths.homePath + RoutePaths.landingPagePath);
            cubit.setStep(user, 6);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 6,
          currentStep: currentStep,
          title:
              localization.dashboard_tutorial_step_promoter_registration_title,
          content: localization
              .dashboard_tutorial_step_promoter_registration_content,
          buttonText: localization.dashboard_tutorial_button_register_promoter,
          buttonAction: () {
            navigator.navigate(RoutePaths.homePath +
                RoutePaths.promotersPath +
                RoutePaths.promotersRegisterPath);
            cubit.setStep(user, 7);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 7,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_promoter_waiting_title,
          content:
              localization.dashboard_tutorial_step_promoter_waiting_content,
          buttonText: null,
          buttonAction: null,
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 8,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_recommendation_title,
          content: localization.dashboard_tutorial_step_recommendation_content,
          buttonText:
              localization.dashboard_tutorial_button_make_recommendation,
          buttonAction: () {
            navigator
                .navigate(RoutePaths.homePath + RoutePaths.recommendationsPath);
            cubit.setStep(user, 9);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 9,
          currentStep: currentStep,
          title:
              localization.dashboard_tutorial_step_recommendation_manager_title,
          content: localization
              .dashboard_tutorial_step_recommendation_manager_content,
          buttonText:
              localization.dashboard_tutorial_button_to_recommendation_manager,
          buttonAction: () {
            navigator.navigate(
                RoutePaths.homePath + RoutePaths.recommendationManagerPath);
            cubit.setStep(user, 10);
          },
          isLast: false,
          user: user,
        ),
        DashboardTutorialStep(
          stepIndex: 10,
          currentStep: currentStep,
          title: localization.dashboard_tutorial_step_complete_title,
          content: localization.dashboard_tutorial_step_complete_content,
          buttonText: null,
          buttonAction: null,
          isLast: true,
          user: user,
        ),
      ],
    );
  }
}
