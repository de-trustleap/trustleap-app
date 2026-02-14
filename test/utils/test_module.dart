import 'package:finanzbegleiter/features/admin/application/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/auth/application/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/features/auth/application/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/features/calendly/application/calendly_cubit.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/application/landingpage_ranking/dashboard_landingpage_ranking_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/application/promoter_ranking/dashboard_promoter_ranking_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/application/promoters/dashboard_promoters_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/application/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/features/dashboard/application/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/features/feedback/application/admin_feedback/admin_feedback_cubit.dart';
import 'package:finanzbegleiter/features/feedback/application/feedback_cubit.dart';
import 'package:finanzbegleiter/features/images/application/company/company_image_bloc.dart';
import 'package:finanzbegleiter/features/images/application/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/features/images/application/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/features/legals/application/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/features/legals/application/legals_cubit.dart';
import 'package:finanzbegleiter/features/menu/application/menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company/company_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_cubit.dart';
import 'package:finanzbegleiter/theme/theme_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/features/web_logging/application/web_logging_cubit.dart';
import 'package:finanzbegleiter/features/admin/domain/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/features/calendly/domain/calendly_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/company_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_repository.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_repository.dart';
import 'package:finanzbegleiter/features/images/domain/image_repository.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/legals/domain/legals_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/permissions/domain/permission_repository.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/tutorial_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:finanzbegleiter/features/web_logging/domain/web_logging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Test module that mirrors AppModule but uses mock repositories
/// and provides all the same cubits for testing
class TestModule extends Module {
  // Mock repositories - must be provided when creating the module
  final AuthRepository? mockAuthRepository;
  final UserRepository? mockUserRepository;
  final ImageRepository? mockImageRepository;
  final PromoterRepository? mockPromoterRepository;
  final CompanyRepository? mockCompanyRepository;
  final LandingPageRepository? mockLandingPageRepository;
  final PagebuilderRepository? mockPagebuilderRepository;
  final PermissionRepository? mockPermissionRepository;
  final AdminRegistrationCodeRepository? mockAdminRegistrationCodeRepository;
  final LegalsRepository? mockLegalsRepository;
  final RecommendationRepository? mockRecommendationRepository;
  final WebLoggingRepository? mockWebLoggingRepository;
  final FeedbackRepository? mockFeedbackRepository;
  final DashboardRepository? mockDashboardRepository;
  final TutorialRepository? mockTutorialRepository;
  final CalendlyRepository? mockCalendlyRepository;

  TestModule({
    this.mockAuthRepository,
    this.mockUserRepository,
    this.mockImageRepository,
    this.mockPromoterRepository,
    this.mockCompanyRepository,
    this.mockLandingPageRepository,
    this.mockPagebuilderRepository,
    this.mockPermissionRepository,
    this.mockAdminRegistrationCodeRepository,
    this.mockLegalsRepository,
    this.mockRecommendationRepository,
    this.mockWebLoggingRepository,
    this.mockFeedbackRepository,
    this.mockDashboardRepository,
    this.mockTutorialRepository,
    this.mockCalendlyRepository,
    this.testWidget,
  });

