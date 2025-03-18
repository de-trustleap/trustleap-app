import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request/company_request_cubit.dart';
import 'package:finanzbegleiter/application/company_request/company_request_observer/company_request_observer_cubit.dart';
import 'package:finanzbegleiter/application/images/company/company_image_bloc.dart';
import 'package:finanzbegleiter/application/images/landing_page/landing_page_image_bloc.dart';
import 'package:finanzbegleiter/application/images/profile/profile_image_bloc.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage/landingpage_cubit.dart';
import 'package:finanzbegleiter/application/landingpages/landingpage_observer/landingpage_observer_cubit.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/company/company_cubit.dart';
import 'package:finanzbegleiter/application/profile/company_observer/company_observer_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile_observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_repository.dart';
import 'package:finanzbegleiter/domain/repositories/permission_repository.dart';
import 'package:finanzbegleiter/domain/repositories/admin_registration_code_repository.dart';
import 'package:finanzbegleiter/application/admin_registration_code/admin_registration_code_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  AppLocalizations,
  AuthRepository,
  CompanyRepository,
  ImageRepository,
  LandingPageRepository,
  PromoterRepository,
  UserRepository,
  PermissionRepository,
  AdminRegistrationCodeRepository,
  User,
  SignInCubit,
  AuthCubit,
  AuthObserverBloc,
  MenuCubit,
  ThemeCubit,
  UserCubit,
  ProfileCubit,
  ProfileImageBloc,
  CompanyImageBloc,
  LandingPageImageBloc,
  ProfileObserverBloc,
  CompanyObserverCubit,
  PermissionCubit,
  CompanyCubit,
  PromoterCubit,
  PromoterObserverCubit,
  RecommendationsCubit,
  LandingPageObserverCubit,
  LandingPageCubit,
  PagebuilderRepository,
  CompanyRequestCubit,
  CompanyRequestObserverCubit,
  AdminRegistrationCodeCubit,
  FirebaseAuth,
  FirebaseFirestore,
  FirebaseStorage,
  FirebaseFunctions
])
void main() {}
