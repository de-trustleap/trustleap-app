@TestOn('chrome')
library;

import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_registration_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest(PromoterRegistrationState state) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PromoterRegistrationBadge(state: state),
      ),
    );
  }

  group('PromoterRegistrationBadge Widget Tests', () {
    testWidgets('should create PromoterRegistrationBadge widget',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      expect(find.byType(PromoterRegistrationBadge), findsOneWidget);
    });

    testWidgets('should display registered text when state is registered',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      expect(find.text('Registriert'), findsOneWidget);
    });

    testWidgets('should display unregistered text when state is unregistered',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.unregistered));
      await tester.pump();

      // Then
      expect(find.text('Nicht registriert'), findsOneWidget);
    });

    testWidgets('should have primary color for registered state',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final colorScheme = Theme.of(tester.element(find.byType(Container).first))
          .colorScheme;

      expect(decoration.border, isA<Border>());
      final border = decoration.border as Border;
      expect(border.top.color, equals(colorScheme.primary));
    });

    testWidgets('should have error color for unregistered state',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.unregistered));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final colorScheme = Theme.of(tester.element(find.byType(Container).first))
          .colorScheme;

      expect(decoration.border, isA<Border>());
      final border = decoration.border as Border;
      expect(border.top.color, equals(colorScheme.error));
    });

    testWidgets('should have rounded corners', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, equals(BorderRadius.circular(8)));
    });

    testWidgets('should display text with correct font weight',
        (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      final text = tester.widget<Text>(find.text('Registriert'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should display text with font size 14', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(PromoterRegistrationState.registered));
      await tester.pump();

      // Then
      final text = tester.widget<Text>(find.text('Registriert'));
      expect(text.style?.fontSize, equals(14));
    });
  });
}