  @override
  void binds(i) {
    // Bind mock repositories if provided
    if (mockAuthRepository != null) {
      i.addLazySingleton<AuthRepository>(() => mockAuthRepository!);
    }
    if (mockUserRepository != null) {
      i.addLazySingleton<UserRepository>(() => mockUserRepository!);
    }
    if (mockImageRepository != null) {
      i.addLazySingleton<ImageRepository>(() => mockImageRepository!);
    }
    if (mockPromoterRepository != null) {
      i.addLazySingleton<PromoterRepository>(() => mockPromoterRepository!);
    }
    if (mockCompanyRepository != null) {
      i.addLazySingleton<CompanyRepository>(() => mockCompanyRepository!);
    }
    if (mockLandingPageRepository != null) {
      i.addLazySingleton<LandingPageRepository>(
          () => mockLandingPageRepository!);
    }
    if (mockPagebuilderRepository != null) {
      i.addLazySingleton<PagebuilderRepository>(
          () => mockPagebuilderRepository!);
    }
    if (mockPermissionRepository != null) {
      i.addLazySingleton<PermissionRepository>(() => mockPermissionRepository!);
    }
    if (mockAdminRegistrationCodeRepository != null) {
      i.addLazySingleton<AdminRegistrationCodeRepository>(
          () => mockAdminRegistrationCodeRepository!);
    }
    if (mockLegalsRepository != null) {
      i.addLazySingleton<LegalsRepository>(() => mockLegalsRepository!);
    }
    if (mockRecommendationRepository != null) {
      i.addLazySingleton<RecommendationRepository>(
          () => mockRecommendationRepository!);
    }
    if (mockWebLoggingRepository != null) {
      i.addLazySingleton<WebLoggingRepository>(() => mockWebLoggingRepository!);
    }
    if (mockFeedbackRepository != null) {
      i.addLazySingleton<FeedbackRepository>(() => mockFeedbackRepository!);
    }
    if (mockDashboardRepository != null) {
      i.addLazySingleton<DashboardRepository>(() => mockDashboardRepository!);
    }
    if (mockTutorialRepository != null) {
      i.addLazySingleton<TutorialRepository>(() => mockTutorialRepository!);
    }
    if (mockCalendlyRepository != null) {
      i.addLazySingleton<CalendlyRepository>(() => mockCalendlyRepository!);
    }

    // Bind all the cubits - same as AppModule
    i
      ..addLazySingleton(PagebuilderBloc.new)
      ..addLazySingleton(PagebuilderConfigMenuCubit.new)
      ..addLazySingleton(PermissionCubit.new)
      ..addLazySingleton(PromoterCubit.new)
      ..addLazySingleton(PromoterObserverCubit.new)
      ..addLazySingleton(LandingPageCubit.new)
      ..addLazySingleton(LandingPageObserverCubit.new)
      ..addLazySingleton(AdminRegistrationCodeCubit.new)
      ..addLazySingleton(LegalsCubit.new)
      ..addLazySingleton(ProfileCubit.new)
      ..addLazySingleton(RecommendationsCubit.new)
      ..addLazySingleton(RecommendationsAlertCubit.new)
      ..addLazySingleton(RecommendationManagerCubit.new)
      ..addLazySingleton(MenuCubit.new)
      ..addLazySingleton(RecommendationManagerTileCubit.new)
      ..addLazySingleton(RecommendationManagerArchiveCubit.new)
      ..addLazySingleton(WebLoggingCubit.new)
      ..addLazySingleton(DashboardRecommendationsCubit.new)
      ..addLazySingleton(DashboardPromotersCubit.new)
      ..addLazySingleton(FeedbackCubit.new)
      ..addLazySingleton(AdminFeedbackCubit.new)
      ..addLazySingleton(AdminLegalsCubit.new)
      ..addLazySingleton(DashboardPromoterRankingCubit.new)
      ..addLazySingleton(DashboardLandingpageRankingCubit.new)
      ..addLazySingleton(DashboardTutorialCubit.new)
      ..addLazySingleton(UserObserverCubit.new)
      ..addLazySingleton(CalendlyCubit.new)
      ..add(SignInCubit.new)
      ..add(AuthCubit.new)
      ..add(AuthObserverBloc.new)
      ..add(ThemeCubit.new)
      ..add(ProfileImageBloc.new)
      ..add(CompanyImageBloc.new)
      ..addLazySingleton(LandingPageImageBloc.new)
      ..add(CompanyObserverCubit.new)
      ..addLazySingleton(CompanyCubit.new)
      ..add(CompanyRequestCubit.new)
      ..add(CompanyRequestObserverCubit.new)
      ..addLazySingleton(PagebuilderHoverCubit.new)
      ..addLazySingleton(PagebuilderSelectionCubit.new);
  }

  final Widget? testWidget;

  @override
  void routes(r) {
    r.child('/', child: (_) => testWidget ?? Scaffold(body: Text('Test Page')));
  }
}
