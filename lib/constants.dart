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
  femaile("Weiblich"),
  none("Nicht ausgewählt");

  final String value;
  const Gender(this.value);
}
