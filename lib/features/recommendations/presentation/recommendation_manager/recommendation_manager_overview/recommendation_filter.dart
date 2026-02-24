import 'package:finanzbegleiter/features/recommendations/domain/personalized_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/user_recommendation.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';

class RecommendationFilter {
  static List<UserRecommendation> applyFilters({
    required List<UserRecommendation> items,
    required RecommendationOverviewFilterStates filterStates,
    List<String>? favoriteRecommendationIDs,
  }) {
    // filter by status
    List<UserRecommendation> filtered = items.where((item) {
      if (filterStates.statusFilterState !=
          RecommendationStatusFilterState.all) {
        final reco = item.recommendation;
        final personalizedReco = reco is PersonalizedRecommendationItem ? reco : null;
        final statusLevel = personalizedReco?.statusLevel ?? StatusLevel.recommendationSend;
        return _statusFilterMatches(
            filterStates.statusFilterState, statusLevel);
      }
      return true;
    }).toList();

    // filter by favorite
    filtered = filtered.where((item) {
      final isFavorite = favoriteRecommendationIDs?.contains(item.id.value) ?? false;
      switch (filterStates.favoriteFilterState) {
        case RecommendationFavoriteFilterState.isFavorite:
          return isFavorite;
        case RecommendationFavoriteFilterState.isNotFavorite:
          return !isFavorite;
        case RecommendationFavoriteFilterState.all:
          return true;
      }
    }).toList();

    // filter by priority
    filtered = filtered.where((item) {
      switch (filterStates.priorityFilterState) {
        case RecommendationPriorityFilterState.high:
          return item.priority == RecommendationPriority.high;
        case RecommendationPriorityFilterState.medium:
          return item.priority == RecommendationPriority.medium;
        case RecommendationPriorityFilterState.low:
          return item.priority == RecommendationPriority.low;
        case RecommendationPriorityFilterState.all:
          return true;
      }
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
          final aValue = a.recommendation?.displayName ?? '';
          final bValue = b.recommendation?.displayName ?? '';
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
      RecommendationStatusFilterState filter, StatusLevel statusLevel) {
    switch (filter) {
      case RecommendationStatusFilterState.recommendationSent:
        return statusLevel == StatusLevel.recommendationSend;
      case RecommendationStatusFilterState.linkClicked:
        return statusLevel == StatusLevel.linkClicked;
      case RecommendationStatusFilterState.contactFormSent:
        return statusLevel == StatusLevel.contactFormSent;
      case RecommendationStatusFilterState.appointment:
        return statusLevel == StatusLevel.appointment;
      case RecommendationStatusFilterState.successful:
        return statusLevel == StatusLevel.successful;
      case RecommendationStatusFilterState.failed:
        return statusLevel == StatusLevel.failed;
      case RecommendationStatusFilterState.all:
        return true;
    }
  }
}
