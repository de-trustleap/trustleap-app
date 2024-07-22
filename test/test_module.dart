import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/company_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/landing_page_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'mocks.mocks.dart';

class TestModule extends Module {
  @override
  void binds(Injector i) {
        i
      ..add(MockSignInCubit.new)
      ..add(MockAuthCubit.new)
      ..add(MockAuthObserverBloc.new)
      ..add(MockMenuCubit.new)
      ..add(MockThemeCubit.new)
      ..add(MockUserCubit.new)
      ..add(MockProfileCubit.new)
      ..add(MockProfileImageBloc.new)
      ..add(MockCompanyImageBloc.new)
      ..add(MockLandingPageImageBloc.new)
      ..add(MockProfileObserverBloc.new)
      ..add(MockCompanyObserverCubit.new)
      ..add(MockCompanyCubit.new)
      ..add(MockPromoterCubit.new)
      ..add(MockPromoterObserverCubit.new)
      ..add(MockRecommendationsCubit.new)
      ..add(MockLandingPageObserverCubit.new)
      ..add(MockLandingPageCubit.new)
      ..add(MockCompanyRequestCubit.new)
      ..add(MockCompanyRequestObserverCubit.new)
      ..addLazySingleton<AuthRepository>(MockAuthRepository.new)
      ..addLazySingleton<UserRepository>(MockUserRepository.new)
      ..addLazySingleton<ImageRepository>(MockImageRepository.new)
      ..addLazySingleton<PromoterRepository>(
          MockPromoterRepository.new)
      ..addLazySingleton<CompanyRepository>(MockCompanyRepository.new)
      ..addLazySingleton<LandingPageRepository>(
          MockLandingPageRepository.new)
      ..addLazySingleton<FirebaseAuth>(() => MockFirebaseAuth())
      ..addLazySingleton<FirebaseFirestore>(() => MockFirebaseFirestore())
      ..addLazySingleton<FirebaseStorage>(() => MockFirebaseStorage())
      ..addLazySingleton<FirebaseFunctions>(() => MockFirebaseFunctions());
  }

  @override
  void routes(r) {
    r.child(RoutePaths.loginPath,
        child: (_) => const LoginPage());
  }
}