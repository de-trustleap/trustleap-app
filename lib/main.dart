import 'package:finanzbegleiter/features/auth/application/auth/auth_cubit.dart';
import 'package:finanzbegleiter/features/auth/application/auth_observer/auth_observer_bloc.dart';
import 'package:finanzbegleiter/features/menu/application/menu_cubit.dart';
import 'package:finanzbegleiter/features/permissions/application/permission_cubit.dart';
import 'package:finanzbegleiter/features/promoter/application/promoter_observer/promoter_observer_cubit.dart';
import 'package:finanzbegleiter/theme/theme_cubit.dart';
import 'package:finanzbegleiter/features/user_observer/user_observer_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/core/helpers/stored_consent_reader.dart';
import 'package:finanzbegleiter/core/modules/app_module.dart';
import 'package:finanzbegleiter/core/navigation/custom_navigator_base.dart';
import 'package:finanzbegleiter/core/router_observer.dart';
import 'package:finanzbegleiter/core/web_crash_reporter.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/firebase_options_prod.dart';
import 'package:finanzbegleiter/firebase_options_staging.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/l10n/l10n.dart';
import 'package:finanzbegleiter/features/consent/presentation/consent_banner_wrapper.dart';
import 'package:finanzbegleiter/route_paths.dart';
import 'package:finanzbegleiter/theme/desktop_theme.dart';
import 'package:finanzbegleiter/theme/mobile_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:finanzbegleiter/core/sentry_initialization.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:web/web.dart' as web;

Future<void> main() async {
  final hasStatisticsConsent = StoredConsentReader.hasStatisticsConsent();

  if (hasStatisticsConsent) {
    // Initialize with Sentry if consent is given
    await SentryInitialization.init(
      appRunner: () => _runApp(hasStatisticsConsent),
    );
  } else {
    await _runApp(hasStatisticsConsent);
  }
}

Future<void> _runApp(bool hasStatisticsConsent) async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = Environment();

  await Firebase.initializeApp(
    options: environment.isStaging()
        ? DefaultFirebaseOptionsStaging.currentPlatform
        : DefaultFirebaseOptionsProd.currentPlatform,
  );

  if (kIsWeb) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(environment.getAppCheckToken()),
    );
  }

  setPathUrlStrategy();

  final observer = RouterObserver();
  Modular.to.setObservers([observer]);

  Modular.to.addListener(() {
    observer.handleNavigation();
  });

  runApp(
    ModularApp(
      module: AppModule(),
      child: hasStatisticsConsent
          ? SentryWidget(
              child: CustomNavigator.create(
                child: const MyApp(),
              ),
            )
          : CustomNavigator.create(
              child: const MyApp(),
            ),
    ),
  );

  if (kIsWeb) {
    WebCrashReporter.initialize();
  }
}

void routeToInitial(AuthStatus status, CustomNavigatorBase navigator) {
  late String lastRoute;
  WebCrashReporter.report("App started", null, LogLevel.info);
  if (kIsWeb) {
    String path = web.window.location.pathname;
    String query = web.window.location.search;

    lastRoute = path + query;
  } else {
    lastRoute = WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  }
  switch (status) {
    case AuthStatus.unAuthenticated:
      debugPrint("NOT AUTHENTICATED");
      if (lastRoute.contains(RoutePaths.homePath) ||
          lastRoute.contains(RoutePaths.adminPath)) {
        navigator.navigate(RoutePaths.loginPath);
      } else {
        navigator.navigate(lastRoute);
      }
      break;
    case AuthStatus.authenticated:
      debugPrint("AUTHENTICATED");
      if (lastRoute != "/" && lastRoute.contains(RoutePaths.homePath)) {
        navigator.navigate(lastRoute);
      } else {
        navigator.navigate(RoutePaths.homePath + RoutePaths.dashboardPath);
      }
      break;
    case AuthStatus.authenticatedAsAdmin:
      debugPrint("AUTHENTICATED AS ADMIN");
      if (lastRoute != "/" && lastRoute.contains(RoutePaths.adminPath)) {
        navigator.navigate(lastRoute);
      } else {
        navigator
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
    final navigator = CustomNavigator.of(context);
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
        BlocProvider(create: (context) => Modular.get<PromoterObserverCubit>()),
        BlocProvider(create: (context) => Modular.get<PermissionCubit>()),
        BlocProvider(create: (context) => Modular.get<UserObserverCubit>())
      ],
      child: MultiBlocListener(
          listeners: [
            BlocListener<AuthCubit, AuthState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  if (state is AuthStateUnAuthenticated) {
                    Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                        false;
                    routeToInitial(AuthStatus.unAuthenticated, navigator);
                  } else if (state is AuthStateAuthenticated) {
                    Modular.get<PermissionCubit>().observePermissions();
                    Modular.get<UserObserverCubit>().observeUser();
                  } else if (state is AuthStateAuthenticatedAsAdmin) {
                    Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                        false;
                    routeToInitial(AuthStatus.authenticatedAsAdmin, navigator);
                  }
                }),
            BlocListener<AuthObserverBloc, AuthObserverState>(
                listener: (context, state) {
              if (state is AuthObserverStateUnAuthenticated) {
                Modular.get<PermissionCubit>().permissionInitiallyLoaded =
                    false;
                routeToInitial(AuthStatus.unAuthenticated, navigator);
              } else if (state is AuthObserverStateAuthenticated) {
                Modular.get<PermissionCubit>().observePermissions();
                Modular.get<UserObserverCubit>().observeUser();
              }
            }),
            BlocListener<PermissionCubit, PermissionState>(
                listener: (context, state) {
              if (state is PermissionSuccessState &&
                  !state.permissionInitiallyLoaded) {
                routeToInitial(AuthStatus.authenticated, navigator);
              } else if (state is PermissionFailureState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Modular.get<AuthCubit>().signOut();
                });
              }
            })
          ],
          child: BlocBuilder<PermissionCubit, PermissionState>(
            builder: (context, state) {
              return BlocBuilder<UserObserverCubit, UserObserverState>(
                builder: (context, userState) {
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
                        builder: (context, widget) {
                          return ResponsiveBreakpoints.builder(
                            child: ConsentBannerWrapper(child: widget!),
                            breakpoints: const [
                              Breakpoint(start: 0, end: 599, name: MOBILE),
                              Breakpoint(start: 600, end: 999, name: TABLET),
                              Breakpoint(
                                  start: 1000,
                                  end: double.infinity,
                                  name: DESKTOP)
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          )),
    );
  }
}
