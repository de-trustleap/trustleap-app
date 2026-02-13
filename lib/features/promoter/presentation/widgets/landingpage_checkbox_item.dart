import 'package:finanzbegleiter/features/landing_pages/domain/landing_page.dart';

class LandingPageCheckboxItem {
  LandingPage landingPage;
  bool isSelected;
  LandingPageCheckboxItem({
    required this.landingPage,
    required this.isSelected,
  });
}
