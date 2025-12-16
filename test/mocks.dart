import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/application/recommendation_manager/recommendation_manager_tile/recommendation_manager_tile_cubit.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/calendly_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/legals_repository.dart';
import 'package:finanzbegleiter/domain/repositories/dashboard_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendation_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:finanzbegleiter/domain/repositories/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/domain/repositories/feedback_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_repository.dart';
import 'package:finanzbegleiter/domain/repositories/tutorial_repository.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_bloc.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_config_menu/pagebuilder_config_menu_cubit.dart';
import 'package:finanzbegleiter/application/pagebuilder/pagebuilder_selection/pagebuilder_selection_cubit.dart';
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
