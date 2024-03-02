import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/repositories/auth_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: RoutePaths.loginPath);

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    final user = Modular.get<AuthRepository>().getCurrentUser();
    return user == null ? false : true;
  }
}
