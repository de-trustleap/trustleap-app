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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! State Management
  sl.registerFactory(() => SignInBloc(authRepo: sl()));
  sl.registerFactory(() => AuthBloc(authRepo: sl()));
  sl.registerFactory(() => MenuBloc());
  sl.registerFactory(() => UserBloc(userRepo: sl()));
  sl.registerFactory(() => ProfileBloc(userRepo: sl(), authRepo: sl()));
  sl.registerFactory(() => ProfileObserverBloc(userRepo: sl()));

  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation(firebaseAuth: sl()));
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImplementation(firestore: sl(), firebaseAuth: sl()));

  //! Extern
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);

  final firestore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => firestore);
}
