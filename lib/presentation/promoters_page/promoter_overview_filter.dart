import 'package:finanzbegleiter/domain/entities/promoter.dart';
import 'package:finanzbegleiter/presentation/promoters_page/widgets/promoter_overview/promoter_overview_header_expandable_filter.dart';

class PromoterOverviewFilter {
  List<Promoter> onFilterChanged(
      PromoterOverviewFilterStates filterStates, List<Promoter> searchResults) {
    List<Promoter> filterResults = searchResults;
    switch (filterStates.registrationFilterState) {
      case PromoterRegistrationFilterState.all:
        filterResults = searchResults;
      case PromoterRegistrationFilterState.registered:
        filterResults = filterResults
            .where((element) => element.registered == true)
            .toList();
      case PromoterRegistrationFilterState.unregistered:
        filterResults = filterResults
            .where((element) => element.registered == false)
            .toList();
    }
    switch (filterStates.sortByFilterState) {
      case PromoterSortByFilterState.createdAt:
        if (filterStates.sortOrderFilterState ==
            PromoterSortOrderFilterState.asc) {
          filterResults.sort((a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              return a.createdAt!.compareTo(b.createdAt!);
            } else {
              return 0;
            }
          } );
        } else {
          filterResults.sort((a, b) {
            if (a.createdAt != null && b.createdAt != null) {
              return b.createdAt!.compareTo(a.createdAt!);
            } else {
              return 0;
            }
          });
        }
      case PromoterSortByFilterState.email:
        if (filterStates.sortOrderFilterState ==
            PromoterSortOrderFilterState.asc) {
          filterResults.sort((a, b) {
            if (a.email != null && b.email != null) {
              return a.email!.compareTo(b.email!);
            } else {
              return 0;
            }
          });
        } else {
          filterResults.sort((a, b) {
            if (a.email != null && b.email != null) {
              return b.email!.compareTo(a.email!);
            } else {
              return 0;
            }
          });
        }
      case PromoterSortByFilterState.firstName:
        if (filterStates.sortOrderFilterState ==
            PromoterSortOrderFilterState.asc) {
          filterResults.sort((a, b) {
            if (a.firstName != null && b.firstName != null) {
              return a.firstName!.compareTo(b.firstName!);
            } else {
              return 0;
            }
          });
        } else {
          filterResults.sort((a, b) {
            if (a.firstName != null && b.firstName != null) {
              return b.firstName!.compareTo(a.firstName!);
            } else {
              return 0;
            }
          });
        }
      case PromoterSortByFilterState.lastName:
        if (filterStates.sortOrderFilterState ==
            PromoterSortOrderFilterState.asc) {
          filterResults.sort((a, b) {
            if (a.lastName != null && b.lastName != null) {
              return a.lastName!.compareTo(b.lastName!);
            } else {
              return 0;
            }
          });
        } else {
          filterResults.sort((a, b) {
            if (a.lastName != null && b.firstName != null) {
              return b.lastName!.compareTo(a.lastName!);
            } else {
              return 0;
            }
          });
        }
    }
    return filterResults;
  }

  List<Promoter> onSearchQueryChanged(
      String query, List<Promoter> allPromoters) {
    return allPromoters.where((element) {
      if (element.firstName != null &&
          element.lastName != null &&
          element.email != null) {
        final fullName = "${element.firstName!} ${element.lastName!}";
        final fullNameReversed = "${element.lastName!} ${element.firstName!}";
        return fullName.toLowerCase().contains(query.toLowerCase()) ||
            fullNameReversed.toLowerCase().contains(query.toLowerCase()) ||
            element.email!.toLowerCase().contains(query.toLowerCase());
      } else {
        return false;
      }
    }).toList();
  }
}
