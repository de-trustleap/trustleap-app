import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/firebase_options.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/l10n/l10n.dart';
import 'package:finanzbegleiter/presentation/core/modules/app_module.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => Modular.get<AuthBloc>()
              ..add(AuthCheckRequestedEvent())
              ..add(AuthObserverEvent())),
        BlocProvider(create: (context) => Modular.get<MenuBloc>())
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            final lastRoute =
                WidgetsBinding.instance.platformDispatcher.defaultRouteName;
            if (state is AuthStateUnAuthenticated) {
              print("NOT AUTHENTICATED");
              Modular.to.navigate(RoutePaths.loginPath);
            } else if (state is AuthStateAuthenticated) {
              print("AUTHENTICATED");
              if (lastRoute != "/" && lastRoute.contains(RoutePaths.homePath)) {
                Modular.to.navigate(lastRoute);
              } else {
                Modular.to
                    .navigate(RoutePaths.homePath + RoutePaths.dashboardPath);
              }
            }
          },
          builder: (BuildContext context, state) {
            Modular.to.addListener(() {
              print('Navigate: ${Modular.to.path}');
              print(
                  'History: ${Modular.to.navigateHistory.map((e) => e.name)}');
            });
            return MaterialApp.router(
              routerConfig: Modular.routerConfig,
              title: 'Finanzbegleiter',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.light,
              supportedLocales: L10n.all,
              locale: const Locale("de"),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              debugShowCheckedModeBanner: false,
              builder: (context, widget) => ResponsiveBreakpoints.builder(
                  child: widget!,
                  breakpoints: const [
                    Breakpoint(start: 0, end: 599, name: MOBILE),
                    Breakpoint(start: 600, end: 999, name: TABLET),
                    Breakpoint(start: 1000, end: double.infinity, name: DESKTOP)
                  ]),
            );
          }),
    );
  }
}
