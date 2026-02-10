@TestOn('chrome')
library;

import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest({
    required Function(PromotersOverviewViewState) onSelected,
    PromotersOverviewViewState currentViewState =
        PromotersOverviewViewState.grid,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PromoterOverviewViewStateButton(
          currentViewState: currentViewState,
          onSelected: onSelected,
        ),
      ),
    );
  }

  group('PromoterOverviewViewStateButton Widget Tests', () {
    testWidgets('should create PromoterOverviewViewStateButton widget',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewViewStateButton), findsOneWidget);
    });

    testWidgets('should display SegmentedButton', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      expect(find.byType(SegmentedButton<PromotersOverviewViewState>),
          findsOneWidget);
    });

    testWidgets('should display grid icon', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.grid_on), findsOneWidget);
    });

    testWidgets('should display list icon', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.format_list_bulleted), findsOneWidget);
    });

    testWidgets('should have grid selected by default', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      final segmentedButton = tester.widget<
              SegmentedButton<PromotersOverviewViewState>>(
          find.byType(SegmentedButton<PromotersOverviewViewState>));
      expect(segmentedButton.selected,
          equals({PromotersOverviewViewState.grid}));
    });

    testWidgets('should call onSelected when switching from list to grid',
        (tester) async {
      // Given
      PromotersOverviewViewState? selectedState;
      await tester.pumpWidget(createWidgetUnderTest(
        onSelected: (state) {
          selectedState = state;
        },
        currentViewState: PromotersOverviewViewState.list,
      ));
      await tester.pump();

      // When - switch to grid
      await tester.tap(find.byIcon(Icons.grid_on));
      await tester.pump();

      // Then
      expect(selectedState, equals(PromotersOverviewViewState.grid));
    });

    testWidgets('should call onSelected with list when list button is tapped',
        (tester) async {
      // Given
      PromotersOverviewViewState? selectedState;
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (state) {
        selectedState = state;
      }));
      await tester.pump();

      // When
      await tester.tap(find.byIcon(Icons.format_list_bulleted));
      await tester.pump();

      // Then
      expect(selectedState, equals(PromotersOverviewViewState.list));
    });

    testWidgets('should show list as selected when currentViewState is list',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(
        onSelected: (_) {},
        currentViewState: PromotersOverviewViewState.list,
      ));
      await tester.pump();

      // Then
      final segmentedButton = tester.widget<
              SegmentedButton<PromotersOverviewViewState>>(
          find.byType(SegmentedButton<PromotersOverviewViewState>));
      expect(segmentedButton.selected,
          equals({PromotersOverviewViewState.list}));
    });

    testWidgets('should show grid as selected when currentViewState is grid',
        (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(
        onSelected: (_) {},
        currentViewState: PromotersOverviewViewState.grid,
      ));
      await tester.pump();

      // Then
      final segmentedButton = tester.widget<
              SegmentedButton<PromotersOverviewViewState>>(
          find.byType(SegmentedButton<PromotersOverviewViewState>));
      expect(segmentedButton.selected,
          equals({PromotersOverviewViewState.grid}));
    });

    testWidgets('should not show selected icon', (tester) async {
      // When
      await tester.pumpWidget(createWidgetUnderTest(onSelected: (_) {}));
      await tester.pump();

      // Then
      final segmentedButton = tester.widget<
              SegmentedButton<PromotersOverviewViewState>>(
          find.byType(SegmentedButton<PromotersOverviewViewState>));
      expect(segmentedButton.showSelectedIcon, equals(false));
    });
  });
}
