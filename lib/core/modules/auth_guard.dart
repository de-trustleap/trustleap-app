import 'dart:async';

import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: RoutePaths.loginPath);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final user = Modular.get<AuthRepository>().getCurrentUser();
    return user == null ? false : true;
  }
}

class UnAuthGuard extends RouteGuard {
  UnAuthGuard()
      : super(redirectTo: RoutePaths.homePath + RoutePaths.dashboardPath);

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    final user = Modular.get<AuthRepository>().getCurrentUser();
    return user == null ? true : false;
  }
}
