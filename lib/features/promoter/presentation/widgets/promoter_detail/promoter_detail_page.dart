import 'package:finanzbegleiter/features/dashboard/presentation/skeleton_data.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_detail/promoter_detail_cubit.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/skeleton_loading.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/page_wrapper/centered_constrained_wrapper.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_actions_card.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_chart.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_landing_pages_section.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_performance_card.dart';
import 'package:finanzbegleiter/features/promoter/presentation/widgets/promoter_detail/promoter_detail_profile_card.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class PromoterDetailPage extends StatefulWidget {
  final String promoterId;

  const PromoterDetailPage({super.key, required this.promoterId});

  @override
  State<PromoterDetailPage> createState() => _PromoterDetailPageState();
}

class _PromoterDetailPageState extends State<PromoterDetailPage> {
  @override
  void initState() {
    super.initState();
    Modular.get<PromoterDetailCubit>()
        .loadPromoterWithLandingPages(widget.promoterId);
  }

  void _loadRecommendationsIfNeeded(PromoterDetailLoaded state) {
    if (state.promoter.registered != true) return;
    if (state.recommendations != null) return;
    if (state.isRecommendationsLoading) return;
    if (state.recommendationsFailure != null) return;

    final userState = Modular.get<UserObserverCubit>().state;
    if (userState is UserObserverSuccess) {
      final user = userState.user;
      Modular.get<PromoterDetailCubit>().loadRecommendations(
        userId: user.id.value,
        role: user.role ?? Role.promoter,
      );
    }
  }

  Widget _buildContent({
    required Promoter promoter,
    required List<LandingPage> landingPages,
    required List<UserRecommendation> recommendations,
    required ThemeData themeData,
    required ResponsiveBreakpointsData responsiveValue,
    required CustomNavigatorBase navigator,
    required PromoterDetailCubit promoterDetailCubit,
  }) {
    final isRegistered = promoter.registered == true;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: themeData.colorScheme.surface),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SizedBox(height: responsiveValue.isMobile ? 40 : 80),
          CenteredConstrainedWrapper(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth >= 1450;
                return ResponsiveRowColumn(
                  layout: isWideScreen
                      ? ResponsiveRowColumnType.ROW
                      : ResponsiveRowColumnType.COLUMN,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowSpacing: 20,
                  columnSpacing: 24,
                  children: [
                    ResponsiveRowColumnItem(
                      child: SizedBox(
                        width: isWideScreen ? 360 : double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PromoterDetailProfileCard(promoter: promoter),
                            if (isRegistered) ...[
                              const SizedBox(height: 20),
                              PromoterDetailPerformanceCard(promoter: promoter),
                            ],
                            const SizedBox(height: 20),
                            PromoterDetailActionsCard(
                              promoter: promoter,
                              onDeleted: () => navigator.navigate(
                                  "${RoutePaths.homePath}${RoutePaths.promotersPath}"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 1,
                      child: Column(
                        children: [
                          if (isRegistered) ...[
                            PromoterDetailChart(promoter: promoter),
                            const SizedBox(height: 24),
                          ],
                          PromoterDetailLandingPagesSection(
                            promoter: promoter,
                            landingPages: landingPages,
                            recommendations: recommendations,
                            onChanged: () => promoterDetailCubit
                                .loadPromoterWithLandingPages(widget.promoterId),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final navigator = CustomNavigator.of(context);
    final responsiveValue = ResponsiveHelper.of(context);
    final promoterDetailCubit = Modular.get<PromoterDetailCubit>();

    return BlocConsumer<PromoterDetailCubit, PromoterDetailState>(
      bloc: promoterDetailCubit,
      listener: (context, state) {
        if (state is PromoterDetailLoaded) {
          _loadRecommendationsIfNeeded(state);
        }
      },
      builder: (context, state) {
        if (state is PromoterDetailFailure) {
          return CenteredConstrainedWrapper(
            child: Center(
              child: ErrorView(
                title: localization.promoter_detail_error_loading,
                message: '',
                callback: () => navigator.navigate(
                    "${RoutePaths.homePath}${RoutePaths.promotersPath}"),
              ),
            ),
          );
        }

        if (state is! PromoterDetailLoaded) {
          return SkeletonLoading(
            child: _buildContent(
              promoter: SkeletonData.promoter,
              landingPages: const [],
              recommendations: const [],
              themeData: themeData,
              responsiveValue: responsiveValue,
              navigator: navigator,
              promoterDetailCubit: promoterDetailCubit,
            ),
          );
        }

        return _buildContent(
          promoter: state.promoter,
          landingPages: state.landingPages,
          recommendations: state.recommendations ?? [],
          themeData: themeData,
          responsiveValue: responsiveValue,
          navigator: navigator,
          promoterDetailCubit: promoterDetailCubit,
        );
      },
    );
  }
}
