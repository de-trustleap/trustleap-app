import 'package:finanzbegleiter/application/dashboard/overview/dashboard_overview_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_landingpage_ranking/dashboard_landingpage_ranking.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_promoter_ranking/dashboard_promoter_ranking.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_promoters/dashboard_promoters.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_quicklink.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardOverview extends StatefulWidget {
  const DashboardOverview({super.key});

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  final largeLayoutBreakpoint = 1200;

  @override
  void initState() {
    super.initState();
    Modular.get<DashboardOverviewCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardOverviewCubit>();

    return BlocBuilder<DashboardOverviewCubit, DashboardOverviewState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is DashboardOverviewGetUserFailureState) {
          return ErrorView(
              title: localization.dashboard_user_not_found_error_title,
              message: localization.dashboard_user_not_found_error_message,
              callback: () =>
                  {Modular.get<DashboardOverviewCubit>().getUser()});
        } else if (state is DashboardOverviewGetUserSuccessState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  "${localization.dashboard_greeting} ${state.user.firstName}!",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (state.user.role == Role.promoter) ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DashboardQuicklink(
                            text: localization
                                .dashboard_quicklink_recommendation_text,
                            buttonText: localization
                                .dashboard_quicklink_recommendation_button,
                            path: RoutePaths.homePath +
                                RoutePaths.recommendationsPath,
                          ),
                          const SizedBox(width: 20),
                          DashboardQuicklink(
                            text: localization.dashboard_quicklink_manager_text,
                            buttonText:
                                localization.dashboard_quicklink_manager_button,
                            path: RoutePaths.homePath +
                                RoutePaths.recommendationManagerPath,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
              ],
              LayoutBuilder(
                builder: (context, constraints) {
                  if (state.user.role == Role.company &&
                      constraints.maxWidth >= largeLayoutBreakpoint) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child:
                                    DashboardRecommendations(user: state.user),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: DashboardPromoters(user: state.user),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child:
                                    DashboardPromoterRanking(user: state.user),
                              ),
                              const SizedBox(width: 40),
                              Expanded(
                                child: DashboardLandingpageRanking(
                                    user: state.user),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        DashboardRecommendations(user: state.user),
                        if (state.user.role == Role.company) ...[
                          const SizedBox(height: 40),
                          DashboardPromoters(user: state.user),
                          const SizedBox(height: 40),
                          DashboardPromoterRanking(user: state.user),
                          const SizedBox(height: 40),
                          DashboardLandingpageRanking(user: state.user),
                        ],
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 40)
            ],
          );
        } else {
          return const LoadingIndicator();
        }
      },
    );
  }
}
