const String fontFamily = "Poppins";

enum MenuItems {
  profile("Profil"),
  dashboard("Dashboard"),
  recommendations("Empfehlungen"),
  promoters("Promoter"),
  landingpage("Landingpage"),
  activities("Aktivitäten"),
  none("");

  final String value;
  const MenuItems(this.value);
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

enum RecommendationReason {
  finance("Finanzdienstleistung"),
  car("KFZ-Dienstleistung"),
  insurance("Versicherungsdienstleistung"),
  none("Nicht ausgewählt");

  final String value;
  const RecommendationReason(this.value);
}
