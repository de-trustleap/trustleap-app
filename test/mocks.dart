import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/features/recommendations/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/features/calendly/domain/calendly_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/company_repository.dart';
import 'package:finanzbegleiter/features/images/domain/image_repository.dart';
import 'package:finanzbegleiter/features/landing_pages/domain/landing_page_repository.dart';
import 'package:finanzbegleiter/features/legals/domain/legals_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/dashboard_repository.dart';
import 'package:finanzbegleiter/features/promoter/domain/promoter_repository.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_repository.dart';
import 'package:finanzbegleiter/features/profile/domain/user_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_repository.dart';
import 'package:finanzbegleiter/features/permissions/domain/permission_repository.dart';
import 'package:finanzbegleiter/features/admin/domain/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_repository.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload_repository.dart';
import 'package:finanzbegleiter/features/feedback/domain/feedback_repository.dart';
import 'package:finanzbegleiter/features/page_builder/domain/pagebuilder_section_template_repository.dart';
import 'package:finanzbegleiter/features/dashboard/domain/tutorial_repository.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/features/page_builder/application/pagebuilder_selection/pagebuilder_selection_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  AppLocalizations,
  AuthRepository,
  CalendlyRepository,
  CompanyRepository,
  ImageRepository,
  LandingPageRepository,
  PromoterRepository,
  UserRepository,
  PermissionRepository,
  AdminRegistrationCodeRepository,
  FeedbackRepository,
  RecommendationRepository,
  LegalsRepository,
  DashboardRepository,
  TutorialRepository,
  PagebuilderSectionTemplateRepository,
  PagebuilderSectionTemplateUploadRepository,
  ConsentRepository,
  User,
  PagebuilderRepository,
  PagebuilderConfigMenuCubit,
  PagebuilderSelectionCubit,
  RecommendationManagerTileCubit,
  BuildContext,
  FirebaseAuth,
  FirebaseFirestore,
  FirebaseStorage,
  FirebaseFunctions,
])
void main() {}
