import 'package:finanzbegleiter/core/modules/admin_guard.dart';
import 'package:finanzbegleiter/core/modules/admin_module.dart';
import 'package:finanzbegleiter/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/core/modules/home_module.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/password_forgotten_page.dart';
import 'package:finanzbegleiter/presentation/authentication/register_page.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (_) => const LoginPage());
    r.child(RoutePaths.registerPath, child: (_) => const RegisterPage());
    r.child(RoutePaths.passwordReset,
        child: (_) => const PasswordForgottenPage());
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
    r.module(RoutePaths.adminPath,
        module: AdminModule(), guards: [AdminGuard()]);
    r.wildcard(child: (_) => const LoginPage());
  }
}
