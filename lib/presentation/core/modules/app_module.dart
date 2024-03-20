import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/images/images_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/recommendations/recommendations_cubit.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/recommendations_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/image_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/unrecommendations_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/user_repository_implementation.dart';
import 'package:finanzbegleiter/presentation/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/presentation/core/modules/auth_module.dart';
import 'package:finanzbegleiter/presentation/core/modules/home_module.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    i
      ..add(SignInCubit.new)
      ..add(AuthCubit.new)
      ..add(AuthObserverBloc.new)
      ..add(MenuCubit.new)
      ..add(UserCubit.new)
      ..add(ProfileCubit.new)
      ..add(ImagesBloc.new)
      ..add(ProfileObserverBloc.new)
      ..add(RecommendationsCubit.new)
      ..addLazySingleton<AuthRepository>(AuthRepositoryImplementation.new)
      ..addLazySingleton<UserRepository>(UserRepositoryImplementation.new)
      ..addLazySingleton<ImageRepository>(ImageRepositoryImplementation.new)
      ..addLazySingleton<RecommendationsRepository>(
          RecommendationsRepositoryImplementation.new)
      ..addLazySingleton(() => firebaseAuth)
      ..addLazySingleton(() => firestore)
      ..addLazySingleton(() => storage);
  }

  @override
  void routes(r) {
    r.module("/", module: AuthModule(), guards: [UnAuthGuard()]);
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
  }
}
