import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/application/authentication/user/user_cubit.dart';
import 'package:finanzbegleiter/application/images/images_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile/profile_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter/promoter_cubit.dart';
import 'package:finanzbegleiter/application/promoter/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/image_repository.dart';
import 'package:finanzbegleiter/domain/repositories/promoter_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/image_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/promoter_repository_implementation.dart';
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
    final firebaseFunctions = FirebaseFunctions.instance;

    i
      ..add(SignInCubit.new)
      ..add(AuthCubit.new)
      ..add(AuthObserverBloc.new)
      ..add(MenuCubit.new)
      ..add(UserCubit.new)
      ..add(ProfileCubit.new)
      ..add(ImagesBloc.new)
      ..add(ProfileObserverBloc.new)
      ..add(PromoterCubit.new)
      ..add(PromoterObserverCubit.new)
      ..addLazySingleton<AuthRepository>(AuthRepositoryImplementation.new)
      ..addLazySingleton<UserRepository>(UserRepositoryImplementation.new)
      ..addLazySingleton<ImageRepository>(ImageRepositoryImplementation.new)
      ..addLazySingleton<PromoterRepository>(
          PromoterRepositoryImplementation.new)
      ..addLazySingleton(() => firebaseAuth)
      ..addLazySingleton(() => firestore)
      ..addLazySingleton(() => storage)
      ..addLazySingleton(() => firebaseFunctions);
  }

  @override
  void routes(r) {
    r.module("/", module: AuthModule(), guards: [UnAuthGuard()]);
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
  }
}
