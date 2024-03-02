import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_bloc.dart';
import 'package:finanzbegleiter/application/authentication/user/user_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/application/profile/observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/profile/profile_bloc/profile_bloc.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:finanzbegleiter/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:finanzbegleiter/infrastructure/repositories/user_repository_implementation.dart';
import 'package:finanzbegleiter/presentation/core/modules/auth_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    i
      ..add(SignInBloc.new)
      ..add(AuthBloc.new)
      ..add(MenuBloc.new)
      ..add(UserBloc.new)
      ..add(ProfileBloc.new)
      ..add(ProfileObserverBloc.new)
      ..addLazySingleton<AuthRepository>(AuthRepositoryImplementation.new)
      ..addLazySingleton<UserRepository>(UserRepositoryImplementation.new)
      ..addLazySingleton(() => firebaseAuth)
      ..addLazySingleton(() => firestore);
  }

  @override
  void routes(r) {
    r.module("/", module: AuthModule());
  }
}
