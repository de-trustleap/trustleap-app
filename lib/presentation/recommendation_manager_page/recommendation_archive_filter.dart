import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';

class RecommendationArchiveFilter {
  static List<ArchivedRecommendationItem> applyFilters({
    required List<ArchivedRecommendationItem> items,
    required RecommendationArchiveFilterStates filterStates,
  }) {
    List<ArchivedRecommendationItem> filtered = items.where((item) {
      // filter by status
      if (filterStates.statusFilterState !=
          RecommendationStatusFilterState.all) {
        final success = item.success ?? false;
        return _statusFilterMatches(filterStates.statusFilterState, success);
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
      case RecommendationSortByFilterState.finishedAt:
        filtered.sort((a, b) {
          final aValue = a.finishedTimeStamp;
          final bValue = b.finishedTimeStamp;
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
      RecommendationStatusFilterState filter, bool success) {
    if (filter == RecommendationStatusFilterState.successful) {
      return success == true;
    } else {
      return success == false;
    }
  }
}
