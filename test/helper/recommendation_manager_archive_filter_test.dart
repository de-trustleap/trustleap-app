import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive/recommendation_archive_filter.dart';

void main() {
  group('RecommendationArchiveFilter', () {
    final testData = [
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("1"),
          name: "Alice",
          reason: "Test 1",
          promoterName: "Promoter X",
          serviceProviderName: "Test",
          success: true,
          userID: "1",
          createdAt: null,
          finishedTimeStamp: DateTime(2024, 1, 10),
          expiresAt: null),
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("2"),
          name: "Bob",
          reason: "Test 2",
          promoterName: "Promoter A",
          serviceProviderName: "Test",
          success: false,
          userID: "1",
          createdAt: null,
          finishedTimeStamp: DateTime(2024, 2, 5),
          expiresAt: null),
      ArchivedRecommendationItem(
          id: UniqueID.fromUniqueString("3"),
          name: "Charlie",
          reason: "Test 3",
          promoterName: "Promoter B",
          serviceProviderName: "Test",
          success: true,
          userID: "1",
          createdAt: null,
          finishedTimeStamp: DateTime(2024, 1, 20),
          expiresAt: null),
    ];

    test('filters by success status = successful', () {
      final filter = RecommendationOverviewFilterStates(isArchive: true)
        ..statusFilterState = RecommendationStatusFilterState.successful;

      final result = RecommendationArchiveFilter.applyFilters(
        items: testData,
        filterStates: filter,
      );

      expect(result.length, 2);
      expect(result.every((e) => e.success == true), true);
    });

    test('filters by success status = failed', () {
      final filter = RecommendationOverviewFilterStates(isArchive: true)
        ..statusFilterState = RecommendationStatusFilterState.failed;

      final result = RecommendationArchiveFilter.applyFilters(
        items: testData,
        filterStates: filter,
      );

      expect(result.length, 1);
      expect(result.first.success, false);
    });

    test('sorts by promoter name ascending', () {
      final filter = RecommendationOverviewFilterStates(isArchive: true)
        ..sortByFilterState = RecommendationSortByFilterState.promoter
        ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

      final result = RecommendationArchiveFilter.applyFilters(
        items: testData,
        filterStates: filter,
      );

      expect(result.map((e) => e.promoterName),
          ['Promoter A', 'Promoter B', 'Promoter X']);
    });

    test('sorts by receiver name descending', () {
      final filter = RecommendationOverviewFilterStates(isArchive: true)
        ..sortByFilterState =
            RecommendationSortByFilterState.recommendationReceiver
        ..sortOrderFilterState = RecommendationSortOrderFilterState.desc;

      final result = RecommendationArchiveFilter.applyFilters(
        items: testData,
        filterStates: filter,
      );

      expect(result.map((e) => e.name), ['Charlie', 'Bob', 'Alice']);
    });

    test('sorts by finishedAt date ascending', () {
      final filter = RecommendationOverviewFilterStates(isArchive: true)
        ..sortByFilterState = RecommendationSortByFilterState.finishedAt
        ..sortOrderFilterState = RecommendationSortOrderFilterState.asc;

      final result = RecommendationArchiveFilter.applyFilters(
        items: testData,
        filterStates: filter,
      );

      expect(result.map((e) => e.finishedTimeStamp), [
        DateTime(2024, 1, 10),
        DateTime(2024, 1, 20),
        DateTime(2024, 2, 5),
      ]);
    });
  });
}
