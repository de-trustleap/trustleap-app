import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/application/admin_registration_code/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/calendly/calendly_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/application/consent/consent_cubit.dart';
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
import 'package:finanzbegleiter/application/landingpages/landing_page_creator/landing_page_creator_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/legals/admin_legals/admin_legals_cubit.dart';
import 'package:finanzbegleiter/application/legals/legals_cubit.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_drag/pagebuilder_drag_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hierarchy_expansion/pagebuilder_hierarchy_expansion_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_hover/pagebuilder_hover_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_responsive_breakpoint/pagebuilder_responsive_breakpoint_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_section_template/pagebuilder_section_template_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder_section_template_upload/pagebuilder_section_template_upload_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_zoom/pagebuilder_zoom_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_detail/promoter_detail_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager/recommendation_manager_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_cubit.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_alert/recommendations_alert_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/application/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/application/web_logging/web_logging_cubit.dart';
import 'package:finanzbegleiter/core/modules/admin_guard.dart';
import 'package:finanzbegleiter/core/modules/admin_module.dart';
import 'package:finanzbegleiter/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/core/modules/auth_module.dart';
import 'package:finanzbegleiter/core/modules/home_module.dart';
import 'package:finanzbegleiter/domain/repositories/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/calendly_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/consent_repository.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/legals_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_upload_repository.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/tutorial_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/domain/repositories/web_logging_repository.dart';
import 'package:finanzbegleiter/infrastructure/repositories/admin_registration_code_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/calendly_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/company_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/consent_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/dashboard_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/feedback_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/image_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/landing_page_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/legals_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/pagebuilder_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/pagebuilder_section_template_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/pagebuilder_section_template_upload_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/permission_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/promoter_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/recommendation_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/tutorial_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/user_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/web_logging_repository_implementation.dart';
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
