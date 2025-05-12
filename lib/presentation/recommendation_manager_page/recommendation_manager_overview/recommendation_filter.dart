import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';

class RecommendationFilter {
  static List<UserRecommendation> applyFilters({
    required List<UserRecommendation> items,
    required RecommendationOverviewFilterStates filterStates,
  }) {
    List<UserRecommendation> filtered = items.where((item) {
      // filter by status
      if (filterStates.statusFilterState !=
          RecommendationStatusFilterState.all) {
        final statusLevel = item.recommendation?.statusLevel ?? 0;
        return _statusFilterMatches(
            filterStates.statusFilterState, statusLevel);
      }
      return true;
    }).toList();

    // apply sorting
    switch (filterStates.sortByFilterState) {
      case RecommendationSortByFilterState.promoter:
        filtered.sort((a, b) {
          final aValue = a.recommendation?.promoterName ?? '';
          final bValue = b.recommendation?.promoterName ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.recommendationReceiver:
        filtered.sort((a, b) {
          final aValue = a.recommendation?.name ?? '';
          final bValue = b.recommendation?.name ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.reason:
        filtered.sort((a, b) {
          final aValue = a.recommendation?.reason ?? '';
          final bValue = b.recommendation?.reason ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.lastUpdated:
        filtered.sort((a, b) {
          final aValue = a.recommendation?.lastUpdated ??
              a.recommendation?.createdAt ??
              DateTime.now();
          final bValue = b.recommendation?.lastUpdated ??
              b.recommendation?.createdAt ??
              DateTime.now();
          return _sortDates(aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.expiresAt:
        filtered.sort((a, b) {
          final aValue = a.recommendation?.expiresAt ?? DateTime.now();
          final bValue = b.recommendation?.expiresAt ?? DateTime.now();
          return _sortDates(aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      default:
        break;
    }

    return filtered;
  }

  static int _sortStrings(
      String a, String b, RecommendationSortOrderFilterState order) {
    return order == RecommendationSortOrderFilterState.asc
        ? a.compareTo(b)
        : b.compareTo(a);
  }

  static int _sortDates(
      DateTime a, DateTime b, RecommendationSortOrderFilterState order) {
    return order == RecommendationSortOrderFilterState.asc
        ? a.compareTo(b)
        : b.compareTo(a);
  }

  static bool _statusFilterMatches(
      RecommendationStatusFilterState filter, int statusLevel) {
    switch (filter) {
      case RecommendationStatusFilterState.recommendationSent:
        return statusLevel == 0;
      case RecommendationStatusFilterState.linkClicked:
        return statusLevel == 1;
      case RecommendationStatusFilterState.contactFormSent:
        return statusLevel == 2;
      case RecommendationStatusFilterState.appointment:
        return statusLevel == 3;
      case RecommendationStatusFilterState.successful:
        return statusLevel == 4;
      case RecommendationStatusFilterState.failed:
        return statusLevel == 5;
      case RecommendationStatusFilterState.all:
        return true;
    }
  }
}
