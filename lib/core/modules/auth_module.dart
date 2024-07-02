import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/password_forgotten_page.dart';
import 'package:finanzbegleiter/presentation/authentication/register_page.dart';
import 'package:finanzbegleiter/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/core/modules/home_module.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute,
        child: (_) => const SelectionArea(child: LoginPage()));
    r.child(RoutePaths.registerPath,
        child: (_) => const SelectionArea(child: RegisterPage()));
    r.child(RoutePaths.passwordReset,
        child: (_) => const SelectionArea(child: PasswordForgottenPage()));
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
    r.wildcard(child: (_) => const LoginPage());
  }
}
