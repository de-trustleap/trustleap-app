import 'package:finanzbegleiter/application/authentication/auth_bloc.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/infrastructure/repositories/auth_repository_implementation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! State Management
  sl.registerFactory(() => AuthBloc(authRepo: sl()));

  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImplementation(firebaseAuth: sl()));

  //! Extern
  final firebaseAuth = FirebaseAuth.instance;
  sl.registerLazySingleton(() => firebaseAuth);
}
