import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WidgetTestWrapper {
  static Widget createTestWidget({
    required Widget child,
    List<BlocProvider>? providers,
    bool withNavigation = false,
    Module? navigationModule,
    bool withCustomNavigator = false,
  }) {
    Widget wrappedChild = child;

    // Add BlocProviders if provided
    if (providers != null && providers.isNotEmpty) {
      wrappedChild = MultiBlocProvider(
        providers: providers,
        child: wrappedChild,
      );
    }

    // Add CustomNavigator wrapper if requested (for simple tests)
    if (withCustomNavigator && !withNavigation) {
      wrappedChild = CustomNavigator.create(child: wrappedChild);
    }

    // Add navigation setup if requested
    if (withNavigation && navigationModule != null) {
      return ModularApp(
        module: navigationModule,
        child: CustomNavigator.create(
          child: MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('de'),
            ],
            builder: (context, child) => _TestResponsiveWrapper(child: child!),
            routerDelegate: Modular.routerDelegate,
            routeInformationParser: Modular.routeInformationParser,
          ),
        ),
      );
    } else {
      // Standard wrapper setup for non-navigation tests
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
        ],
        home: Scaffold(
          body: _TestResponsiveWrapper(child: wrappedChild),
        ),
      );
    }
  }
}

/// Test wrapper that provides mock ResponsiveBreakpoints with immediate correct values
class _TestResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const _TestResponsiveWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(
        size: Size(1200, 1600),
        devicePixelRatio: 1.0,
      ),
      child: ResponsiveBreakpoints.builder(
        child: child,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
      ),
    );
  }
}
