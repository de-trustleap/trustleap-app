import 'package:finanzbegleiter/application/authentication/auth/auth_cubit.dart';
import 'package:finanzbegleiter/application/authentication/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_cubit.dart';
import 'package:finanzbegleiter/application/permissions/permission_cubit.dart';
import 'package:finanzbegleiter/application/profile/profile_observer/profile_observer_bloc.dart';
import 'package:finanzbegleiter/application/theme/theme_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/modules/app_module.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/firebase_options_prod.dart';
import 'package:finanzbegleiter/firebase_options_staging.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/l10n/l10n.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/themes/desktop_theme.dart';
import 'package:finanzbegleiter/themes/mobile_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Environment();
  await Firebase.initializeApp(
      options: environment.isStaging()
          ? DefaultFirebaseOptionsStaging.currentPlatform
          : DefaultFirebaseOptionsProd.currentPlatform);
  if (kIsWeb) {
    await FirebaseAppCheck.instance.activate(
        webProvider: ReCaptchaV3Provider(environment.getAppCheckToken()));
  }
  setPathUrlStrategy();
  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

void routeToInitial(AuthStatus status) {
  late String lastRoute;
  if (kIsWeb) {
    lastRoute = html.window.location.pathname ?? "/";
  } else {
    lastRoute = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  }
  switch (status) {
    case AuthStatus.unAuthenticated:
      debugPrint("NOT AUTHENTICATED");
      CustomNavigator.navigate(RoutePaths.loginPath);
      break;
    case AuthStatus.authenticated:
      debugPrint("AUTHENTICATED");
      if (lastRoute != "/" && lastRoute.contains(RoutePaths.homePath)) {
        CustomNavigator.navigate(lastRoute);
      } else {
        CustomNavigator.navigate(
            RoutePaths.homePath + RoutePaths.dashboardPath);
      }
      break;
    case AuthStatus.authenticatedAsAdmin:
      debugPrint("AUTHENTICATED AS ADMIN");
      if (lastRoute != "/" && lastRoute.contains(RoutePaths.adminPath)) {
        CustomNavigator.navigate(lastRoute);
      } else {
        Modular.to
            .navigate(RoutePaths.adminPath + RoutePaths.companyRequestsPath);
      }
      break;
  }
}

ThemeData getTheme(BuildContext context, ThemeState state) {
  if (MediaQuery.of(context).size.width < 600) {
    if (state is ThemeChanged) {
      if (state.status == ThemeStatus.light) {
        return MobileAppTheme.lightTheme;
      } else {
        return MobileAppTheme.darkTheme;
      }
    } else {
      return MobileAppTheme.lightTheme;
    }
  } else {
    if (state is ThemeChanged) {
      if (state.status == ThemeStatus.light) {
        return DesktopAppTheme.lightTheme;
      } else {
        return DesktopAppTheme.darkTheme;
      }
    } else {
      return DesktopAppTheme.lightTheme;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) {
          final authCubit = Modular.get<AuthCubit>();
          authCubit.checkForAuthState();
          return authCubit;
        }),
        BlocProvider(
            create: (context) => Modular.get<AuthObserverBloc>()
              ..add(AuthObserverStartedEvent())),
        BlocProvider(create: (context) => Modular.get<MenuCubit>()),
        BlocProvider(create: (context) => Modular.get<ThemeCubit>()),
        BlocProvider(create: (context) => Modular.get<ProfileObserverBloc>()),
        BlocProvider(create: (context) => Modular.get<PermissionCubit>())
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state is AuthStateUnAuthenticated) {
                    Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                        false;
                    routeToInitial(AuthStatus.unAuthenticated);
                  } else if (state is AuthStateAuthenticated) {
                    Modular.get<PermissionCubit>().observePermissions();
                  } else if (state is AuthStateAuthenticatedAsAdmin) {
                    Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                        false;
                    routeToInitial(AuthStatus.authenticatedAsAdmin);
                  }
                }),
            BlocListener<AuthObserverBloc, AuthObserverState>(
                listener: (context, state) {
              if (state is AuthObserverStateUnAuthenticated) {
                Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                    false;
                routeToInitial(AuthStatus.unAuthenticated);
              } else if (state is AuthObserverStateAuthenticated) {
                Modular.get<PermissionCubit>().observePermissions();
              }
            }),
            BlocListener<PermissionCubit, PermissionState>(
                listener: (context, state) {
              if (state is PermissionSuccessState &&
                  !state.permissionInitiallyLoaded) {
                routeToInitial(AuthStatus.authenticated);
              } else if (state is PermissionFailureState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Modular.get<AuthCubit>().signOut();
                });
              }
            })
          ],
          child: BlocBuilder<PermissionCubit, PermissionState>(
            builder: (context, state) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp.router(
                    routerConfig: Modular.routerConfig,
                    title: "Trust Leap",
                    theme: getTheme(context, themeState),
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
                          Breakpoint(
                              start: 1000, end: double.infinity, name: DESKTOP)
                        ]),
                  );
                },
              );
            },
          )),
    );
  }
}
