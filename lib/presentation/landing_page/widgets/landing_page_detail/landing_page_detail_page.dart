import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_config_card.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_header.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_promoters_section.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_recommendation_chart.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_statistics.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailPage extends StatefulWidget {
  final String landingPageId;

  const LandingPageDetailPage({super.key, required this.landingPageId});

  @override
  State<LandingPageDetailPage> createState() => _LandingPageDetailPageState();
}

class _LandingPageDetailPageState extends State<LandingPageDetailPage> {
  @override
  void initState() {
    super.initState();
    final userObserverCubit = Modular.get<UserObserverCubit>();
    final currentUserState = userObserverCubit.state;
    if (currentUserState is UserObserverSuccess) {
      Modular.get<LandingPageObserverCubit>()
          .observeLandingPagesForUser(currentUserState.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final userObserverCubit = Modular.get<UserObserverCubit>();
    final landingPageObserverCubit = Modular.get<LandingPageObserverCubit>();

    return BlocListener<UserObserverCubit, UserObserverState>(
      bloc: userObserverCubit,
      listener: (context, state) {
        if (state is UserObserverSuccess) {
          landingPageObserverCubit.observeLandingPagesForUser(state.user);
        }
      },
      child: BlocBuilder<LandingPageObserverCubit, LandingPageObserverState>(
        bloc: landingPageObserverCubit,
        builder: (context, lpState) {
          if (lpState is LandingPageObserverInitial ||
              lpState is LandingPageObserverLoading) {
            return const CenteredConstrainedWrapper(
              child: Center(child: LoadingIndicator()),
            );
          }

          if (lpState is LandingPageObserverFailure) {
            return CenteredConstrainedWrapper(
              child: Center(
                child: ErrorView(
                  title: localization.landing_page_detail_error_loading,
                  message: '',
                  callback: () => navigator.navigate(
                      "${RoutePaths.homePath}${RoutePaths.landingPagePath}"),
                ),
              ),
            );
          }

          if (lpState is! LandingPageObserverSuccess) {
            return const CenteredConstrainedWrapper(
              child: Center(child: LoadingIndicator()),
            );
          }

          final landingPage = lpState.landingPages.firstWhere(
            (lp) => lp.id.value == widget.landingPageId,
            orElse: () => LandingPage(id: UniqueID.fromUniqueString("")),
          );

          if (landingPage.id.value.isEmpty) {
            return CenteredConstrainedWrapper(
              child: Center(
                child: ErrorView(
                  title: localization.landing_page_detail_not_found,
                  message: '',
                  callback: () => navigator.navigate(
                      "${RoutePaths.homePath}${RoutePaths.landingPagePath}"),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              SizedBox(height: responsiveValue.isMobile ? 40 : 80),
              CenteredConstrainedWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LandingPageDetailHeader(
                      landingPage: landingPage,
                      onPreviewPressed: () {
                        final baseURL = Environment().getLandingpageBaseURL();
                        navigator.openURLInNewTab(
                            "$baseURL?preview=true&id=${landingPage.id.value}");
                      },
                      onOpenBuilderPressed: () {
                        navigator.openInNewTab(
                            "${RoutePaths.homePath}${RoutePaths.landingPageBuilderPath}/${widget.landingPageId}");
                      },
                    ),
                    const SizedBox(height: 24),
                    LandingPageDetailStatistics(
                      visitsTotal: landingPage.visitsTotal ?? 0,
                      landingPageId: widget.landingPageId,
                      user: lpState.user,
                    ),
                    const SizedBox(height: 24),
                    LandingPageDetailRecommendationChart(
                      landingPageId: widget.landingPageId,
                      user: lpState.user,
                    ),
                    const SizedBox(height: 24),
                    LandingPageDetailConfigCard(
                      landingPage: landingPage,
                    ),
                    const SizedBox(height: 24),
                    LandingPageDetailPromotersSection(
                      landingPage: landingPage,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
                                                                                                                                                                        
// TODO: MOCKDATEN ERSTELLEN FÜR DETAIL PAGE UND TESTEN                                                                                                   
// TODO: VISITSTOTAL IN BACKEND BEFÜLLEN  