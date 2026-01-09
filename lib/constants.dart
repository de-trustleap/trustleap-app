enum MenuItems {
  profile("Profil"),
  dashboard("Dashboard"),
  recommendations("Empfehlungen"),
  recommendationManager("Empfehlungsmanager"),
  promoters("Promoter"),
  landingpage("Landingpage"),

  adminCompanyRequests("Unternehmensanfragen"),
  registrationCodes("Codes"),
  userFeedback("Nutzerfeedback"),
  legals("Rechtliches"),
  templates("Templates"),
  none("");

  final String value;
  const MenuItems(this.value);
}

class MenuDimensions {
  static const menuOpenWidth = 300.0;
  static const menuCollapsedWidth = 80.0;
}

enum AuthStatus {
  authenticated("Authentifiziert"),
  unAuthenticated("Nicht authentifiziert"),
  authenticatedAsAdmin("Authentifiziert als Admin");

  final String value;
  const AuthStatus(this.value);
}

enum EmailVerificationState {
  verified("Verifiziert"),
  unverified("Unverifiziert");

  final String value;
  const EmailVerificationState(this.value);
}

enum Gender {
  male("Männlich"),
  female("Weiblich"),
  none("Nicht ausgewählt");

  final String value;
  const Gender(this.value);
}

enum Role {
  admin("Administrator"),
  company("Unternehmen"),
  serviceProvider("Dienstleister"),
  promoter("Promoter"),
  none("Keine");

  final String value;
  const Role(this.value);
}

enum PromoterRegistrationState {
  registered("Registriert"),
  unregistered("Nicht registriert");

  final String value;
  const PromoterRegistrationState(this.value);
}

enum ImageUploader { user, company, landingPage }

enum ThemeStatus { light, dark }

enum PageBuilderWidgetType {
  container,
  column,
  row,
  text,
  image,
  icon,
  button,
  contactForm,
  footer,
  videoPlayer,
  anchorButton,
  calendly,
  placeholder,
  height,
  none
}

enum PageBuilderSpacingType { padding, margin }

enum PagebuilderResponsiveBreakpoint { mobile, tablet, desktop }

enum LegalsType { privacyPolicy, termsAndCondition, imprint }

enum LogLevel { debug, info, warn, error }

enum TimePeriod {
  day("Tag"),
  week("Woche"),
  month("Monat"),
  quarter("Quartal"),
  year("Jahr");

  final String value;
  const TimePeriod(this.value);
}

enum RecommendationSearchOption {
  promoterName("Suche nach Promotern"),
  name("Suche nach Empfehlungsempfängern"),
  reason("Suche nach Empfehlungsgründen");

  final String value;
  const RecommendationSearchOption(this.value);
}

enum PromoterSearchOption {
  fullName("Suche nach Name"),
  email("Suche nach E-Mail");

  final String value;
  const PromoterSearchOption(this.value);
}

/// Email validation regex pattern used across the app
const String emailRegex =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$";

enum FeedbackType {
  feedback("Feedback"),
  bug("Fehler");

  final String value;
  const FeedbackType(this.value);
}

enum BusinessModel { b2b, b2c }

enum ContactOption { calendly, contactForm, both }

enum SectionType { hero, about, product, callToAction, advantages, footer }

enum ConsentCategory {
  necessary,
  statistics,
}

enum ConsentMethod {
  acceptAll,
  rejectAll,
  custom,
}
