@TestOn('chrome')
library;

import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({required bool isPositive, required String label}) {
    return MaterialApp(
      home: Scaffold(
        body: StatusBadge(isPositive: isPositive, label: label),
      ),
    );
  }

  group('StatusBadge Widget Tests', () {
    testWidgets('should create StatusBadge widget', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: true, label: 'Registriert'));
      await tester.pump();

      // Then
      expect(find.byType(StatusBadge), findsOneWidget);
    });

    testWidgets('should display label text uppercased', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: true, label: 'Registriert'));
      await tester.pump();

      // Then
      expect(find.text('REGISTRIERT'), findsOneWidget);
    });

    testWidgets('should display unregistered label uppercased', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: false, label: 'Nicht registriert'));
      await tester.pump();

      // Then
      expect(find.text('NICHT REGISTRIERT'), findsOneWidget);
    });

    testWidgets('should have primary color for positive state', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: true, label: 'Registriert'));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final colorScheme =
          Theme.of(tester.element(find.byType(Container).first)).colorScheme;

      expect(decoration.color, equals(colorScheme.primary.withValues(alpha: 0.1)));
    });

    testWidgets('should have error color for negative state', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: false, label: 'Nicht registriert'));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      final colorScheme =
          Theme.of(tester.element(find.byType(Container).first)).colorScheme;

      expect(decoration.color, equals(colorScheme.error.withValues(alpha: 0.1)));
    });

    testWidgets('should have rounded corners', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: true, label: 'Registriert'));
      await tester.pump();

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
    });

    testWidgets('should display text with bold font weight', (tester) async {
      // When
      await tester.pumpWidget(
          createWidgetUnderTest(isPositive: true, label: 'Registriert'));
      await tester.pump();

      // Then
      final text = tester.widget<Text>(find.text('REGISTRIERT'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });
  });
}
