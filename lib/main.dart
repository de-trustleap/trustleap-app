import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/firebase_options.dart';
import 'package:finanzbegleiter/injection.dart' as di;
import 'package:finanzbegleiter/injection.dart';
import 'package:finanzbegleiter/presentation/activity_page/activity_page.dart';
import 'package:finanzbegleiter/presentation/authentication/login_page.dart';
import 'package:finanzbegleiter/presentation/authentication/register_page.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/dashboard_page.dart';
import 'package:finanzbegleiter/presentation/landing_page/landing_page.dart';
import 'package:finanzbegleiter/presentation/profile_page/profile_page.dart';
import 'package:finanzbegleiter/presentation/promoters_page/promoters_page.dart';
import 'package:finanzbegleiter/presentation/recommendations_page/recommendations_page.dart';
import 'package:finanzbegleiter/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:routemaster/routemaster.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}

final routes = RouteMap(
    onUnknownRoute: (route) {
      return const MaterialPage(child: Placeholder(color: Colors.red));
    },
    routes: {
      "/": (_) => const Redirect(RoutePaths.loginPath),
      RoutePaths.loginPath: (_) => const MaterialPage(child: LoginPage()),
      RoutePaths.registerPath: (_) => const MaterialPage(child: RegisterPage()),
      RoutePaths.dashboardPath: (_) =>
          const MaterialPage(child: DashboardPage()),
      RoutePaths.profilePath: (_) => const MaterialPage(child: ProfilePage()),
      RoutePaths.recommendationsPath: (_) =>
          const MaterialPage(child: RecommendationsPage()),
      RoutePaths.promotersPath: (_) =>
          const MaterialPage(child: PromotersPage()),
      RoutePaths.landingPagePath: (_) =>
          const MaterialPage(child: LandingPage()),
      RoutePaths.activitiesPath: (_) =>
          const MaterialPage(child: ActivityPage())
    });

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<MenuBloc>())
      ],
      child: MaterialApp.router(
        routeInformationParser: const RoutemasterParser(),
        routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
        title: 'Finanzbegleiter',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        //   home: const DashboardPage(),
        builder: (context, widget) =>
            ResponsiveBreakpoints.builder(child: widget!, breakpoints: const [
          Breakpoint(start: 0, end: 599, name: MOBILE),
          Breakpoint(start: 600, end: 999, name: TABLET),
          Breakpoint(start: 1000, end: double.infinity, name: DESKTOP)
        ]),
      ),
    );
  }
}
