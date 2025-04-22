import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_filter.dart';

void main() {
  final List<RecommendationItem> testItems = [
    RecommendationItem(
      id: '1',
      name: 'Anna',
      reason: 'Finanzen',
      landingPageID: 'lp1',
      promotionTemplate: 'template',
      promoterName: 'Zoe',
      serviceProviderName: 'A',
      defaultLandingPageID: "1",
      statusLevel: 0,
      statusTimestamps: null,
      createdAt: DateTime(2023, 1, 1),
      lastUpdated: DateTime(2023, 1, 2),
      expiresAt: DateTime(2024, 12, 31),
    ),
    RecommendationItem(
      id: '2',
      name: 'Ben',
      reason: 'Versicherung',
      landingPageID: 'lp2',
      promotionTemplate: 'template',
      promoterName: 'Max',
      serviceProviderName: 'B',
      defaultLandingPageID: "1",
      statusLevel: 1,
      statusTimestamps: null,
      createdAt: DateTime(2023, 2, 1),
      lastUpdated: DateTime(2023, 2, 2),
      expiresAt: DateTime(2024, 11, 30),
    ),
    RecommendationItem(
      id: '3',
      name: 'Clara',
      reason: 'Altersvorsorge',
      landingPageID: 'lp3',
      promotionTemplate: 'template',
      promoterName: 'Anna',
      serviceProviderName: 'C',
      defaultLandingPageID: "1",
      statusLevel: 4,
      statusTimestamps: null,
      createdAt: DateTime(2023, 3, 1),
      lastUpdated: DateTime(2023, 3, 2),
      expiresAt: DateTime(2024, 10, 15),
    ),
  ];

  test('returns unfiltered list by default', () {
    final filterStates = RecommendationOverviewFilterStates();
    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 3);
  });

  test('filters by statusLevel == linkClicked (1)', () {
    final filterStates = RecommendationOverviewFilterStates()
      ..statusFilterState = RecommendationStatusFilterState.linkClicked;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.name, 'Ben');
  });

  test('filters by statusLevel == successful (4)', () {
    final filterStates = RecommendationOverviewFilterStates()
      ..statusFilterState = RecommendationStatusFilterState.successful;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.name, 'Clara');
  });

  test('sorts by promoter ASC', () {
    final filterStates = RecommendationOverviewFilterStates()
      ..sortByFilterState = RecommendationSortByFilterState.promoter
      ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final promoterNames = result.map((e) => e.promoterName).toList();
    expect(promoterNames, ['Anna', 'Max', 'Zoe']);
  });

  test('sorts by recommendationReceiver DESC', () {
    final filterStates = RecommendationOverviewFilterStates()
      ..sortByFilterState =
          RecommendationSortByFilterState.recommendationReceiver
      ..sortOrderFilterState = RecommendationSortOrderFilterState.desc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final receiverNames = result.map((e) => e.name).toList();
    expect(receiverNames, ['Clara', 'Ben', 'Anna']);
  });

  test('sorts by expiresAt ASC', () {
    final filterStates = RecommendationOverviewFilterStates()
      ..sortByFilterState = RecommendationSortByFilterState.expiresAt
      ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final expiresAtDates = result.map((e) => e.expiresAt).toList();
    expect(expiresAtDates, [
      DateTime(2024, 10, 15),
      DateTime(2024, 11, 30),
      DateTime(2024, 12, 31),
    ]);
  });
}
