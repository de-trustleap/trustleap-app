import 'package:finanzbegleiter/application/authentication/auth/auth_bloc.dart';
import 'package:finanzbegleiter/application/menu/menu_bloc.dart';
import 'package:finanzbegleiter/approuter.dart';
import 'package:finanzbegleiter/firebase_options.dart';
import 'package:finanzbegleiter/injection.dart' as di;
import 'package:finanzbegleiter/injection.dart';
import 'package:finanzbegleiter/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_strategy/url_strategy.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = false;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                sl<AuthBloc>()..add(AuthCheckRequestedEvent())),
        BlocProvider(create: (context) => sl<MenuBloc>())
      ],
      child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is AuthStateUnAuthenticated) {
          isAuthenticated = false;
        } else if (state is AuthStateAuthenticated) {
          isAuthenticated = true;
        }
      }, builder: (BuildContext context, state) {
        return MaterialApp.router(
          routeInformationParser: const RoutemasterParser(),
          routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) =>
                  // TODO: Auf isAuthenticated muss hier gewartet werden sonst ist es am Anfang immer false. Hierfür einen Loading State in den Bloc packen und wenn Loading aktiv ist dann Inidcator anzeigen anstatt der MaterialApp.
                  AppRouter().getRoutes(isAuthenticated)),
          title: 'Finanzbegleiter',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) =>
              ResponsiveBreakpoints.builder(child: widget!, breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 999, name: TABLET),
            Breakpoint(start: 1000, end: double.infinity, name: DESKTOP)
          ]),
        );
      }),
    );
  }
}
