import 'package:equatable/equatable.dart';

class Permissions extends Equatable {
  final Map<String, bool> permissions;

  const Permissions({required this.permissions});

  bool _hasPermission(String permission) {
    return permissions[permission] == true;
  }

  bool hasDeleteCompanyPermission() => _hasPermission("deleteCompany");

  bool hasDeleteEmployeePermission() => _hasPermission("deleteEmployee");

  bool hasEditCompanyPermission() => _hasPermission("editCompany");

  bool hasEditEmployeePermission() => _hasPermission("editEmployee");

  bool hasReadCompanyPermission() => _hasPermission("readCompany");

  bool hasRegisterEmployeePermission() => _hasPermission("registerEmployee");

  bool hasShowPromoterMenuPermission() => _hasPermission("showPromoterMenu");

  bool hasShowPromoterDetailsPermission() =>
      _hasPermission("showPromoterDetails");

  bool hasRegisterPromoterPermission() => _hasPermission("registerPromoter");

  bool hasShowLandingPageMenuPermission() =>
      _hasPermission("showLandingPageMenu");

  bool hasCreateLandingPagePermission() => _hasPermission("createLandingPage");

  bool hasDuplicateLandingPagePermission() =>
      _hasPermission("duplicateLandingPage");

  bool hasDeleteLandingPagePermission() => _hasPermission("deleteLandingPage");

  bool hasEditLandingPagePermission() => _hasPermission("editLandingPage");

  bool hasShowDefaultLandingPagePermission() =>
      _hasPermission("showDefaultLandingPage");

  bool hasEditDefaultLandingPagePermission() =>
      _hasPermission("editDefaultLandingPage");

  @override
  List<Object?> get props => [permissions];
}
