const String fontFamily = "Poppins";

class RoutePaths {
  static const String initialPath = "/";
  static const String dashboardPath = "/dashboard";
  static const String profilePath = "/profile";
  static const String recommendationsPath = "/recommendations";
  static const String promotersPath = "/promoters";
  static const String landingPagePath = "/landingpage";
  static const String activitiesPath = "/activities";
  static const String loginPath = "/login";
  static const String registerPath = "/register";
}

enum MenuItems {
  profile("Profil"),
  dashboard("Dashboard"),
  recommendations("Empfehlungen"),
  promoters("Promoter"),
  landingpage("Landingpage"),
  activities("Aktivitäten");

  final String value;
  const MenuItems(this.value);
}

enum EmailVerificationState {
  verified("Verifiziert"),
  unverified("Unverifiziert");

  final String value;
  const EmailVerificationState(this.value);
}
