import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/core/id.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_filter.dart';

void main() {
  final List<UserRecommendation> testItems = [
    UserRecommendation(
        id: UniqueID.fromUniqueString("1"),
        recoID: "1",
        userID: "1",
        priority: RecommendationPriority.medium,

        notes: "Test",
        recommendation: RecommendationItem(
          id: '1',
          name: 'Anna',
          reason: 'Finanzen',
          landingPageID: 'lp1',
          promotionTemplate: 'template',
          promoterName: 'Zoe',
          serviceProviderName: 'A',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.recommendationSend,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          createdAt: DateTime(2023, 1, 1),
          lastUpdated: DateTime(2023, 1, 2),
          expiresAt: DateTime(2024, 12, 31),
        )),
    UserRecommendation(
        id: UniqueID.fromUniqueString("2"),
        recoID: "2",
        userID: "1",
        priority: RecommendationPriority.medium,

        notes: "Test",
        recommendation: RecommendationItem(
          id: '2',
          name: 'Ben',
          reason: 'Versicherung',
          landingPageID: 'lp2',
          promotionTemplate: 'template',
          promoterName: 'Max',
          serviceProviderName: 'B',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.linkClicked,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          createdAt: DateTime(2023, 2, 1),
          lastUpdated: DateTime(2023, 2, 2),
          expiresAt: DateTime(2024, 11, 30),
        )),
    UserRecommendation(
        id: UniqueID.fromUniqueString("3"),
        recoID: "3",
        userID: "1",
        priority: RecommendationPriority.medium,

        notes: "Test",
        recommendation: RecommendationItem(
          id: '3',
          name: 'Clara',
          reason: 'Altersvorsorge',
          landingPageID: 'lp3',
          promotionTemplate: 'template',
          promoterName: 'Anna',
          serviceProviderName: 'C',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.successful,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          createdAt: DateTime(2023, 3, 1),
          lastUpdated: DateTime(2023, 3, 2),
          expiresAt: DateTime(2024, 10, 15),
        ))
  ];

  test('returns unfiltered list by default', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false);
    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 3);
  });

  test('filters by statusLevel == linkClicked (1)', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.linkClicked;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.name, 'Ben');
  });

  test('filters by statusLevel == successful (4)', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.successful;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.name, 'Clara');
  });

  test('sorts by promoter ASC', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..sortByFilterState = RecommendationSortByFilterState.promoter
      ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final promoterNames =
        result.map((e) => e.recommendation?.promoterName).toList();
    expect(promoterNames, ['Anna', 'Max', 'Zoe']);
  });

  test('sorts by recommendationReceiver DESC', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..sortByFilterState =
          RecommendationSortByFilterState.recommendationReceiver
      ..sortOrderFilterState = RecommendationSortOrderFilterState.desc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final receiverNames = result.map((e) => e.recommendation?.name).toList();
    expect(receiverNames, ['Clara', 'Ben', 'Anna']);
  });

  test('sorts by expiresAt ASC', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..sortByFilterState = RecommendationSortByFilterState.expiresAt
      ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    final expiresAtDates =
        result.map((e) => e.recommendation?.expiresAt).toList();
    expect(expiresAtDates, [
      DateTime(2024, 10, 15),
      DateTime(2024, 11, 30),
      DateTime(2024, 12, 31),
    ]);
  });

  test('filters only favorites', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..favoriteFilterState = RecommendationFavoriteFilterState.isFavorite;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
      favoriteRecommendationIDs: ['1', '3'], // Anna and Clara are favorites
    );

    expect(result.length, 2);
    expect(result.map((e) => e.recommendation?.name),
        containsAll(['Anna', 'Clara']));
  });

  test('filters only non-favorites', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..favoriteFilterState = RecommendationFavoriteFilterState.isNotFavorite;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
      favoriteRecommendationIDs: ['1', '3'], // Anna and Clara are favorites, so Ben is not
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.name, 'Ben');
  });

  test('filters only high priority items', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..priorityFilterState = RecommendationPriorityFilterState.high;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.isEmpty, true);
  });

  test('filters only medium priority items', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..priorityFilterState = RecommendationPriorityFilterState.medium;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 3);
  });

  test('filters only low priority items', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..priorityFilterState = RecommendationPriorityFilterState.low;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.isEmpty, true);
  });
}
