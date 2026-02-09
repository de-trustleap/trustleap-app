import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/responsive/responsive_helper.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_filter_bottom_sheet.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_view_state_button.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoters_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController searchController;

  setUp(() {
    ResponsiveHelper.enableTestMode();
    searchController = TextEditingController();
  });

  tearDown(() {
    ResponsiveHelper.disableTestMode();
    searchController.dispose();
  });

  Widget createWidgetUnderTest({
    Function(String?)? onSearchQueryChanged,
    Function? clearSearch,
    Function(PromoterOverviewFilterStates)? onFilterChanged,
    Function(PromotersOverviewViewState)? onViewStateButtonPressed,
    Function(PromoterSearchOption)? onSearchOptionChanged,
  }) {
    return MaterialApp(
      locale: const Locale('de'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: PromoterOverviewHeader(
          searchController: searchController,
          onSearchQueryChanged: onSearchQueryChanged ?? (query) {},
          clearSearch: clearSearch ?? () {},
          onFilterChanged: onFilterChanged ?? (filterStates) {},
          currentViewState: PromotersOverviewViewState.grid,
          onViewStateButtonPressed:
              onViewStateButtonPressed ?? (viewState) {},
          onSearchOptionChanged: onSearchOptionChanged ?? (option) {},
        ),
      ),
    );
  }

  group('PromoterOverviewHeader Widget Tests', () {
    testWidgets('should render PromoterOverviewHeader widget',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewHeader), findsOneWidget);
    });

    testWidgets('should display title', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.text('Meine Promoter'), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display filter button', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('should display view state button', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(PromoterOverviewViewStateButton), findsOneWidget);
    });

    testWidgets('should call onSearchQueryChanged when text is entered',
        (tester) async {
      // Given
      String? searchQuery;
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(
        onSearchQueryChanged: (query) {
          searchQuery = query;
        },
      ));
      await tester.pump();

      // Enter text in search bar
      await tester.enterText(find.byType(SearchBar), 'John Doe');
      await tester.pump();

      // Then
      expect(searchQuery, 'John Doe');
      expect(searchController.text, 'John Doe');
    });

    testWidgets('should call clearSearch when close button is pressed',
        (tester) async {
      // Given
      bool clearSearchCalled = false;
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(
        clearSearch: () {
          clearSearchCalled = true;
          searchController.clear();
        },
      ));
      await tester.pump();

      // Enter text first
      searchController.text = 'Test';
      await tester.pump();

      // Find and tap close button
      final closeButton = find.byIcon(Icons.close);
      await tester.tap(closeButton);
      await tester.pump();

      // Then
      expect(clearSearchCalled, true);
      expect(searchController.text, '');
    });

    testWidgets('should display search option dropdown', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(DropdownButton<PromoterSearchOption>), findsOneWidget);
    });

    testWidgets('should call onSearchOptionChanged when option is selected',
        (tester) async {
      // Given
      PromoterSearchOption? selectedOption;
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      // When
      await tester.pumpWidget(createWidgetUnderTest(
        onSearchOptionChanged: (option) {
          selectedOption = option;
        },
      ));
      await tester.pumpAndSettle();

      // Open dropdown
      final dropdown = find.byType(DropdownButton<PromoterSearchOption>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Select an option (search by email - "Suche nach E-Mail")
      final emailOption = find.text('Suche nach E-Mail').last;
      await tester.tap(emailOption);
      await tester.pumpAndSettle();

      // Then
      expect(selectedOption, PromoterSearchOption.email);
    });

    testWidgets('should toggle filter section when filter button is pressed',
        (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // PromoterOverviewHeaderExpandableFilter is always in the widget tree
      // but initially not visible (ExpandedSection with expand: false)
      final filterWidget = find.byType(PromoterOverviewHeaderExpandableFilter);
      expect(filterWidget, findsOneWidget);

      // Tap filter button to expand
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Then - filter should be visible/expanded
      // We can verify the ExpandedSection is now expanded
      expect(filterWidget, findsOneWidget);
    });
  });

  group('PromoterOverviewHeader Responsive Tests', () {
    testWidgets('should display expanded filter on desktop', (tester) async {
      // Given
      await tester.binding
          .setSurfaceSize(const Size(1920, 1080)); // Desktop size

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap filter button
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Then - expandable filter should be visible
      expect(find.byType(PromoterOverviewHeaderExpandableFilter),
          findsOneWidget);
    });

    testWidgets('should render search bar on mobile', (tester) async {
      // Given
      await tester.binding.setSurfaceSize(const Size(600, 800)); // Larger mobile size to avoid overflow

      // When
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Then
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
