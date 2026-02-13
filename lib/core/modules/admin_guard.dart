import 'dart:async';

import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminGuard extends RouteGuard {
  AdminGuard() : super(redirectTo: RoutePaths.loginPath);

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) async {
    final user = Modular.get<AuthRepository>().getCurrentUser();
    if (user != null) {
      final idTokenResult = await user.getIdTokenResult(true);
      final isAdmin = idTokenResult.claims?["admin"] == true;
      if (isAdmin) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
