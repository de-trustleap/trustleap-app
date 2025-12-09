import 'package:finanzbegleiter/constants.dart';

class RoutePaths {
  static const String adminPath = "/admin";
  static const String companyRequestsPath = "/company-requests";
  static const String companyRequestDetails = "/company-request-details";
  static const String registrationCodes = "/registration-codes";
  static const String userFeedback = "/user-feedback";
  static const String legals = "/legals";

  static const String homePath = "/home";
  static const String dashboardPath = "/dashboard";
  static const String profilePath = "/profile";
  static const String profileGeneralPath = "/general";
  static const String profileCompanyPath = "/company";
  static const String profilePasswordPath = "/change-password";
  static const String profileDeletePath = "/delete-account";
  static const String companyRegistration = "/company-registration";
  static const String recommendationsPath = "/recommendations";
  static const String recommendationManagerPath = "/recommendation-manager";
  static const String recommendationManagerActivePath = "/active";
  static const String recommendationManagerArchivePath = "/archive";
  static const String promotersPath = "/promoters";
  static const String promotersOverviewPath = "/overview";
  static const String promotersRegisterPath = "/register";
  static const String editPromoterPath = "/edit-promoter";
  static const String landingPagePath = "/landingpage";
  static const String landingPageCreatorPath = "/landingpage-creator";
  static const String landingPageCreatorStep1Path = "/step-1";
  static const String landingPageCreatorStep2Path = "/step-2";
  static const String landingPageCreatorStep3Path = "/step-3";
  static const String landingPageCreatorStep4Path = "/step-4";

  static const String loginPath = "/";
  static const String registerPath = "/register";
  static const String passwordReset = "/password-reset";
  static const String privacyPolicy = "/privacy-policy";
  static const String termsAndCondition = "/terms-and-condition";
  static const String imprint = "/imprint";

  static const String landingPageBuilderPath = "/landingpage-builder";

  static Map<MenuItems, String> menuItemPaths = {
    MenuItems.profile: RoutePaths.profilePath,
    MenuItems.dashboard: RoutePaths.dashboardPath,
    MenuItems.recommendations: RoutePaths.recommendationsPath,
    MenuItems.promoters: RoutePaths.promotersPath,
    MenuItems.landingpage: RoutePaths.landingPagePath,
    MenuItems.adminCompanyRequests: RoutePaths.companyRequestsPath,
    MenuItems.registrationCodes: RoutePaths.registrationCodes,
    MenuItems.userFeedback: RoutePaths.userFeedback
  };
}
