import 'dart:async';

import 'package:finanzbegleiter/features/auth/domain/auth_repository.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LegalsGuard extends RouteGuard {
  LegalsGuard(String currentPath) 
      : super(redirectTo: '${RoutePaths.homePath}$currentPath');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final user = Modular.get<AuthRepository>().getCurrentUser();
    return user == null;
  }
}
