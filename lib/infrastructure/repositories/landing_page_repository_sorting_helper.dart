import 'package:finanzbegleiter/domain/entities/landing_page.dart';

class LandingPageRepositorySortingHelper {
  List<LandingPage> sortLandingPages(List<LandingPage> landingPages) {
    final List<LandingPage> sortedPages = landingPages;
    sortedPages.sort((a, b) {
      DateTime aDate = a.lastUpdatedAt ?? a.createdAt ?? DateTime(1970);
      DateTime bDate = b.lastUpdatedAt ?? b.createdAt ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    sortedPages.sort((a, b) {
      bool aActive = a.isActive ?? false;
      bool bActive = b.isActive ?? false;
      if (aActive == bActive) return 0;
      return aActive ? -1 : 1;
    });
    sortedPages.sort((a, b) {
      if (b.isDefaultPage ?? false) {
        return 1;
      } else {
        return -1;
      }
    });
    return sortedPages;
  }
}
