import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';

class RecommendationFilter {
  static List<RecommendationItem> applyFilters({
    required List<RecommendationItem> items,
    required RecommendationOverviewFilterStates filterStates,
  }) {
    List<RecommendationItem> filtered = items.where((item) {
      // filter by status
      if (filterStates.statusFilterState !=
          RecommendationStatusFilterState.all) {
        final statusLevel = item.statusLevel ?? 0;
        return _statusFilterMatches(
            filterStates.statusFilterState, statusLevel);
      }
      return true;
    }).toList();

    // apply sorting
    switch (filterStates.sortByFilterState) {
      case RecommendationSortByFilterState.promoter:
        filtered.sort((a, b) {
          final aValue = a.promoterName ?? '';
          final bValue = b.promoterName ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.recommendationReceiver:
        filtered.sort((a, b) {
          final aValue = a.name ?? '';
          final bValue = b.name ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.reason:
        filtered.sort((a, b) {
          final aValue = a.reason ?? '';
          final bValue = b.reason ?? '';
          return _sortStrings(
              aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.lastUpdated:
        filtered.sort((a, b) {
          final aValue = a.lastUpdated ?? a.createdAt;
          final bValue = b.lastUpdated ?? b.createdAt;
          return _sortDates(aValue, bValue, filterStates.sortOrderFilterState);
        });
        break;
      case RecommendationSortByFilterState.expiresAt:
        filtered.sort((a, b) {
          final aValue = a.expiresAt;
          final bValue = b.expiresAt;
          return _sortDates(aValue, bValue, filterStates.sortOrderFilterState);
        });
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
