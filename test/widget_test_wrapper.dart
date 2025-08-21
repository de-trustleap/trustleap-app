import 'package:finanzbegleiter/core/custom_navigator.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class WidgetTestWrapper {
  static Widget createApp({required Widget child}) {
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
      builder: (context, child) => _TestResponsiveWrapper(
        child: child!,
      ),
      home: CustomNavigator.create(
        child: Scaffold(
          body: child,
        ),
      ),
    );
  }

  static Widget createAppWithProviders({
    required Widget child,
    required List<BlocProvider> providers,
  }) {
    return createApp(
      child: MultiBlocProvider(
        providers: providers,
        child: child,
      ),
    );
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

/// Custom InheritedWidget that intercepts ResponsiveBreakpoints.of() calls
class _MockResponsiveBreakpointsProvider extends InheritedWidget {
  const _MockResponsiveBreakpointsProvider({
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
