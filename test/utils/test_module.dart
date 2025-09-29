import 'package:finanzbegleiter/application/admin_registration_code/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/application/dashboard/landingpage_ranking/dashboard_landingpage_ranking_cubit.dart';
import 'package:finanzbegleiter/application/dashboard/promoter_ranking/dashboard_promoter_ranking_cubit.dart';
import 'package:finanzbegleiter/application/dashboard/promoters/dashboard_promoters_cubit.dart';
import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/application/dashboard/tutorial/dashboard_tutorial_cubit.dart';
import 'package:finanzbegleiter/application/feedback/admin_feedback/admin_feedback_cubit.dart';
import 'package:finanzbegleiter/application/feedback/feedback_cubit.dart';
import 'package:finanzbegleiter/application/images/company/company_image_bloc.dart';
import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/legals/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/application/legals/legals_cubit.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/application/web_logging/web_logging_cubit.dart';
import 'package:finanzbegleiter/domain/repositories/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/calendly_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/legals_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/tutorial_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/domain/repositories/web_logging_repository.dart';
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
      i.addLazySingleton<LandingPageRepository>(() => mockLandingPageRepository!);
    }
    if (mockPagebuilderRepository != null) {
      i.addLazySingleton<PagebuilderRepository>(() => mockPagebuilderRepository!);
    }
    if (mockPermissionRepository != null) {
      i.addLazySingleton<PermissionRepository>(() => mockPermissionRepository!);
    }
    if (mockAdminRegistrationCodeRepository != null) {
      i.addLazySingleton<AdminRegistrationCodeRepository>(() => mockAdminRegistrationCodeRepository!);
    }
    if (mockLegalsRepository != null) {
      i.addLazySingleton<LegalsRepository>(() => mockLegalsRepository!);
    }
    if (mockRecommendationRepository != null) {
      i.addLazySingleton<RecommendationRepository>(() => mockRecommendationRepository!);
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
      ..add(LandingPageImageBloc.new)
      ..add(CompanyObserverCubit.new)
      ..add(CompanyCubit.new)
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