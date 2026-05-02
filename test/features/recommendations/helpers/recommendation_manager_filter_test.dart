import 'package:flutter_test/flutter_test.dart';
import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_compensation.dart';
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
        recommendation: PersonalizedRecommendationItem(
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
          compensation: null,
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
        recommendation: PersonalizedRecommendationItem(
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
          compensation: null,
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
        recommendation: PersonalizedRecommendationItem(
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
          compensation: null,
          createdAt: DateTime(2023, 3, 1),
          lastUpdated: DateTime(2023, 3, 2),
          expiresAt: DateTime(2024, 10, 15),
        )),
    UserRecommendation(
        id: UniqueID.fromUniqueString("4"),
        recoID: "4",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: null,
        recommendation: PersonalizedRecommendationItem(
          id: '4',
          name: 'Dave',
          reason: 'Termin',
          landingPageID: 'lp4',
          promotionTemplate: 'template',
          promoterName: 'Bob',
          serviceProviderName: 'D',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.appointment,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: null,
          createdAt: DateTime(2023, 4, 1),
          expiresAt: DateTime(2024, 9, 1),
        )),
    UserRecommendation(
        id: UniqueID.fromUniqueString("5"),
        recoID: "5",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: null,
        recommendation: PersonalizedRecommendationItem(
          id: '5',
          name: 'Eve',
          reason: 'Vergütung',
          landingPageID: 'lp5',
          promotionTemplate: 'template',
          promoterName: 'Bob',
          serviceProviderName: 'E',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.appointment,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: const RecommendationCompensation(
            status: RecommendationCompensationStatus.manualIssued,
            timestamps: {},
          ),
          createdAt: DateTime(2023, 5, 1),
          expiresAt: DateTime(2024, 8, 1),
        )),
    UserRecommendation(
        id: UniqueID.fromUniqueString("6"),
        recoID: "6",
        userID: "1",
        priority: RecommendationPriority.medium,
        notes: null,
        recommendation: PersonalizedRecommendationItem(
          id: '6',
          name: 'Frank',
          reason: 'Gutschein',
          landingPageID: 'lp6',
          promotionTemplate: 'template',
          promoterName: 'Bob',
          serviceProviderName: 'F',
          defaultLandingPageID: "1",
          userID: "1",
          statusLevel: StatusLevel.appointment,
          statusTimestamps: null,
          promoterImageDownloadURL: null,
          compensation: const RecommendationCompensation(
            status: RecommendationCompensationStatus.voucherSent,
            timestamps: {},
          ),
          createdAt: DateTime(2023, 6, 1),
          expiresAt: DateTime(2024, 7, 1),
        )),
  ];

  test('returns unfiltered list by default', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false);
    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 6);
  });

  test('appointment filter excludes manualIssued and voucherSent', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.appointment;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.displayName, 'Dave');
  });

  test('manualIssued filter returns only items with manualIssued compensation', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.manualIssued;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.displayName, 'Eve');
  });

  test('voucherSent filter returns only items with voucherSent compensation', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.voucherSent;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.displayName, 'Frank');
  });

  test('filters by statusLevel == linkClicked (1)', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.linkClicked;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.displayName, 'Ben');
  });

  test('filters by statusLevel == successful (4)', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..statusFilterState = RecommendationStatusFilterState.successful;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
    );

    expect(result.length, 1);
    expect(result.first.recommendation?.displayName, 'Clara');
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
    expect(promoterNames, ['Anna', 'Bob', 'Bob', 'Bob', 'Max', 'Zoe']);
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

    final receiverNames = result.map((e) => e.recommendation?.displayName).toList();
    expect(receiverNames, ['Frank', 'Eve', 'Dave', 'Clara', 'Ben', 'Anna']);
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
      DateTime(2024, 7, 1),
      DateTime(2024, 8, 1),
      DateTime(2024, 9, 1),
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
    expect(result.map((e) => e.recommendation?.displayName),
        containsAll(['Anna', 'Clara']));
  });

  test('filters only non-favorites', () {
    final filterStates = RecommendationOverviewFilterStates(isArchive: false)
      ..favoriteFilterState = RecommendationFavoriteFilterState.isNotFavorite;

    final result = RecommendationFilter.applyFilters(
      items: testItems,
      filterStates: filterStates,
      favoriteRecommendationIDs: ['1', '3'], // Anna and Clara are favorites
    );

    expect(result.length, 4);
    expect(result.map((e) => e.recommendation?.displayName),
        containsAll(['Ben', 'Dave', 'Eve', 'Frank']));
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

    expect(result.length, 6);
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
