import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/features/admin/application/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/auth/application/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/features/auth/application/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/features/calendly/application/calendly_cubit.dart';
import 'package:finanzbegleiter/features/admin/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/features/consent/application/consent_cubit.dart';
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
import 'package:finanzbegleiter/features/landing_pages/application/landing_page_creator/landing_page_creator_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/features/landing_pages/application/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/features/legals/application/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/features/legals/application/legals_cubit.dart';
import 'package:finanzbegleiter/features/menu/application/menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_hierarchy_expansion/pagebuilder_hierarchy_expansion_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/features/admin/application/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_zoom/pagebuilder_zoom_cubit.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company/company_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/features/profile/application/profile/profile_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_detail/promoter_detail_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendations_cubit.dart';
import 'package:finanzbegleiter/theme/theme_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/features/web_logging/application/web_logging_cubit.dart';
import 'package:finanzbegleiter/core/modules/admin_guard.dart';
import 'package:finanzbegleiter/core/modules/admin_module.dart';
import 'package:finanzbegleiter/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/core/modules/auth_module.dart';
import 'package:finanzbegleiter/core/modules/home_module.dart';
import 'package:finanzbegleiter/features/admin/domain/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/features/calendly/domain/calendly_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/company_repository.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_repository.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_repository.dart';
import 'package:finanzbegleiter/features/images/domain/image_repository.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/legals/domain/legals_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_section_template_repository.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload_repository.dart';
import 'package:finanzbegleiter/features/permissions/domain/permission_repository.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/tutorial_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:finanzbegleiter/features/web_logging/domain/web_logging_repository.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/admin_registration_code_repository_implementation.dart';
import 'package:finanzbegleiter/features/auth/infrastructure/auth_repository_implementation.dart';
import 'package:finanzbegleiter/features/calendly/infrastructure/calendly_repository_implementation.dart';
import 'package:finanzbegleiter/features/profile/infrastructure/company_repository_implementation.dart';
import 'package:finanzbegleiter/features/consent/infrastructure/consent_repository_implementation.dart';
import 'package:finanzbegleiter/features/dashboard/infrastructure/dashboard_repository_implementation.dart';
import 'package:finanzbegleiter/features/feedback/infrastructure/feedback_repository_implementation.dart';
import 'package:finanzbegleiter/features/images/infrastructure/image_repository_implementation.dart';
import 'package:finanzbegleiter/features/landing_pages/infrastructure/landing_page_repository_implementation.dart';
import 'package:finanzbegleiter/features/legals/infrastructure/legals_repository_implementation.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/pagebuilder_repository_implementation.dart';
import 'package:finanzbegleiter/features/page_builder/infrastructure/pagebuilder_section_template_repository_implementation.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_upload_repository_implementation.dart';
import 'package:finanzbegleiter/features/permissions/infrastructure/permission_repository_implementation.dart';
import 'package:finanzbegleiter/features/promoter/infrastructure/promoter_repository_implementation.dart';
import 'package:finanzbegleiter/features/recommendations/infrastructure/recommendation_repository_implementation.dart';
import 'package:finanzbegleiter/features/dashboard/infrastructure/tutorial_repository_implementation.dart';
import 'package:finanzbegleiter/features/profile/infrastructure/user_repository_implementation.dart';
import 'package:finanzbegleiter/features/web_logging/infrastructure/web_logging_repository_implementation.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final firebaseFunctions =
        FirebaseFunctions.instanceFor(region: "europe-west3");
    final appCheck = FirebaseAppCheck.instance;

    i
      ..addLazySingleton(() => firebaseAuth)
      ..addLazySingleton(() => firestore)
      ..addLazySingleton(() => storage)
      ..addLazySingleton(() => firebaseFunctions)
      ..addLazySingleton(() => appCheck)
      ..addLazySingleton<AuthRepository>(AuthRepositoryImplementation.new)
      ..addLazySingleton<UserRepository>(UserRepositoryImplementation.new)
      ..addLazySingleton<ImageRepository>(ImageRepositoryImplementation.new)
      ..addLazySingleton<PromoterRepository>(
          PromoterRepositoryImplementation.new)
      ..addLazySingleton<CompanyRepository>(CompanyRepositoryImplementation.new)
      ..addLazySingleton<LandingPageRepository>(
          LandingPageRepositoryImplementation.new)
      ..addLazySingleton<PagebuilderRepository>(
          PageBuilderRepositoryImplementation.new)
      ..addLazySingleton<PagebuilderSectionTemplateRepository>(
          PagebuilderSectionTemplateRepositoryImplementation.new)
      ..addLazySingleton<PagebuilderSectionTemplateUploadRepository>(
          PagebuilderSectionTemplateUploadRepositoryImplementation.new)
      ..addLazySingleton<PermissionRepository>(
          PermissionRepositoryImplementation.new)
      ..addLazySingleton<AdminRegistrationCodeRepository>(
          AdminRegistrationCodeRepositoryImplementation.new)
      ..addLazySingleton<LegalsRepository>(LegalsRepositoryImplementation.new)
      ..addLazySingleton<RecommendationRepository>(
          RecommendationRepositoryImplementation.new)
      ..addLazySingleton<WebLoggingRepository>(
          WebLoggingRepositoryImplementation.new)
      ..addLazySingleton<FeedbackRepository>(
          FeedbackRepositoryImplementation.new)
      ..addLazySingleton<DashboardRepository>(
          DashboardRepositoryImplementation.new)
      ..addLazySingleton<TutorialRepository>(
          TutorialRepositoryImplementation.new)
      ..addLazySingleton<CalendlyRepository>(
          CalendlyRepositoryImplementation.new)
      ..addLazySingleton<ConsentRepository>(
          ConsentRepositoryImplementation.new)
      ..addLazySingleton(PagebuilderBloc.new)
      ..addLazySingleton(PagebuilderConfigMenuCubit.new)
      ..addLazySingleton(PagebuilderSectionTemplateCubit.new)
      ..addLazySingleton(PagebuilderSectionTemplateUploadCubit.new)
      ..addLazySingleton(PermissionCubit.new)
      ..addLazySingleton(PromoterCubit.new)
      ..addLazySingleton(PromoterDetailCubit.new)
      ..addLazySingleton(PromoterObserverCubit.new)
      ..addLazySingleton(LandingPageCubit.new)
      ..addLazySingleton(LandingPageDetailCubit.new)
      ..addLazySingleton(LandingPageObserverCubit.new)
      ..addLazySingleton(LandingPageCreatorCubit.new)
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
      ..addLazySingleton(ConsentCubit.new)
      ..addLazySingleton(PagebuilderResponsiveBreakpointCubit.new)
      ..addLazySingleton(PagebuilderZoomCubit.new)
      ..add(SignInCubit.new)
      ..add(AuthCubit.new)
      ..add(AuthObserverBloc.new)
      ..add(ThemeCubit.new)
      ..add(ProfileImageBloc.new)
      ..add(CompanyImageBloc.new)
      ..add(LandingPageImageBloc.new)
      ..add(CompanyObserverCubit.new)
      ..addLazySingleton(CompanyCubit.new)
      ..add(CompanyRequestCubit.new)
      ..add(CompanyRequestObserverCubit.new)
      ..addLazySingleton(PagebuilderHoverCubit.new)
      ..addLazySingleton(PagebuilderSelectionCubit.new)
      ..addLazySingleton(PagebuilderDragCubit.new)
      ..addLazySingleton(PagebuilderHierarchyExpansionCubit.new);
  }

  @override
  void routes(r) {
    r.module("/", module: AuthModule(), guards: [UnAuthGuard()]);
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
    r.module(RoutePaths.adminPath,
        module: AdminModule(), guards: [AdminGuard()]);
  }
}
