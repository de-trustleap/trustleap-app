import 'package:finanzbegleiter/domain/entities/landing_page.dart';

class LandingPageCheckboxItem {
  LandingPage landingPage;
  bool isSelected;
  LandingPageCheckboxItem({
    required this.landingPage,
    required this.isSelected,
  });
}
