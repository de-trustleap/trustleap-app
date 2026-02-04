import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/infrastructure/extensions/modular_watch_extension.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_config_card.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_header.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_statistics.dart';
import 'package:finanzbegleiter/presentation/landing_page/widgets/landing_page_detail/landing_page_detail_traffic_chart.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailPage extends StatefulWidget {
  final String landingPageId;

  const LandingPageDetailPage({super.key, required this.landingPageId});

  @override
  State<LandingPageDetailPage> createState() => _LandingPageDetailPageState();
}

class _LandingPageDetailPageState extends State<LandingPageDetailPage> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    final userState = context.watchModular<UserObserverCubit>().state;
    final landingPageState =
        context.watchModular<LandingPageObserverCubit>().state;

    if (userState is! UserObserverSuccess) {
      return const CenteredConstrainedWrapper(
        child: Center(child: LoadingIndicator()),
      );
    }

    final user = userState.user;

    if (landingPageState is! LandingPageObserverSuccess) {
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

    final landingPage = landingPageState.landingPages.firstWhere(
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
                user: user,
              ),
              const SizedBox(height: 24),
              LandingPageDetailTrafficChart(
                landingPageId: widget.landingPageId,
                user: user,
              ),
              const SizedBox(height: 24),
              LandingPageDetailConfigCard(
                landingPage: landingPage,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

// TODO: BUTTONS ÜBERARBEITEN (DONE)
// TODO: ES SOLLEN NUR LEGALS ANGEZEIGT WERDEN DIE EXISTIEREN. (DONE)
// TODO: LEGALS SOLLEN KLICKBAR SEIN UND OVERLAY MIT SCROLLBAREM LEGAL TEXT ANZEIGEN. (DONE)
// TODO: CHART IST NICHT SO WIE BEI DASHBOARD. DIE FILTER FEHLEN. MAN SIEHT HIER JETZT NUR VISITS. (DONE)
// TODO: PROMOTER SECTION FEHLT NOCH. HIER SOLL MAN SEHEN WELCHEN PROMOTERN DIE LANDINGPAGE ZUGEWIESEN IST.
// TODO: RESPONSIVENESS PRÜFEN
// TODO: TEXTE PRÜFEN
// TODO: LANDINGPAGE CREATOR ANPASSEN UND B2C/B2B UND CONTACT DURCH KARTEN TAUSCHEN DIE SICH WIE BUTTONS VERHALTEN
// TODO: VISITSTOTAL IN BACKEND BEFÜLLEN
