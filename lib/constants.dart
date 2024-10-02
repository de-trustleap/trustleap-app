const String fontFamily = "Poppins";

enum MenuItems {
  profile("Profil"),
  dashboard("Dashboard"),
  recommendations("Empfehlungen"),
  promoters("Promoter"),
  landingpage("Landingpage"),
  activities("Aktivitäten"),

  adminCompanyRequests("Unternehmensanfragen"),
  none("");

  final String value;
  const MenuItems(this.value);
}

class MenuDimensions {
  static const menuOpenWidth = 250.0;
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
  none
}

enum PageBuilderSectionLayout { row, column, none }
