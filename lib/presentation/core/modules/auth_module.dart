import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/register_page.dart';
import 'package:finanzbegleiter/presentation/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/presentation/core/modules/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (_) => const LoginPage());
    r.child(RoutePaths.registerPath, child: (_) => const RegisterPage());
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
    r.wildcard(child: (_) => const LoginPage());
  }
}
