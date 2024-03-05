import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get register_title => 'Registrieren';

  @override
  String get register_subtitle => 'Registriere dich jetzt um den Service zu nutzen.';

  @override
  String get register_firstname => 'Vorname';

  @override
  String get register_lastname => 'Name';

  @override
  String get register_birthdate => 'Geburtsdatum';

  @override
  String get register_address => 'Straße u. Hausnummer (optional)';

  @override
  String get register_postcode => 'PLZ (optional)';

  @override
  String get register_place => 'Ort (optional)';

  @override
  String get register_email => 'E-Mail';

  @override
  String get register_password => 'Passwort';

  @override
  String get register_repeat_password => 'Passwort bestätigen';

  @override
  String get register_now_buttontitle => 'Jetzt Registrieren';

  @override
  String get login_title => 'Willkommen';

  @override
  String get login_subtitle => 'Melde dich an oder registriere dich.';

  @override
  String get login_email => 'E-Mail';

  @override
  String get login_password => 'Passwort';

  @override
  String get login_login_buttontitle => 'Anmelden';

  @override
  String get login_register_linktitle => 'Jetzt registrieren';

  @override
  String get login_register_text => 'Du hast kein Konto? ';

  @override
  String get auth_validation_missing_email => 'Gib bitte eine E-Mail Adresse an';

  @override
  String get auth_validation_invalid_email => 'Ungültige E-Mail Adresse';

  @override
  String get auth_validation_missing_password => 'Bitte ein Password angeben';

  @override
  String get auth_validation_confirm_password => 'Bitte das Passwort bestätigen';

  @override
  String get auth_validation_matching_passwords => 'Die Passwörter stimmen nicht überein';

  @override
  String get auth_validation_missing_firstname => 'Bitte den Vornamen angeben';

  @override
  String get auth_validation_long_firstname => 'Der angegebene Vorname ist zu lang';

  @override
  String get auth_validation_missing_lastname => 'Bitte den Nachnamen angeben';

  @override
  String get auth_validation_long_lastname => 'Der angegebene Nachname ist zu lang';

  @override
  String get auth_validation_missing_birthdate => 'Bitte das Geburtsdatum angeben';

  @override
  String get auth_validation_invalid_birthdate => 'Sie müssen 18 oder älter sein';

  @override
  String get authfailure_email_already_in_use => 'Die E-Mail Adresse ist bereits vergeben.';

  @override
  String get authfailure_invalid_email => 'Die eingegebene E-Mail Adresse ist ungültig.';

  @override
  String get authfailure_weak_password => 'Das angegebene Passwort ist zu schwach. Bitte nutze mindestens 6 Zeichen.';

  @override
  String get authfailure_user_disabled => 'Der angegebene Nutzername ist gesperrt.';

  @override
  String get authfailure_user_not_found => 'Der angegebene Nutzername existiert nicht.';

  @override
  String get authfailure_wrong_password => 'Das angegebene Passwort ist falsch.';

  @override
  String get authfailure_invalid_credentials => 'Deine Zugangsdaten existieren nicht.';

  @override
  String get authfailure_too_many_requests => 'Du hast deine Zugangsdaten zu oft falsch eingegeben. Versuche es später noch einmal.';

  @override
  String get authfailure_unknown => 'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get menuitems_profile => 'Profil';

  @override
  String get menuitems_dashboard => 'Dashboard';

  @override
  String get menuitems_recommendations => 'Empfehlungen';

  @override
  String get menuitems_promoters => 'Promoter';

  @override
  String get menuitems_landingpage => 'Landingpage';

  @override
  String get menuitems_activities => 'Aktivitäten';
}
