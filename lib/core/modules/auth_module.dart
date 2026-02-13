import 'package:finanzbegleiter/core/modules/admin_guard.dart';
import 'package:finanzbegleiter/core/modules/admin_module.dart';
import 'package:finanzbegleiter/core/modules/auth_guard.dart';
import 'package:finanzbegleiter/core/modules/home_module.dart';
import 'package:finanzbegleiter/core/modules/legals_guard.dart';
import 'package:finanzbegleiter/features/auth/presentation/login_page.dart';
import 'package:finanzbegleiter/features/auth/presentation/password_forgotten_page.dart';
import 'package:finanzbegleiter/features/auth/presentation/register_page.dart';
import 'package:finanzbegleiter/features/legals/presentation/legals_page.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: (_) => const LoginPage());
    r.child(RoutePaths.registerPath,
        child: (_) => RegisterPage(
            registrationCode: r.args.queryParams["registrationCode"]));
    r.child(RoutePaths.passwordReset,
        child: (_) => const PasswordForgottenPage());
    r.child(RoutePaths.privacyPolicy,
        child: (_) => const LegalsPage(),
        guards: [LegalsGuard(RoutePaths.privacyPolicy)]);
    r.child(RoutePaths.termsAndCondition,
        child: (_) => const LegalsPage(),
        guards: [LegalsGuard(RoutePaths.termsAndCondition)]);
    r.child(RoutePaths.imprint,
        child: (_) => const LegalsPage(),
        guards: [LegalsGuard(RoutePaths.imprint)]);
    r.module(RoutePaths.homePath, module: HomeModule(), guards: [AuthGuard()]);
    r.module(RoutePaths.adminPath,
        module: AdminModule(), guards: [AdminGuard()]);
    r.wildcard(child: (_) => const LoginPage());
  }
}
