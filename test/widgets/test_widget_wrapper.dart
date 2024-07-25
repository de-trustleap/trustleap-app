import 'package:bloc_test/bloc_test.dart';
import 'package:finanzbegleiter/application/authentication/signIn/sign_in_cubit.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:mocktail/mocktail.dart';

import '../app_localization_widget_mock.dart';
import '../test_module.dart';

class MockAppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const MockAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return WidgetMockAppLocalization();
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

class TestWidgetWrapper extends StatelessWidget {
  final Widget child;
  const TestWidgetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ModularApp(
      module: TestModule(),
      child: MaterialApp(
        localizationsDelegates: const [
          MockAppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('de', '')],
        theme: ThemeData.light(),
        builder: (context, widget) => ResponsiveBreakpoints.builder(
          child: widget!,
          breakpoints: const [
            Breakpoint(start: 0, end: 599, name: MOBILE),
            Breakpoint(start: 600, end: 999, name: TABLET),
            Breakpoint(start: 1000, end: double.infinity, name: DESKTOP),
          ],
        ),
        home: Scaffold(body: child),
      ),
    );
  }
}
