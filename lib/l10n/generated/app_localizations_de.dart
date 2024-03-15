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
  String get login_password_forgotten_text => 'Haben Sie ihr ';

  @override
  String get login_password_forgotten_linktext => 'Passwort vergessen?';

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
  String get auth_validation_invalid_date => 'Das eingegebene Datum ist ungültig';

  @override
  String get auth_validation_invalid_postcode => 'Die PLZ ist ungültig';

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

  @override
  String get auth_failure_email_already_in_use => 'Die E-Mail Adresse ist bereits vergeben.';

  @override
  String get auth_failure_invalid_email => 'Die eingegebene E-Mail Adresse ist ungültig.';

  @override
  String get auth_failure_weak_password => 'Das angegebene Passwort ist zu schwach. Bitte nutze mindestens 6 Zeichen.';

  @override
  String get auth_failure_user_disabled => 'Der angegebene Nutzername ist gesperrt.';

  @override
  String get auth_failure_user_not_found => 'Der angegebene Nutzername existiert nicht.';

  @override
  String get auth_failure_wrong_password => 'Das angegebene Passwort ist falsch.';

  @override
  String get auth_failure_invalid_credentials => 'Deine angegebenen Zugangsdaten existieren nicht.';

  @override
  String get auth_failure_too_many_requests => 'Du hast deine Zugangsdaten zu oft falsch eingegeben. Versuche es später noch einmal.';

  @override
  String get auth_failure_user_mismatch => 'Deine Anmeldeinformationen gehören nicht zum aktuellen User.';

  @override
  String get auth_failure_invalid_verification_code => 'Dein Verifizierungscode ist ungültig.';

  @override
  String get auth_failure_invalid_verification_id => 'Die ID zu deinen Anmeldeinformationen ist ungültig.';

  @override
  String get auth_failure_requires_recent_login => 'Deine letzte Anmeldung ist zu lange her. Melde dich erneut an.';

  @override
  String get auth_failure_missing_password => 'Du musst dein Password angeben.';

  @override
  String get auth_failure_unknown => 'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get database_failure_permission_denied => 'Sie sind nicht berechtigt auf die Daten zuzugreifen.';

  @override
  String get database_failure_not_found => 'Die angefragten Daten wurden nicht gefunden.';

  @override
  String get database_failure_already_exists => 'Die angegebenen Daten existieren bereits.';

  @override
  String get database_failure_deadline_exceeded => 'Der Datenabruf dauert zu lange. Versuche es später nochmal.';

  @override
  String get database_failure_cancelled => 'Die Operation wurde abgebrochen.';

  @override
  String get database_failure_unavailable => 'Der Service ist gerade nicht erreichbar.';

  @override
  String get database_failure_unknown => 'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get storage_failure_object_not_found => 'Es wurde kein Bild gefunden.';

  @override
  String get storage_failure_not_authenticated => 'Du musst dich anmelden um diesen Service nutzen zu können.';

  @override
  String get storage_failure_not_authorized => 'Du bist nicht berechtigt diese Aktion auszuführen.';

  @override
  String get storage_failure_retry_limit_exceeded => 'Es scheint ein Problem aufgetreten zu sein. Die Aktion dauert länger als gewöhnlich. Bitte versuche es später erneut.';

  @override
  String get storage_failure_unknown => 'Ein unbekannter Fehler ist aufgetreten. Bitte versuche es später erneut.';

  @override
  String get password_forgotten_title => 'Passwort zurücksetzen';

  @override
  String get password_forgotten_description => 'Bitte geben Sie ihre E-Mail Adresse ein und bestätigen Sie. Ihnen wird anschließend ein Link an die angegebene E-Mail Adresse gesendet.\nÜber diesen Link können Sie ihr Passwort zurücksetzen.';

  @override
  String get password_forgotten_success_dialog_title => 'Passwort erfolgreich zurückgesetzt';

  @override
  String get password_forgotten_success_dialog_description => 'Eine E-Mail wurde an die angegebene E-Mail Adresse gesendet. Über den Link in der Mail können Sie ihr neues Passwort festlegen.';

  @override
  String get password_forgotten_success_dialog_ok_button_title => 'Zurück zum Login';

  @override
  String get password_forgotten_button_title => 'Passwort zurücksetzen';

  @override
  String get password_forgotten_email_textfield_placeholder => 'E-Mail Adresse';

  @override
  String get general_error_view_refresh_button_title => 'Erneut versuchen';

  @override
  String get profile_page_email_section_email => 'E-Mail';

  @override
  String get profile_page_email_section_status => 'Status';

  @override
  String get profile_page_email_section_description => 'Geben Sie jetzt ihre neue E-Mail Adresse an und bestätigen Sie. An die neue E-Mail Adresse wird anschließend ein Bestätigungslink gesendet. Durch diesen Link können Sie Ihre neue E-Mail Adresse verifizieren und sich erneut anmelden.';

  @override
  String get profile_page_email_section_change_email_button_title => 'E-Mail Adresse ändern';

  @override
  String get profile_page_email_section_change_email_password_description => 'Geben Sie bitte ihr Passwort ein wenn Sie ihre E-Mail Adresse ändern möchten.';

  @override
  String get profile_page_email_section_change_email_password_continue_button_title => 'Weiter';

  @override
  String get profile_page_email_section_resend_verify_email_button_title => 'Link zur Email-Verifikation erneut senden';

  @override
  String get profile_page_email_section_title => 'E-Mail Einstellungen';

  @override
  String get profile_page_email_section_verification_badge_verified => 'Verifiziert';

  @override
  String get profile_page_email_section_verification_badge_unverified => 'Unverifiziert';

  @override
  String get profile_page_image_section_validation_exceededFileSize => 'Sie haben die zulässige Maximalgröße von 5 MB überschritten';

  @override
  String get profile_page_image_section_validation_not_valid => 'Das ist kein gültiges Bildformat';

  @override
  String get profile_page_image_section_only_one_allowed => 'Du kannst nur ein Bild gleichzeitig hochladen';

  @override
  String get profile_page_image_section_upload_not_found => 'Das Bild zum Hochladen wurde nicht gefunden';

  @override
  String get profile_page_image_section_large_image_view_close_button_tooltip_title => 'Schließen';

  @override
  String get profile_page_password_update_section_title => 'Passwort ändern';

  @override
  String get profile_page_password_update_section_new_password_description => 'Geben Sie bitte ihr neues Passwort an und bestätigen Sie es. Danach werden Sie ausgeloggt und Sie können sich mit dem neuen Passwort anmelden.';

  @override
  String get profile_page_password_update_section_new_password_textfield_placeholder => 'Neues Passwort';

  @override
  String get profile_page_password_update_section_new_password_repeat_textfield_placeholder => 'Neues Passwort wiederholen';

  @override
  String get profile_page_password_update_section_new_password_confirm_button_text => 'Passwort ändern';

  @override
  String get profile_page_password_update_section_reauth_description => 'Geben Sie bitte ihr aktuelles Password ein damit Sie ein neues Password erstellen können.';

  @override
  String get profile_page_password_update_section_reauth_password_textfield_placeholder => 'Passwort';

  @override
  String get profile_page_password_update_section_reauth_continue_button_title => 'Weiter';

  @override
  String get profile_page_contact_section_title => 'Kontaktinformationen';

  @override
  String get profile_page_contact_section_form_firstname => 'Vorname';

  @override
  String get profile_page_contact_section_form_lastname => 'Nachname';

  @override
  String get profile_page_contact_section_form_address => 'Straße und Hausnummer';

  @override
  String get profile_page_contact_section_form_postcode => 'PLZ';

  @override
  String get profile_page_contact_section_form_place => 'Ort';

  @override
  String get profile_page_contact_section_form_save_button_title => 'Änderungen speichern';

  @override
  String get profile_page_snackbar_image_changed_message => 'Sie haben das Profilbild erfolgreich angepasst.';

  @override
  String get profile_page_snackbar_contact_information_changes => 'Die Änderung deiner Kontaktinformationen war erfolgreich.';

  @override
  String get profile_page_snackbar_email_verification => 'Es wurde ein Link zur E-Mail Verifikation an dich versendet.';

  @override
  String get profile_page_logout_button_title => 'Abmelden';

  @override
  String get profile_page_request_failure_message => 'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String get profile_page_promoters_section_title => 'Empfehlungsgeber';

  @override
  String get profile_page_promoters_section_recommender_count => 'Anzahl der Empfehlungsgeber:';
}
