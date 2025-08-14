// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

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
  String get register_code => 'Registrierungscode';

  @override
  String get register_now_buttontitle => 'Jetzt Registrieren';

  @override
  String get register_invalid_code_error =>
      'Die Registrierung ist fehlgeschlagen. Bitte prüfen Sie ob Sie einen gültigen Code und die zugehörige E-Mail Adresse verwenden.';

  @override
  String get register_terms_and_condition_text => 'Ich stimme den';

  @override
  String get register_terms_and_condition_link => 'AGB';

  @override
  String get register_terms_and_condition_text2 => 'zu';

  @override
  String get register_privacy_policy_text => 'Ich stimme der';

  @override
  String get register_privacy_policy_link => 'Datenschutzerklärung';

  @override
  String get register_privacy_policy_text2 => 'zu';

  @override
  String get login_email => 'E-Mail';

  @override
  String get login_password => 'Passwort';

  @override
  String get login_login_buttontitle => 'Anmelden';

  @override
  String get delete_buttontitle => 'Löschen';

  @override
  String get cancel_buttontitle => 'Abbrechen';

  @override
  String get changes_save_button_title => 'Änderungen speichern';

  @override
  String get login_password_forgotten_text => 'Haben Sie ihr ';

  @override
  String get login_password_forgotten_linktext => 'Passwort vergessen?';

  @override
  String get login_register_linktitle => 'Jetzt registrieren';

  @override
  String get login_register_text => 'Du hast kein Konto? ';

  @override
  String get login_permission_error_message =>
      'Bei der Abfrage der Berechtigungen ist ein Fehler aufgetreten';

  @override
  String get auth_validation_missing_email =>
      'Gib bitte eine E-Mail Adresse an';

  @override
  String get auth_validation_invalid_email => 'Ungültige E-Mail Adresse';

  @override
  String get auth_validation_missing_password => 'Bitte ein Password angeben';

  @override
  String get auth_validation_confirm_password =>
      'Bitte das Passwort bestätigen';

  @override
  String get auth_validation_matching_passwords =>
      'Die Passwörter stimmen nicht überein';

  @override
  String get auth_validation_missing_firstname => 'Bitte den Vornamen angeben';

  @override
  String get auth_validation_long_firstname =>
      'Der angegebene Vorname ist zu lang';

  @override
  String get auth_validation_missing_lastname => 'Bitte den Nachnamen angeben';

  @override
  String get auth_validation_long_lastname =>
      'Der angegebene Nachname ist zu lang';

  @override
  String get auth_validation_missing_birthdate =>
      'Bitte das Geburtsdatum angeben';

  @override
  String get auth_validation_invalid_birthdate =>
      'Sie müssen 18 oder älter sein';

  @override
  String get auth_validation_invalid_date =>
      'Das eingegebene Datum ist ungültig';

  @override
  String get auth_validation_invalid_postcode => 'Die PLZ ist ungültig';

  @override
  String get auth_validation_missing_code =>
      'Geben Sie bitte ihren Registrierungscode an';

  @override
  String get auth_validation_missing_gender =>
      'Geben Sie bitte ihr Geschlecht an';

  @override
  String get auth_validation_missing_additional_info =>
      'Bitte einen Empfehlungsgrund angeben';

  @override
  String get auth_validation_additional_info_exceed_limit =>
      'Es sind maximal 500 Zeichen erlaubt';

  @override
  String get menuitems_profile => 'Profil';

  @override
  String get menuitems_dashboard => 'Dashboard';

  @override
  String get menuitems_recommendations => 'Empfehlungen';

  @override
  String get menuitems_promoters => 'Promoter';

  @override
  String get landingpage_overview_title => 'Landing Pages Übersicht';

  @override
  String get menuitems_landingpage => 'Landingpage';

  @override
  String get menuitems_company_requests => 'Anfragen';

  @override
  String get menuitems_recommendation_manager => 'Empfehlungsmanager';

  @override
  String get menuitems_registration_codes => 'Codes';

  @override
  String get menuitems_user_feedback => 'Nutzer Feedback';

  @override
  String get menuitems_legals => 'Rechtliches';

  @override
  String get landingpage_overview_error_view_title =>
      'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String get landingpage_overview_empty_page_title =>
      'Keine Landingpage gefunden';

  @override
  String get landingpage_overview_empty_page_subtitle =>
      'Sie scheinen noch keine Landingpage zu haben. Erstellen Sie jetzt ihre Landingpage.';

  @override
  String get landingpage_overview_empty_page_button_title =>
      'Landingpage registrieren';

  @override
  String get landingpage_overview_pending_tooltip =>
      'Die Seite wird gerade erstellt. Bitte warten...';

  @override
  String get landingpage_delete_alert_title =>
      'Soll die ausgewählte Landingpage wirklich gelöscht werden?';

  @override
  String get landingpage_delete_alert_msg =>
      'Das Löschen der Landingpage kann nicht rückgängig gemacht werden.';

  @override
  String get landingpage_delete_alert_msg_promoter_warning =>
      'Folgende Promoter haben keine aktiven Landingpages mehr zugewiesen, wenn Sie diese Seite löschen:\n';

  @override
  String get landingpage_delete_alert_msg_promoter_warning_continue =>
      '\nMöchten Sie trotzdem fortfahren? Die Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get landingpage_success_delete_snackbar_message =>
      'Landinpage erfolgreich gelöscht!';

  @override
  String get landingpage_snackbar_success =>
      'Die Landingpage wurde erfolgreich erstellt!';

  @override
  String get landingpage_snackbar_success_changed =>
      'Die Landingpage wurde erfolgreich geändert!';

  @override
  String get landingpage_snackbar_success_duplicated =>
      'Die Landingpage wurde erfolgreich dupliziert!';

  @override
  String get landingpage_snackbar_success_toggled_enabled =>
      'Die Landingpage wurde erfolgreich aktiviert!';

  @override
  String get landingpage_snackbar_success_toggled_disabled =>
      'Die Landingpage wurde erfolgreich deaktiviert!';

  @override
  String get landingpage_snackbar_failure_toggled =>
      'Beim umstellen der Landingpage ist ein Fehler aufgetreten';

  @override
  String get landingpage_overview_context_menu_disable => 'deaktivieren';

  @override
  String get landingpage_overview_context_menu_enable => 'aktivieren';

  @override
  String get landingpage_overview_max_count_msg =>
      'Maximale Anzahl an Landingpages wurde erreicht';

  @override
  String get landingpage_create_buttontitle => 'Landingpage erstellen';

  @override
  String get landingpage_validate_LandingPageName => 'Bitte Namen eingeben!';

  @override
  String get landingpage_validate_LandingPageText => 'Bitte Text eingeben!';

  @override
  String get landingpage_validate_impressum => 'Bitte Impressum angeben';

  @override
  String get landingpage_validate_privacy_policy =>
      'Bitte Datenschutzerklärung angeben';

  @override
  String get landingpage_validate_initial_information =>
      'Bitte Erstinformation angeben';

  @override
  String landingpage_creation_progress_indicator_text(
      int currentStep, int elementsTotal) {
    return 'Schritt $currentStep von $elementsTotal';
  }

  @override
  String get landingpage_creation_impressum_placeholder => 'Impressum';

  @override
  String get landingpage_creation_privacy_policy_placeholder =>
      'Datenschutzerklärung';

  @override
  String get landingpage_creation_initial_information_placeholder =>
      'Erstinformation (optional)';

  @override
  String get landingpage_creation_terms_and_conditions_placeholder =>
      'Allgemeine Geschäftsbedingungen (optional)';

  @override
  String get landingpage_creation_scripts_description =>
      'Im Folgenden können Javascript <script> Tags eingetragen werden.\nDas dient beispielsweise dazu, Cookie Banner oder Tracking Tools in die Landingpage einzubinden.';

  @override
  String get landingpage_creation_scripts_placeholder =>
      'Script Tags (optional)';

  @override
  String get landingpage_creation_back_button_text => 'Zurück';

  @override
  String get landingpage_creation_edit_button_text => 'Landingpage anpassen';

  @override
  String get landingpage_create_txt => 'Landingpage erstellen';

  @override
  String get landingpage_creation_continue => 'Weiter';

  @override
  String get landingpage_create_promotion_template_description =>
      'Nachfolgend kannst du eine Vorlage erstellen, die deine Promoter nutzen werden um Empfehlungen per Whatsapp zu versenden.\nDu kannst verschiedene Platzhalter nutzen welche du über das Platzhalter Menü auswählen kannst.';

  @override
  String get landingpage_create_promotion_template_placeholder =>
      'Vorlage für Promoter (optional)';

  @override
  String get landingpage_create_promotion_template_default_text =>
      'Das ist eine Vorlage für Empfehlungen.';

  @override
  String get emoji_search_placeholder => 'Suche Emoji';

  @override
  String get open_emoji_picker_tooltip => 'Emoji Picker öffnen';

  @override
  String get landingpage_create_promotion_placeholder_menu =>
      'Platzhalter auswählen';

  @override
  String
      get landingpage_create_promotion_placeholder_service_provider_first_name =>
          'Vorname des Dienstleisters';

  @override
  String
      get landingpage_create_promotion_placeholder_service_provider_last_name =>
          'Nachname des Dienstleisters';

  @override
  String get landingpage_create_promotion_placeholder_service_provider_name =>
      'Name des Dienstleisters';

  @override
  String get landingpage_create_promotion_placeholder_promoter_first_name =>
      'Vorname des Promoters';

  @override
  String get landingpage_create_promotion_placeholder_promoter_last_name =>
      'Nachname des Promoters';

  @override
  String get landingpage_create_promotion_placeholder_promoter_name =>
      'Name des Promoters';

  @override
  String get landingpage_create_promotion_placeholder_receiver_name =>
      'Name des Absenders';

  @override
  String get landingpage_overview_context_menu_delete => 'Löschen';

  @override
  String get landingpage_overview_context_menu_duplicate => 'Duplizieren';

  @override
  String get placeholder_title => 'Titel';

  @override
  String get placeholder_description => 'Beschreibung';

  @override
  String get landingpage_creator_placeholder_contact_email =>
      'Kontakt E-Mail Adresse';

  @override
  String get error_msg_pleace_upload_picture => 'Bitte ein Bild hochladen';

  @override
  String get menuitems_activities => 'Aktivitäten';

  @override
  String get auth_failure_email_already_in_use =>
      'Die E-Mail Adresse ist bereits vergeben.';

  @override
  String get auth_failure_invalid_email =>
      'Die eingegebene E-Mail Adresse ist ungültig.';

  @override
  String get auth_failure_weak_password =>
      'Das angegebene Passwort ist zu schwach. Bitte nutze mindestens 6 Zeichen.';

  @override
  String get auth_failure_user_disabled =>
      'Der angegebene Nutzer existiert nicht mehr. Wenden Sie sich bitte an den Support.';

  @override
  String get auth_failure_user_not_found =>
      'Der angegebene Nutzername existiert nicht.';

  @override
  String get auth_failure_wrong_password =>
      'Das angegebene Passwort ist falsch.';

  @override
  String get auth_failure_invalid_credentials =>
      'Deine angegebenen Zugangsdaten existieren nicht.';

  @override
  String get auth_failure_too_many_requests =>
      'Du hast deine Zugangsdaten zu oft falsch eingegeben. Versuche es später noch einmal.';

  @override
  String get auth_failure_user_mismatch =>
      'Deine Anmeldeinformationen gehören nicht zum aktuellen User.';

  @override
  String get auth_failure_invalid_verification_code =>
      'Dein Verifizierungscode ist ungültig.';

  @override
  String get auth_failure_invalid_verification_id =>
      'Die ID zu deinen Anmeldeinformationen ist ungültig.';

  @override
  String get auth_failure_requires_recent_login =>
      'Deine letzte Anmeldung ist zu lange her. Melde dich erneut an.';

  @override
  String get auth_failure_missing_password => 'Du musst dein Password angeben.';

  @override
  String get auth_failure_unknown => 'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get database_failure_permission_denied =>
      'Sie sind nicht berechtigt auf die Daten zuzugreifen.';

  @override
  String get database_failure_not_found =>
      'Die angefragten Daten wurden nicht gefunden.';

  @override
  String get database_failure_already_exists =>
      'Die angegebenen Daten existieren bereits.';

  @override
  String get database_failure_deadline_exceeded =>
      'Der Datenabruf dauert zu lange. Versuche es später nochmal.';

  @override
  String get database_failure_cancelled => 'Die Operation wurde abgebrochen.';

  @override
  String get database_failure_unavailable =>
      'Der Service ist gerade nicht erreichbar.';

  @override
  String get database_failure_unknown =>
      'Ein unbekannter Fehler ist aufgetreten.';

  @override
  String get storage_failure_object_not_found => 'Es wurde kein Bild gefunden.';

  @override
  String get storage_failure_not_authenticated =>
      'Du musst dich anmelden um diesen Service nutzen zu können.';

  @override
  String get storage_failure_not_authorized =>
      'Du bist nicht berechtigt diese Aktion auszuführen.';

  @override
  String get storage_failure_retry_limit_exceeded =>
      'Es scheint ein Problem aufgetreten zu sein. Die Aktion dauert länger als gewöhnlich. Bitte versuche es später erneut.';

  @override
  String get storage_failure_unknown =>
      'Ein unbekannter Fehler ist aufgetreten. Bitte versuche es später erneut.';

  @override
  String get password_forgotten_title => 'Passwort zurücksetzen';

  @override
  String get password_forgotten_description =>
      'Bitte geben Sie ihre E-Mail Adresse ein und bestätigen Sie. Ihnen wird anschließend ein Link an die angegebene E-Mail Adresse gesendet.\nÜber diesen Link können Sie ihr Passwort zurücksetzen.';

  @override
  String get password_forgotten_success_dialog_title =>
      'Passwort erfolgreich zurückgesetzt';

  @override
  String get password_forgotten_success_dialog_description =>
      'Eine E-Mail wurde an die angegebene E-Mail Adresse gesendet. Über den Link in der Mail können Sie ihr neues Passwort festlegen.';

  @override
  String get password_forgotten_success_dialog_ok_button_title =>
      'Zurück zum Login';

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
  String get profile_page_email_section_description =>
      'Geben Sie jetzt ihre neue E-Mail Adresse an und bestätigen Sie. An die neue E-Mail Adresse wird anschließend ein Bestätigungslink gesendet. Durch diesen Link können Sie Ihre neue E-Mail Adresse verifizieren und sich erneut anmelden.';

  @override
  String get profile_page_email_section_change_email_button_title =>
      'E-Mail Adresse ändern';

  @override
  String get profile_page_email_section_change_email_password_description =>
      'Geben Sie bitte ihr Passwort ein wenn Sie ihre E-Mail Adresse ändern möchten.';

  @override
  String
      get profile_page_email_section_change_email_password_continue_button_title =>
          'Weiter';

  @override
  String get profile_page_email_section_resend_verify_email_button_title =>
      'Link zur Email-Verifikation erneut senden';

  @override
  String get profile_page_email_section_title => 'E-Mail Einstellungen';

  @override
  String get profile_page_email_section_verification_badge_verified =>
      'Verifiziert';

  @override
  String get profile_page_email_section_verification_badge_unverified =>
      'Unverifiziert';

  @override
  String get profile_page_image_section_validation_exceededFileSize =>
      'Sie haben die zulässige Maximalgröße von 5 MB überschritten';

  @override
  String get profile_page_image_section_validation_not_valid =>
      'Das ist kein gültiges Bildformat';

  @override
  String get profile_page_image_section_only_one_allowed =>
      'Du kannst nur ein Bild gleichzeitig hochladen';

  @override
  String get profile_page_image_section_upload_not_found =>
      'Das Bild zum Hochladen wurde nicht gefunden';

  @override
  String
      get profile_page_image_section_large_image_view_close_button_tooltip_title =>
          'Schließen';

  @override
  String get profile_page_password_update_section_title => 'Passwort ändern';

  @override
  String get profile_page_password_update_section_new_password_description =>
      'Geben Sie bitte ihr neues Passwort an und bestätigen Sie es. Danach werden Sie ausgeloggt und Sie können sich mit dem neuen Passwort anmelden.';

  @override
  String
      get profile_page_password_update_section_new_password_textfield_placeholder =>
          'Neues Passwort';

  @override
  String
      get profile_page_password_update_section_new_password_repeat_textfield_placeholder =>
          'Neues Passwort wiederholen';

  @override
  String
      get profile_page_password_update_section_new_password_confirm_button_text =>
          'Passwort ändern';

  @override
  String get profile_page_password_update_section_reauth_description =>
      'Geben Sie bitte ihr aktuelles Password ein damit Sie ein neues Password erstellen können.';

  @override
  String
      get profile_page_password_update_section_reauth_password_textfield_placeholder =>
          'Passwort';

  @override
  String
      get profile_page_password_update_section_reauth_continue_button_title =>
          'Weiter';

  @override
  String get profile_page_contact_section_title => 'Kontaktinformationen';

  @override
  String get profile_page_contact_section_form_firstname => 'Vorname';

  @override
  String get profile_page_contact_section_form_lastname => 'Nachname';

  @override
  String get profile_page_contact_section_form_address =>
      'Straße und Hausnummer';

  @override
  String get profile_page_contact_section_form_postcode => 'PLZ';

  @override
  String get profile_page_contact_section_form_place => 'Ort';

  @override
  String get profile_page_contact_section_form_save_button_title =>
      'Änderungen speichern';

  @override
  String get profile_page_snackbar_image_changed_message =>
      'Sie haben das Profilbild erfolgreich angepasst.';

  @override
  String get profile_page_snackbar_contact_information_changes =>
      'Die Änderung deiner Kontaktinformationen war erfolgreich.';

  @override
  String get profile_page_snackbar_email_verification =>
      'Es wurde ein Link zur E-Mail Verifikation an dich versendet.';

  @override
  String get profile_page_snackbar_company_registered =>
      'Die Anfrage zur Unternehmensregistrierung wurde erfolgreich versendet.';

  @override
  String get profile_page_logout_button_title => 'Abmelden';

  @override
  String get profile_page_request_failure_message =>
      'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String get profile_page_promoters_section_title => 'Promoter';

  @override
  String get gender_picker_choose => 'Wählen Sie ihr Geschlecht';

  @override
  String get gender_picker_not_choosen => 'Nicht ausgewählt';

  @override
  String get gender_picker_male => 'Männlich';

  @override
  String get gender_picker_female => 'Weiblich';

  @override
  String get register_promoter_email_already_in_use =>
      'Die E-Mail Adresse existiert bereits bei einem anderen Nutzer.';

  @override
  String get register_promoter_title => 'Promoter registrieren';

  @override
  String get register_promoter_first_name => 'Vorname';

  @override
  String get register_promoter_last_name => 'Nachname';

  @override
  String get register_promoter_email => 'E-Mail Adresse';

  @override
  String get register_promoter_additional_info => 'Grund der Empfehlung';

  @override
  String get register_promoter_register_button => 'Registrieren';

  @override
  String get register_promoter_snackbar_success =>
      'Der neue Promoter wurde erfolgreich registriert!';

  @override
  String get register_promoter_no_landingpage_title =>
      'Du hast noch keine Landingpage erstellt';

  @override
  String get register_promoter_no_landingpage_subtitle =>
      'Um einen neuen Promoter erstellen zu können ist es nötig, eine aktive Landingpage zu haben.';

  @override
  String get register_promoter_missing_landingpage_error_message =>
      'Dem Promoter wurde noch keine Landingpage zugewiesen';

  @override
  String get register_promoter_missing_company_error_message =>
      'Du kannst keinen Promoter registrieren, da du keinem Unternehmen zugehörig bist';

  @override
  String get register_promoter_landingpage_assign_title =>
      'Landingpages Zuweisung';

  @override
  String get promoter_register_tab_title => 'Promoter registrieren';

  @override
  String get my_promoters_tab_title => 'Meine Promoter';

  @override
  String get promoter_page_edit_promoter_snackbar_title =>
      'Promoter erfolgreich angepasst!';

  @override
  String get promoter_overview_title => 'Meine Promoter';

  @override
  String get promoter_overview_search_placeholder => 'Suche...';

  @override
  String get promoter_overview_filter_show_all => 'Alle anzeigen';

  @override
  String get promoter_overview_filter_show_registered =>
      'Registrierte anzeigen';

  @override
  String get promoter_overview_filter_show_unregistered =>
      'Unregistrierte anzeigen';

  @override
  String get promoter_overview_filter_sortby_choose => 'Sortieren nach';

  @override
  String get promoter_overview_filter_sortby_date => 'Erstellungsdatum';

  @override
  String get promoter_overview_filter_sortby_firstname => 'Vorname';

  @override
  String get promoter_overview_filter_sortby_lastname => 'Nachname';

  @override
  String get promoter_overview_filter_sortby_email => 'E-Mail Adresse';

  @override
  String get promoter_overview_filter_sortorder_asc => 'Aufsteigend';

  @override
  String get promoter_overview_filter_sortorder_desc => 'Absteigend';

  @override
  String get promoter_overview_no_search_results_title =>
      'Keine Suchergebnisse';

  @override
  String get promoter_overview_no_search_results_subtitle =>
      'Sie scheinen noch keine Promoter mit dem gesuchten Namen registriert zu haben.\nÄndern Sie Ihren Suchbegriff um nach anderen Promotern zu suchen.';

  @override
  String get promoter_overview_registration_badge_registered => 'Registriert';

  @override
  String get promoter_overview_registration_badge_unregistered =>
      'Nicht registriert';

  @override
  String get promoter_overview_empty_page_title => 'Keine Promoter gefunden';

  @override
  String get promoter_overview_empty_page_subtitle =>
      'Sie scheinen noch keine Promoter registriert zu haben. Registrieren Sie jetzt ihre Promoter um die ersten Neukunden zu gewinnen.';

  @override
  String get promoter_overview_empty_page_button_title =>
      'Promoter registrieren';

  @override
  String get promoter_overview_error_view_title =>
      'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String promoter_overview_expiration_date(String date) {
    return 'Läuft am $date ab';
  }

  @override
  String promoter_overview_creation_date(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get promoter_overview_edit_promoter_tooltip => 'Bearbeiten';

  @override
  String get promoter_overview_delete_promoter_tooltip => 'Löschen';

  @override
  String get promoter_overview_delete_promoter_alert_title =>
      'Soll der ausgewählte Promoter wirklich gelöscht werden?';

  @override
  String get promoter_overview_delete_promoter_alert_description =>
      'Das Löschen des Promoters kann nicht rückgängig gemacht werden.';

  @override
  String get promoter_overview_delete_promoter_alert_delete_button => 'Löschen';

  @override
  String get promoter_overview_delete_promoter_alert_cancel_button =>
      'Abbrechen';

  @override
  String get promoter_overview_delete_promoter_success_snackbar =>
      'Promoter erfolgreich gelöscht!';

  @override
  String get promoter_overview_delete_promoter_failure_snackbar =>
      'Promoter löschen fehlgeschlagen!';

  @override
  String get delete_account_title => 'Account löschen';

  @override
  String get delete_account_subtitle =>
      'Mit der Löschung Ihres Accounts verbleiben Ihre Daten noch 30 Tage bei uns. In dieser Zeit können Sie sich noch beim Support melden um die Löschung rückgängig zu machen. Danach werden Ihre Daten unwiderruflich gelöscht sein.\n\nGeben Sie bitte ihr Passwort ein um den Account zu löschen.';

  @override
  String get delete_account_password_placeholder => 'Passwort';

  @override
  String get delete_account_button_title => 'Account löschen';

  @override
  String get delete_account_confirmation_alert_title =>
      'Account wirklich löschen?';

  @override
  String get delete_account_confirmation_alert_message =>
      'Sind Sie sicher dass Sie ihren Account löschen möchten?';

  @override
  String get delete_account_confirmation_alert_ok_button_title =>
      'Account löschen';

  @override
  String get delete_account_confirmation_alert_cancel_button_title =>
      'Abbrechen';

  @override
  String get recommendation_page_leadTextField_title_prefix => 'Text für';

  @override
  String get recommendation_page_leadTextField_send_button =>
      'Senden per Whatsapp';

  @override
  String get recommendation_page_send_whatsapp_error =>
      'WhatsApp ist nicht installiert oder kann nicht geöffnet werden.';

  @override
  String get recommendation_page_max_item_Message =>
      'Es dürfen maximal 6 Items hinzugefügt werden.';

  @override
  String get recommendations_choose_reason_placeholder => 'Wähle einen Grund';

  @override
  String get recommendations_choose_reason_not_chosen => 'Nicht ausgewählt';

  @override
  String get recommendations_title => 'Empfehlungen generieren';

  @override
  String get recommendations_form_promoter_placeholder => 'Promoter';

  @override
  String get recommendations_form_service_provider_placeholder =>
      'Dienstleister';

  @override
  String get recommendations_form_recommendation_name_placeholder =>
      'Empfehlungsname';

  @override
  String get recommendations_form_generate_recommendation_button_title =>
      'Empfehlungen generieren';

  @override
  String get recommendations_error_view_title =>
      'Beim Abrufen der Daten ist ein Fehler aufgetreten';

  @override
  String get recommendations_validation_missing_lead_name =>
      'Geben Sie bitte einen Namen an';

  @override
  String get recommendations_validation_missing_promoter_name =>
      'Geben Sie bitte einen Namen an';

  @override
  String get recommendations_validation_missing_reason =>
      'Bitte einen Grund angeben';

  @override
  String get profile_company_contact_section_title =>
      'Unternehmensinformationen';

  @override
  String get profile_company_contact_section_name => 'Unternehmensbezeichnung';

  @override
  String get profile_company_contact_section_industry => 'Branche';

  @override
  String get profile_company_contact_section_website => 'Webseite';

  @override
  String get profile_company_contact_section_address => 'Straße und Hausnummer';

  @override
  String get profile_company_contact_section_postcode => 'PLZ';

  @override
  String get profile_company_contact_section_place => 'Ort';

  @override
  String get profile_company_contact_section_phone => 'Telefonnummer';

  @override
  String get profile_company_contact_section_avv_checkbox_text =>
      'Ich stimme der';

  @override
  String get profile_company_contact_section_avv_checkbox_text_part2 => 'zu.';

  @override
  String get profile_company_contact_section_avv_link => 'AVV';

  @override
  String get profile_company_contact_section_avv_already_approved =>
      'bereits zugestimmt.';

  @override
  String get profile_company_contact_section_avv_generating =>
      'AVV wird generiert...';

  @override
  String get profile_company_validator_missing_name =>
      'Bitte den Unternehmensnamen angeben';

  @override
  String get profile_company_validator_missing_industry =>
      'Bitte die Branche angeben';

  @override
  String get profile_company_validator_invalid_phone =>
      'Die angegebene Telefonnummer ist ungültig';

  @override
  String get profile_company_validator_missing_address =>
      'Bitte eine Adresse angeben';

  @override
  String get profile_company_validator_missing_postCode =>
      'Bitte eine PLZ angeben';

  @override
  String get profile_company_validator_invalid_postCode =>
      'Die PLZ ist ungültig';

  @override
  String get profile_company_validator_missing_place =>
      'Bitte einen Ort angeben';

  @override
  String get profile_company_validator_missing_phone =>
      'Bitte Telefonnummer angeben';

  @override
  String get profile_company_contact_section_success_snackbar_message =>
      'Unternehmensinformationen erfolgreich geändert';

  @override
  String get company_requests_overview_title =>
      'Anfragen für Unternehmensregistrierungen';

  @override
  String get admin_company_request_detail_title => 'Anfrage';

  @override
  String get admin_company_request_detail_name => 'Unternehmensbezeichnung:';

  @override
  String get admin_company_request_detail_industry => 'Branche:';

  @override
  String get admin_company_request_detail_address => 'Adresse:';

  @override
  String get admin_company_request_detail_postcode => 'Postleitzahl:';

  @override
  String get admin_company_request_detail_place => 'Ort:';

  @override
  String get admin_company_request_detail_phone => 'Telefonnummer:';

  @override
  String get admin_company_request_detail_website => 'Webseite:';

  @override
  String get admin_company_request_detail_user_title => 'Nutzer';

  @override
  String get admin_company_request_detail_user_name => 'Name:';

  @override
  String get admin_company_request_detail_user_email => 'E-Mail Adresse:';

  @override
  String get admin_company_request_detail_decline_button_title =>
      'Anfrage ablehnen';

  @override
  String get admin_company_request_detail_accept_button_title =>
      'Anfrage annehmen';

  @override
  String get admin_company_request_overview_from_user => 'von: ';

  @override
  String get admin_company_request_overview_empty_title =>
      'Keine Anfragen vorhanden';

  @override
  String get admin_company_request_overview_empty_body =>
      'Zurzeit scheint es keine Registrierungsanfragen von Unternehmen zu geben.';

  @override
  String get admin_company_request_overview_title =>
      'Anfragen für Unternehmensregistrierungen';

  @override
  String get admin_company_request_overview_error =>
      'Es ist ein Fehler aufgetreten';

  @override
  String get admin_registration_code_creator_success_snackbar =>
      'Code erfolgreich versendet!';

  @override
  String get admin_registration_code_creator_title =>
      'Registrierungscode erstellen';

  @override
  String get admin_registration_code_creator_description =>
      'Hier kannst du einen Registrierungscode für einen Nutzer erstellen.\nDer Code wird an die angegebene E-Mail Adresse gesendet. Der Nutzer der sich mit diesem Code registriert hat ist keinem Unternehmen zugewiesen.';

  @override
  String get admin_registration_code_creator_email_placeholder =>
      'E-Mail Adresse';

  @override
  String get admin_registration_code_creator_firstname_placeholder => 'Vorname';

  @override
  String get admin_registration_code_creator_send_code_button =>
      'Code versenden';

  @override
  String get company_registration_form_title => 'Unternehmen registrieren';

  @override
  String get company_registration_form_name_textfield_placeholder =>
      'Unternehmensbezeichnung';

  @override
  String get company_registration_form_industry_textfield_placeholder =>
      'Branche';

  @override
  String get company_registration_form_website_textfield_placeholder =>
      'Webseite (optional)';

  @override
  String get company_registration_form_address_textfield_placeholder =>
      'Straße und Hausnummer';

  @override
  String get company_registration_form_postcode_textfield_placeholder => 'PLZ';

  @override
  String get company_registration_form_place_textfield_placeholder => 'Ort';

  @override
  String get company_registration_form_phone_textfield_placeholder =>
      'Telefonnummer';

  @override
  String get company_registration_form_register_button_title =>
      'Jetzt registrieren';

  @override
  String get profile_register_company_section_title =>
      'Unternehmensregistrierung';

  @override
  String get profile_register_company_section_subtitle_in_progress =>
      'Deine Anfrage ist in Bearbeitung.\nDie Bearbeitungsdauer liegt bei durchschnittlich 7 Tagen.';

  @override
  String get profile_register_company_section_subtitle_requested_at =>
      'Eingereicht am ';

  @override
  String get profile_register_company_section_subtitle =>
      'Registriere jetzt dein Unternehmen, um weitere Vorteile der App nutzen zu können.';

  @override
  String get profile_register_company_section_button_title =>
      'Zur Registrierung';

  @override
  String get profile_image_upload_tooltip => 'Bild hochladen';

  @override
  String get landingpage_overview_edit_tooltip => 'Landingpage bearbeiten';

  @override
  String get landingpage_overview_show_tooltip => 'Landingpage anzeigen';

  @override
  String get profile_edit_email_tooltip => 'E-Mail Adresse ändern';

  @override
  String get theme_switch_lightmode_tooltip => 'Heller Modus';

  @override
  String get theme_switch_darkmode_tooltip => 'Dunkler Modus';

  @override
  String get promoter_overview_reset_search_tooltip => 'Suche zurücksetzen';

  @override
  String get promoter_overview_filter_tooltip => 'Promoter filtern';

  @override
  String get promoter_overview_view_switch_grid_tooltip => 'Gridansicht';

  @override
  String get promoter_overview_view_switch_table_tooltip => 'Listenansicht';

  @override
  String get recommendations_form_add_button_tooltip => 'Empfehlung hinzufügen';

  @override
  String get landingpage_pagebuilder_container_request_error =>
      'Beim Abruf der Daten ist ein Fehler aufgetreten';

  @override
  String get landingpage_pagebuilder_container_permission_error_title =>
      'Du bist nicht berechtigt diese Seite aufzurufen';

  @override
  String get landingpage_pagebuilder_container_permission_error_message =>
      'Du hast nicht die entsprechende Berechtigung um diese Seite zu aufzurufen. Melde dich bitte mit einem Account an der dazu berechtigt ist.';

  @override
  String get landingpage_pagebuilder_appbar_save_button_title => 'Speichern';

  @override
  String get landingpage_pagebuilder_save_error_alert_title =>
      'Speichern fehlgeschlagen';

  @override
  String get landingpage_pagebuilder_save_error_alert_message =>
      'Beim Speichern deiner neuen Landingpage Inhalte ist ein Fehler aufgetreten. Bitte versuche es später noch einmal.';

  @override
  String get landingpage_pagebuilder_save_error_alert_button => 'OK';

  @override
  String get landingpage_pagebuilder_save_success_snackbar =>
      'Die Änderungen wurden erfolgreich gespeichert.';

  @override
  String get landingpage_pagebuilder_image_upload_exceeds_file_size_error =>
      'Das Bild überschreitet die 5 MB Grenze und kann nicht hochgeladen werden!';

  @override
  String get landingpage_pagebuilder_unload_alert_message =>
      'Willst du die Seite wirklich verlassen? Nicht gespeicherte Änderungen gehen verloren.';

  @override
  String get landingpage_pagebuilder_config_menu_content_tab => 'Inhalt';

  @override
  String get landingpage_pagebuilder_config_menu_design_tab => 'Design';

  @override
  String get landingpage_pagebuilder_config_menu_container_type => 'Container';

  @override
  String get landingpage_pagebuilder_config_menu_column_type => 'Spalte';

  @override
  String get landingpage_pagebuilder_config_menu_row_type => 'Reihe';

  @override
  String get landingpage_pagebuilder_config_menu_text_type => 'Text';

  @override
  String get landingpage_pagebuilder_config_menu_image_type => 'Bild';

  @override
  String get landingpage_pagebuilder_config_menu_icon_type => 'Icon';

  @override
  String get landingpage_pagebuilder_config_menu_button_type => 'Button';

  @override
  String get landingpage_pagebuilder_config_menu_contact_form_type =>
      'Kontaktformular';

  @override
  String get landingpage_pagebuilder_config_menu_footer_type => 'Footer';

  @override
  String get landingpage_pagebuilder_config_menu_video_player_type =>
      'Video Player';

  @override
  String get landingpage_pagebuilder_config_menu_anchor_button_type =>
      'Anker Button';

  @override
  String get landingpage_pagebuilder_config_menu_unknown_type => 'Unbekannt';

  @override
  String get landingpage_pagebuilder_text_config_text_title =>
      'Text Konfiguration';

  @override
  String get landingpage_pagebuilder_text_config_alignment => 'Ausrichtung';

  @override
  String get landingpage_pagebuilder_text_config_alignment_left =>
      'linksbündig';

  @override
  String get landingpage_pagebuilder_text_config_alignment_center =>
      'zentriert';

  @override
  String get landingpage_pagebuilder_text_config_alignment_right =>
      'rechtsbündig';

  @override
  String get landingpage_pagebuilder_text_config_alignment_justify =>
      'Blocksatz';

  @override
  String get landingpage_pagebuilder_text_config_lineheight => 'Zeilenhöhe';

  @override
  String get landingpage_pagebuilder_text_config_letterspacing =>
      'Zeichenabstand';

  @override
  String get landingpage_pagebuilder_text_config_color => 'Schriftfarbe';

  @override
  String get landingpage_pagebuilder_text_config_font_family => 'Schriftart';

  @override
  String get landingpage_pagebuilder_text_config_shadow => 'Textschatten';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_title =>
      'Schatten konfigurieren';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_spread_radius =>
      'Spread Radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_blur_radius =>
      'Blur Radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_x_offset =>
      'X Offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_y_offset =>
      'Y Offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_apply =>
      'Übernehmen';

  @override
  String get landingpage_pagebuilder_text_config_fontsize => 'Schriftgröße';

  @override
  String get landingpage_pagebuilder_color_picker_title => 'Farbe auswählen';

  @override
  String get landingpage_pagebuilder_color_picker_hex_textfield => 'Hex Code';

  @override
  String get landingpage_pagebuilder_color_picker_ok_button => 'OK';

  @override
  String get landingpage_pagebuilder_text_config_text_placeholder =>
      'Hier Text eingeben...';

  @override
  String get landingpage_pagebuilder_text_config_content_title => 'Text Inhalt';

  @override
  String get landingpage_pagebuilder_layout_spacing_top => 'Oben';

  @override
  String get landingpage_pagebuilder_layout_spacing_bottom => 'Unten';

  @override
  String get landingpage_pagebuilder_layout_spacing_left => 'Links';

  @override
  String get landingpage_pagebuilder_layout_spacing_right => 'Rechts';

  @override
  String get landingpage_pagebuilder_layout_menu_title => 'Layout';

  @override
  String get landingpage_pagebuilder_layout_menu_padding => 'Innenabstand';

  @override
  String get landingpage_pagebuilder_layout_menu_margin => 'Außenabstand';

  @override
  String get landingpage_pagebuilder_layout_menu_alignment => 'Ausrichtung';

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_switch =>
      'Promoter Bild anzeigen';

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_title =>
      'Hintergrundbild';

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_title_promoter =>
      'Gib noch ein Platzhalter Bild an, falls das Promoter Bild nicht existiert';

  @override
  String get landingpage_pagebuilder_layout_menu_background_contentmode =>
      'Anzeigemodus';

  @override
  String get landingpage_pagebuilder_layout_menu_background_overlay =>
      'Bild Overlay';

  @override
  String get landingpage_pagebuilder_layout_menu_background => 'Hintergrund';

  @override
  String get landingpage_pagebuilder_layout_menu_background_color =>
      'Hintergrundfarbe';

  @override
  String get pagebuilder_layout_menu_alignment_top_left => 'Oben links';

  @override
  String get pagebuilder_layout_menu_alignment_top_center => 'Oben zentriert';

  @override
  String get pagebuilder_layout_menu_alignment_top_right => 'Oben rechts';

  @override
  String get pagebuilder_layout_menu_alignment_center_left => 'Mitte links';

  @override
  String get pagebuilder_layout_menu_alignment_center => 'Mitte';

  @override
  String get pagebuilder_layout_menu_alignment_center_right => 'Mitte rechts';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_left => 'Unten links';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_center =>
      'Unten zentriert';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_right => 'Unten rechts';

  @override
  String get pagebuilder_layout_menu_size_control_size => 'Größe';

  @override
  String get pagebuilder_layout_menu_size_control_width => 'Breite';

  @override
  String get pagebuilder_layout_menu_size_control_height => 'Höhe';

  @override
  String get pagebuilder_image_config_title => 'Bild Konfiguration';

  @override
  String get pagebuilder_image_config_content_mode => 'Bildmodus';

  @override
  String get pagebuilder_image_config_image_overlay => 'Bild Overlay';

  @override
  String get pagebuilder_image_config_border_radius => 'Radius';

  @override
  String get pagebuilder_image_config_image_content => 'Bild Inhalt';

  @override
  String get landingpage_pagebuilder_container_config_container_title =>
      'Container Konfiguration';

  @override
  String get landingpage_pagebuilder_container_config_container_shadow =>
      'Schatten';

  @override
  String get landingpage_pagebuilder_row_config_row_title =>
      'Reihe Konfiguration';

  @override
  String get landingpage_pagebuilder_row_config_row_equal_heights =>
      'Gleiche Höhen';

  @override
  String get landingpage_pagebuilder_row_config_row_main_axis_alignment =>
      'Ausrichtung X-Achse';

  @override
  String get landingpage_pagebuilder_row_config_row_cross_axis_alignment =>
      'Ausrichtung Y-Achse';

  @override
  String get landingpage_pagebuilder_column_config_column_title =>
      'Spalte Konfiguration';

  @override
  String get landingpage_pagebuilder_icon_content => 'Icon Inhalt';

  @override
  String get landingpage_pagebuilder_icon_content_change_icon => 'Icon ändern';

  @override
  String get landingpage_pagebuilder_icon_config_icon_title =>
      'Icon Konfiguration';

  @override
  String get landingpage_pagebuilder_icon_config_color => 'Farbe';

  @override
  String get landingpage_pagebuilder_icon_config_size => 'Größe';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_title =>
      'Wähle ein Icon';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_close =>
      'Schließen';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_search => 'Suche';

  @override
  String
      get landingpage_pagebuilder_icon_config_icon_picker_search_no_results =>
          'Keine Ergebnisse für:';

  @override
  String get landingpage_pagebuilder_contactform_content_email =>
      'Kontaktformular E-Mail';

  @override
  String get landingpage_pagebuilder_contactform_content_email_subtitle =>
      'Gib hier bitte die Empfänger E-Mail Adresse an, an welche die Kontaktanfrage versendet wird.';

  @override
  String get landingpage_pagebuilder_contactform_content_email_placeholder =>
      'E-Mail Adresse';

  @override
  String get pagebuilder_button_config_button_width => 'Breite';

  @override
  String get pagebuilder_button_config_button_height => 'Höhe';

  @override
  String get pagebuilder_button_config_button_border_radius => 'Radius';

  @override
  String get pagebuilder_button_config_button_background_color =>
      'Hintergrundfarbe';

  @override
  String get pagebuilder_button_config_button_text_configuration =>
      'Button Text Konfiguration';

  @override
  String get pagebuilder_contact_form_config_name_textfield_title =>
      'Name Textfeld';

  @override
  String get pagebuilder_contact_form_config_email_textfield_title =>
      'E-Mail Textfeld';

  @override
  String get pagebuilder_contact_form_config_phone_textfield_title =>
      'Telefon Textfeld';

  @override
  String get pagebuilder_contact_form_config_message_textfield_title =>
      'Nachricht Textfeld';

  @override
  String get pagebuilder_contact_form_config_button_title =>
      'Button Konfiguration';

  @override
  String get pagebuilder_textfield_config_textfield_width => 'Breite';

  @override
  String get pagebuilder_textfield_config_textfield_min_lines =>
      'Zeilenanzahl Minimum';

  @override
  String get pagebuilder_textfield_config_textfield_max_lines =>
      'Zeilenanzahl Maximum';

  @override
  String get pagebuilder_textfield_config_textfield_required => 'Pflichtfeld';

  @override
  String get pagebuilder_textfield_config_textfield_background_color =>
      'Hintergrundfarbe';

  @override
  String get pagebuilder_textfield_config_textfield_border_color =>
      'Rahmenfarbe';

  @override
  String get pagebuilder_textfield_config_textfield_placeholder =>
      'Platzhalter';

  @override
  String get pagebuilder_textfield_config_textfield_text_configuration =>
      'Textfeld Text Konfiguration';

  @override
  String
      get pagebuilder_textfield_config_textfield_placeholder_text_configuration =>
          'Textfeld Platzhalter Konfiguration';

  @override
  String get landingpage_pagebuilder_config_menu_section_type => 'Section';

  @override
  String get landingpage_pagebuilder_footer_config_privacy_policy =>
      'Datenschutzerklärung Konfiguration';

  @override
  String get landingpage_pagebuilder_footer_config_impressum =>
      'Impressum Konfiguration';

  @override
  String get landingpage_pagebuilder_footer_config_initial_information =>
      'Erstinformation Konfiguration';

  @override
  String get landingpage_pagebuilder_footer_config_terms_and_conditions =>
      'AGB Konfiguration';

  @override
  String edit_promoter_title(String firstName, String lastName) {
    return '$firstName $lastName bearbeiten';
  }

  @override
  String get edit_promoter_subtitle =>
      'Hier kannst du die Landingpage Zuweisungen anpassen.';

  @override
  String get edit_promoter_save_button_title => 'Änderungen speichern';

  @override
  String get edit_promoter_inactive_landingpage_tooltip =>
      'Diese Landingpage ist inaktiv';

  @override
  String get edit_promoter_inactive_landingpage_tooltip_activate_action =>
      'Landingpage aktivieren';

  @override
  String get promoter_overview_inactive_landingpage_tooltip_warning =>
      'Der Promoter hat keine aktiven Landingpages mehr zugewiesen';

  @override
  String get promoter_overview_inactive_landingpage_tooltip_warning_action =>
      'Landingpage zuweisen';

  @override
  String get landingpage_pagebuilder_video_player_config_title =>
      'Video Player Konfiguration';

  @override
  String get landingpage_pagebuilder_video_player_config_youtube_link =>
      'Youtube Link';

  @override
  String get landingpage_pagebuilder_video_player_config_youtube_link_description =>
      'Gib hier bitte den Youtube Link an, über den dein Video erreichbar ist.';

  @override
  String
      get landingpage_pagebuilder_video_player_config_youtube_link_placeholder =>
          'Youtube Link';

  @override
  String get landingpage_creator_missing_companydata_error =>
      'Unternehmensdaten nicht gefunden!';

  @override
  String get landingpage_creator_default_page_info_text =>
      'Für das Erstellen der Default Landingpage werden die Daten aus deinem Unternehmensprofil verwendet. Diese werden auf der Default Landingpage angezeigt.\nWenn du deine Unternehmensdaten änderst, dann ändern sich auch die Daten auf deiner Default Page.';

  @override
  String get landingpage_creator_ai_loading_subtitle =>
      'Die KI erstellt gerade deine Landing Page...';

  @override
  String get landingpage_creator_ai_loading_subtitle2 =>
      'Das kann bis zu 5 Minuten dauern. Bitte warten...';

  @override
  String get landingpage_creator_ai_form_section_title =>
      'Oder lasse dir die Seite von unserer KI erstellen';

  @override
  String get landingpage_creator_ai_form_title =>
      'Gib ein paar Informationen zu deinem Unternehmen ein und lass die KI eine maßgeschneiderte Landing Page erstellen.';

  @override
  String get landingpage_creator_ai_form_radio_title => 'Art der Landing Page:';

  @override
  String get landingpage_creator_ai_form_radio_business =>
      'Business/Unternehmen';

  @override
  String get landingpage_creator_ai_form_radio_finance => 'Finanzberater';

  @override
  String get landingpage_creator_ai_form_radio_individual => 'Individuell';

  @override
  String get landingpage_creator_ai_form_business_placeholder =>
      'Branche/Unternehmenstyp';

  @override
  String get landingpage_creator_ai_form_finance_placeholder =>
      'Spezialisierung';

  @override
  String get landingpage_creator_ai_form_custom_description_placeholder =>
      'Zusätzliche Informationen (optional)';

  @override
  String get landingpage_creator_ai_form_character_count => 'Zeichen';

  @override
  String get landingpage_creator_ai_form_example =>
      'Beispiel: Unser Finanzbüro liegt zentral in der Innenstadt, familiengeführt seit 1985, spezialisiert auf unabhängige Finanzberatung und Altersvorsorge. Seriosität und Vertrauen stehen im Mittelpunkt – klare Strukturen, ruhige Blau- und Grautöne gewünscht.';

  @override
  String get landingpage_overview_no_default_page_title =>
      'Landingpage einrichten';

  @override
  String get landingpage_overview_no_default_page_subtitle =>
      'Du hast noch keine Landingpage für dein Unternehmen eingerichtet. Hier kannst du zu Beginn eine Default Landingpage erstellen.\nAuf diese Landingpage wird zurückgegriffen, falls der Link zu einer anderen Landingpage abgelaufen ist.\nAuf der Landingpage werden Unternehmensinformationen sowie ein Kontaktformular angezeigt.';

  @override
  String get landingpage_overview_no_default_page_button_title =>
      'Default Landingpage erstellen';

  @override
  String get edit_promoter_no_data_title => 'Keine Daten gefunden';

  @override
  String get edit_promoter_no_data_subtitle =>
      'Zu diesem Promoter wurden keine Daten gefunden';

  @override
  String get send_recommendation_alert_title => 'Empfehlung verschickt?';

  @override
  String send_recommendation_alert_description(String receiver) {
    return 'Hast du die Empfehlung erfolgreich an $receiver verschickt? Der Link in der Empfehlung wird erst gültig wenn du hier bestätigst.';
  }

  @override
  String get send_recommendation_alert_yes_button => 'Ja';

  @override
  String get send_recommendation_alert_no_button => 'Nein';

  @override
  String get send_recommendation_missing_link_text =>
      'Der [LINK] Platzhalter darf nicht fehlen!';

  @override
  String get recommendation_manager_expired_day => 'Tag';

  @override
  String get recommendation_manager_expired_days => 'Tagen';

  @override
  String get recommendation_manager_status_level_1 =>
      'Empfehlung ausgesprochen';

  @override
  String get recommendation_manager_status_level_2 => 'Link geklickt';

  @override
  String get recommendation_manager_status_level_3 => 'Kontakt aufgenommen';

  @override
  String get recommendation_manager_status_level_4 => 'Empfehlung terminiert';

  @override
  String get recommendation_manager_status_level_5 => 'Abgeschlossen';

  @override
  String get recommendation_manager_status_level_6 => 'Nicht abgeschlossen';

  @override
  String get recommendation_manager_filter_expires_date => 'Ablaufdatum';

  @override
  String get recommendation_manager_filter_last_updated =>
      'Zuletzt aktualisiert';

  @override
  String get recommendation_manager_filter_promoter => 'Promoter';

  @override
  String get recommendation_manager_filter_recommendation_receiver =>
      'Empfänger';

  @override
  String get recommendation_manager_filter_reason => 'Grund';

  @override
  String get recommendation_manager_filter_ascending => 'Aufsteigend';

  @override
  String get recommendation_manager_filter_descending => 'Absteigend';

  @override
  String get recommendation_manager_filter_status_all => 'Alle';

  @override
  String get recommendation_manager_list_header_priority => 'Priorität';

  @override
  String get recommendation_manager_list_header_receiver => 'Empfehlungsname';

  @override
  String get recommendation_manager_list_header_promoter => 'Promoter';

  @override
  String get recommendation_manager_list_header_status => 'Status';

  @override
  String get recommendation_manager_list_header_expiration_date =>
      'Läuft ab in';

  @override
  String get recommendation_manager_no_search_result_title =>
      'Keine Suchergebnisse';

  @override
  String get recommendation_manager_no_search_result_description =>
      'Unter deinem Suchbegriff wurden keine Empfehlungen gefunden.';

  @override
  String get recommendation_manager_list_tile_receiver =>
      'Empfehlungsempfänger';

  @override
  String get recommendation_manager_list_tile_reason => 'Empfehlungsgrund';

  @override
  String get recommendation_manager_list_tile_delete_button_title =>
      'Empfehlung löschen';

  @override
  String get recommendation_manager_title => 'Meine Empfehlungen';

  @override
  String get recommendation_manager_filter_tooltip => 'Empfehlungen filtern';

  @override
  String get recommendation_manager_search_close_tooltip => 'Suchtext löschen';

  @override
  String get recommendation_manager_search_placeholder => 'Suche...';

  @override
  String get recommendation_manager_no_data_title =>
      'Keine Empfehlungen gefunden';

  @override
  String get recommendation_manager_no_data_description =>
      'Es wurden keine Empfehlungen gefunden. Du scheinst noch keine Empfehlung ausgesprochen zu haben. Im Empfehlungsmanager werden deine ausgesprochenen Empfehlungen angezeigt.';

  @override
  String get recommendation_manager_no_data_button_title =>
      'Empfehlung aussprechen';

  @override
  String get recommendation_manager_failure_text =>
      'Es ist ein Fehler aufgetreten';

  @override
  String get recommendation_manager_tile_progress_appointment_button_tooltip =>
      'Als terminiert markieren';

  @override
  String get recommendation_manager_tile_progress_finish_button_tooltip =>
      'Als abgeschlossen markieren';

  @override
  String get recommendation_manager_tile_progress_failed_button_tooltip =>
      'Als nicht abgeschlossen markieren';

  @override
  String get recommendation_manager_delete_alert_title => 'Empfehlung löschen';

  @override
  String get recommendation_manager_delete_alert_description =>
      'Möchtest du die Empfehlung wirklich löschen? Der Vorgang kann nicht rückgängig gemacht werden.';

  @override
  String get recommendation_manager_delete_alert_delete_button =>
      'Empfehlung löschen';

  @override
  String get recommendation_manager_delete_alert_cancel_button => 'Abbrechen';

  @override
  String get recommendation_manager_delete_snackbar =>
      'Die Empfehlung wurde erfolgreich gelöscht!';

  @override
  String get recommendation_manager_finished_at_list_header =>
      'Abgeschlossen am';

  @override
  String get recommendation_manager_archive_no_data_title =>
      'Keine archivierten Empfehlungen gefunden';

  @override
  String get recommendation_manager_archive_no_data_description =>
      'Du scheinst noch keine Empfehlungen archiviert zu haben. Es werden alle abgeschlossenen und nicht abgeschlossenen Empfehlungen im Archiv hinterlegt.';

  @override
  String get recommendation_manager_filter_finished_at =>
      'Datum des Abschlusses';

  @override
  String get recommendation_manager_finish_alert_title =>
      'Empfehlung abschließen';

  @override
  String get recommendation_manager_finish_alert_message =>
      'Möchtest du die Empfehlung wirklich als abgeschlossen markieren?\nDie Empfehlung wird dann archiviert.';

  @override
  String get recommendation_manager_finish_alert_archive_button =>
      'Archivieren';

  @override
  String get recommendation_manager_finish_alert_cancel_button => 'Abbrechen';

  @override
  String get recommendation_manager_failed_alert_title =>
      'Empfehlung fehlgeschlagen';

  @override
  String get recommendation_manager_failed_alert_description =>
      'Möchtest du die Empfehlung wirklich als fehlgeschlagen markieren?\nDie Empfehlung wird dann archiviert.';

  @override
  String get recommendation_manager_failed_alert_archive_button =>
      'Archivieren';

  @override
  String get recommendation_manager_failed_alert_cancel_button => 'Abbrechen';

  @override
  String get recommendation_manager_scheduled_snackbar =>
      'Termin wurde erfolgreich gesetzt!';

  @override
  String get recommendation_manager_finished_snackbar =>
      'Deine Empfehlung wurde ins Archiv verschoben!';

  @override
  String get recommendation_manager_active_recommendations_tab =>
      'Aktive Empfehlungen';

  @override
  String get recommendation_manager_achive_tab => 'Archiv';

  @override
  String get recommendation_manager_filter_sort_by_status =>
      'Sortieren nach Status';

  @override
  String get recommendation_manager_filter_sort_by_favorites =>
      'Sortieren nach Favoriten';

  @override
  String get recommendation_manager_filter_favorites => 'Favoriten';

  @override
  String get recommendation_manager_filter_no_favorites => 'Keine Favoriten';

  @override
  String get recommendation_manager_favorite_snackbar =>
      'Favoriten erfolgreich angepasst!';

  @override
  String get recommendation_missing_landingpage_title =>
      'Keine Landingpage gefunden';

  @override
  String get recommendation_missing_landingpage_text =>
      'Um eine Empfehlung aussprechen zu können musst du neben deiner Default Landingpage erst noch eine Landngpage anlegen.';

  @override
  String get recommendation_missing_landingpage_button => 'Zu den Landingpages';

  @override
  String get recommendation_priority_high => 'Hoch';

  @override
  String get recommendation_priority_medium => 'Mittel';

  @override
  String get recommendation_priority_low => 'Niedrig';

  @override
  String get recommendation_manager_filter_sort_by_priorities =>
      'Sortieren nach Priorität';

  @override
  String get recommendation_manager_show_landingpage_button =>
      'Landingpage anzeigen';

  @override
  String get recommendation_manager_select_priority_tooltip =>
      'Priorität auswählen';

  @override
  String get recommendation_manager_priority_snackbar =>
      'Priorität erfolgreich angepasst!';

  @override
  String get recommendation_manager_notes_placeholder =>
      'Hier Notizen eintragen...';

  @override
  String get recommendation_manager_notes_save_button_tooltip =>
      'Notizen speichern';

  @override
  String get recommendation_manager_notes_edit_button_tooltip =>
      'Notizen bearbeiten';

  @override
  String get recommendation_manager_notes_last_updated =>
      'Notizen zuletzt bearbeitet am:';

  @override
  String get dashboard_tutorial_title => 'Kleine Starthilfe';

  @override
  String get dashboard_tutorial_step_email_verification_title =>
      'E-Mail Adresse verifizieren';

  @override
  String get dashboard_tutorial_step_email_verification_content =>
      'Verifiziere deine E-Mail Adresse. Um den Verifizierungslink erneut zu senden, besuche dein Profil.';

  @override
  String get dashboard_tutorial_step_contact_data_title =>
      'Kontaktdaten vervollständigen';

  @override
  String get dashboard_tutorial_step_contact_data_content =>
      'Gehe in dein Profil und vervollständige deine Kontaktdaten.';

  @override
  String get dashboard_tutorial_step_company_registration_title =>
      'Unternehmen registrieren';

  @override
  String get dashboard_tutorial_step_company_registration_content =>
      'Gehe in dein Profil und registriere dein Unternehmen';

  @override
  String get dashboard_tutorial_step_company_approval_title =>
      'Warten auf Freischaltung';

  @override
  String get dashboard_tutorial_step_company_approval_content =>
      'Du hast eine Registrierungsanfrage für dein Unternehmen gestellt. Die Bearbeitung der Anfrage kann ein paar Tage dauern. Schaue später nochmal vorbei.';

  @override
  String get dashboard_tutorial_step_default_landingpage_title =>
      'Default Landingpage anlegen';

  @override
  String get dashboard_tutorial_step_default_landingpage_content =>
      'Für die Nutzung der App musst du eine Default Landingpage anlegen. Auf diese wird zurückgegriffen, falls deine normale Landingpage nicht funktioniert.';

  @override
  String get dashboard_tutorial_step_landingpage_title =>
      'Landingpage erstellen';

  @override
  String get dashboard_tutorial_step_landingpage_content =>
      'Du hast deine Default Landingpage erfolgreich erstellt. Jetzt wird noch eine normale Landingpage benötigt, um dein Produkt oder deine Dienstleistung zu bewerben.';

  @override
  String get dashboard_tutorial_step_promoter_registration_title =>
      'Promoter registrieren';

  @override
  String get dashboard_tutorial_step_promoter_registration_content =>
      'Um deine Dienstleistung oder dein Produkt zu bewerben sind Promoter notwendig. Erstelle deinen ersten Promoter.';

  @override
  String get dashboard_tutorial_step_promoter_waiting_title =>
      'Auf Promoter warten';

  @override
  String get dashboard_tutorial_step_promoter_waiting_content =>
      'Der eingeladene Promoter muss sich jetzt registrieren. Bitte warte bis das geschehen ist.';

  @override
  String get dashboard_tutorial_step_recommendation_title =>
      'Empfehlung aussprechen';

  @override
  String get dashboard_tutorial_step_recommendation_content =>
      'Es ist an der Zeit deine erste Empfehlung auszusprechen, um deinen ersten Kunden zu gewinnen.';

  @override
  String get dashboard_tutorial_step_recommendation_manager_title =>
      'Empfehlungsmanager überprüfen';

  @override
  String get dashboard_tutorial_step_recommendation_manager_content =>
      'Deine erste Empfehlung wird jetzt im Empfehlungsmanager angezeigt. Hier kannst du die Empfehlung priorisieren, Notizen hinterlassen und den Status deiner Empfehlung überprüfen. Außerdem siehst du hier auch alle Empfehlungen die deine Promoter ausgesprochen haben.';

  @override
  String get dashboard_tutorial_step_complete_title => 'Tutorial abschließen';

  @override
  String get dashboard_tutorial_step_complete_content =>
      'Du hast alle Schritte zur Nutzung der App abgeschlossen.';

  @override
  String get dashboard_tutorial_button_to_profile => 'Zum Profil';

  @override
  String get dashboard_tutorial_button_to_landingpages => 'Zu den Landingpages';

  @override
  String get dashboard_tutorial_button_register_promoter =>
      'Promoter registrieren';

  @override
  String get dashboard_tutorial_button_make_recommendation =>
      'Empfehlung aussprechen';

  @override
  String get dashboard_tutorial_button_to_recommendation_manager =>
      'Zum Empfehlungsmanager';

  @override
  String get dashboard_tutorial_button_hide_tutorial => 'Tutorial ausblenden';

  @override
  String get dashboard_tutorial_error_title =>
      'Abruf des Tutorials fehlgeschlagen';

  @override
  String get dashboard_tutorial_error_message =>
      'Der Aufruf ist fehlgeschlagen. Versuche es bitte erneut.';

  @override
  String get recommendation_manager_add_note_button_tooltip =>
      'Notiz hinzufügen';

  @override
  String get recommendation_manager_notes_snackbar =>
      'Notizen erfolgreich angepasst!';

  @override
  String recommendation_manager_notes_last_edited_by_user(String date) {
    return 'Zuletzt von dir bearbeitet am $date';
  }

  @override
  String recommendation_manager_notes_last_edited_by_other(
      String userName, String date) {
    return 'Zuletzt von $userName bearbeitet am $date';
  }

  @override
  String get pagebuilder_text_placeholder_recommendation_name =>
      'Name des Empfohlenen';

  @override
  String get pagebuilder_text_placeholder_promoter_name => 'Name des Promoters';

  @override
  String get pagebuilder_text_placeholder_picker => 'Platzhalter auswählen';

  @override
  String get pagebuilder_config_menu_normal_tab => 'Normal';

  @override
  String get pagebuilder_config_menu_hover_tab => 'Hover';

  @override
  String get pagebuilder_config_menu_hover_switch => 'Hover aktivieren';

  @override
  String get pagebuilder_anchor_button_content_section_id => 'Section ID';

  @override
  String get pagebuilder_anchor_button_content_section_id_subtitle =>
      'Gib bitte die Section ID ein, zu welcher gescrollt werden soll. Diese findest du in der jeweiligen Section.';

  @override
  String get pagebuilder_anchor_button_content_section_id_placeholder =>
      'Section ID';

  @override
  String get pagebuilder_section_id => 'ID:';

  @override
  String get pagebuilder_section_copy_id_tooltip => 'ID kopieren';

  @override
  String get pagebuilder_hierarchy_button_tooltip =>
      'Seitenhierarchie anzeigen';

  @override
  String get pagebuilder_hierarchy_overlay_title => 'Seitenstruktur';

  @override
  String get pagebuilder_hierarchy_overlay_no_elements =>
      'Keine Elemente vorhanden';

  @override
  String get pagebuilder_hierarchy_overlay_section_element => 'Section';

  @override
  String get pagebuilder_hierarchy_overlay_text => 'Text';

  @override
  String get pagebuilder_hierarchy_overlay_image => 'Bild';

  @override
  String get pagebuilder_hierarchy_overlay_button => 'Button';

  @override
  String get pagebuilder_hierarchy_overlay_anchor_button => 'Anker Button';

  @override
  String get pagebuilder_hierarchy_overlay_container => 'Container';

  @override
  String get pagebuilder_hierarchy_overlay_row => 'Reihe';

  @override
  String get pagebuilder_hierarchy_overlay_column => 'Spalte';

  @override
  String get pagebuilder_hierarchy_overlay_icon => 'Icon';

  @override
  String get pagebuilder_hierarchy_overlay_contact_form => 'Kontaktformular';

  @override
  String get pagebuilder_hierarchy_overlay_footer => 'Footer';

  @override
  String get pagebuilder_hierarchy_overlay_video_player => 'Video Player';

  @override
  String get pagebuilder_mobile_not_supported_title =>
      'PageBuilder nur auf Desktop verfügbar';

  @override
  String get pagebuilder_mobile_not_supported_subtitle =>
      'Der PageBuilder ist nur auf Desktop-Geräten verfügbar. Bitte öffnen Sie diese Seite auf einem Computer oder Laptop.\n\n Bist du schon auf einem Computer dann ziehe das Browserfenster größer.';

  @override
  String get dashboard_user_not_found_error_title => 'Nutzer nicht gefunden';

  @override
  String get dashboard_user_not_found_error_message =>
      'Der aktuelle Nutzer wurde nicht gefunden. Bitte versuche es später nochmal.';

  @override
  String get dashboard_greeting => 'Hi';

  @override
  String get dashboard_recommendations_title => 'Anzahl der Empfehlungen';

  @override
  String get dashboard_recommendations_loading_error_title =>
      'Laden der Empfehlungen fehlgeschlagen';

  @override
  String get dashboard_recommendations_chart_no_recommendations =>
      'Keine Empfehlungen vorhanden';

  @override
  String get dashboard_recommendations_all_promoter => 'Alle';

  @override
  String get dashboard_recommendations_missing_promoter_name =>
      'Unbekannter Promoter';

  @override
  String get dashboard_recommendations_own_recommendations =>
      'Eigene Empfehlungen';

  @override
  String dashboard_recommendations_last_24_hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Empfehlungen',
      one: '1 Empfehlung',
      zero: '0 Empfehlungen',
    );
    return 'Letzte 24 Stunden: $_temp0';
  }

  @override
  String dashboard_recommendations_last_7_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Empfehlungen',
      one: '1 Empfehlung',
      zero: '0 Empfehlungen',
    );
    return 'Letzte 7 Tage: $_temp0';
  }

  @override
  String dashboard_recommendations_last_month(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Empfehlungen',
      one: '1 Empfehlung',
      zero: '0 Empfehlungen',
    );
    return 'Letzter Monat: $_temp0';
  }

  @override
  String get dashboard_promoters_title => 'Anzahl der Promoter';

  @override
  String get dashboard_promoters_loading_error_title =>
      'Laden der Promoter fehlgeschlagen';

  @override
  String dashboard_promoters_last_7_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Promoter',
      one: '1 Promoter',
      zero: '0 Promoter',
    );
    return 'Letzte 7 Tage: $_temp0';
  }

  @override
  String dashboard_promoters_last_month(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Promoter',
      one: '1 Promoter',
      zero: '0 Promoter',
    );
    return 'Letzter Monat: $_temp0';
  }

  @override
  String dashboard_promoters_last_year(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Promoter',
      one: '1 Promoter',
      zero: '0 Promoter',
    );
    return 'Letztes Jahr: $_temp0';
  }

  @override
  String get dashboard_promoters_chart_no_promoters =>
      'Keine Promoter gefunden';

  @override
  String get recommendation_manager_field_priority => 'Priorität';

  @override
  String get recommendation_manager_field_notes => 'Notizen';

  @override
  String get recommendation_manager_field_connector => ' und ';

  @override
  String recommendation_manager_edit_message(String userName, String fields) {
    return '$userName hat $fields angepasst';
  }

  @override
  String get feedback_send_button => 'Feedback senden';

  @override
  String get feedback_title_required => 'Titel ist erforderlich';

  @override
  String get feedback_title_too_long =>
      'Titel darf maximal 100 Zeichen lang sein';

  @override
  String get feedback_description_required => 'Beschreibung ist erforderlich';

  @override
  String get feedback_description_too_long =>
      'Beschreibung darf maximal 1000 Zeichen lang sein';

  @override
  String get feedback_dialog_title => 'Feedback geben';

  @override
  String get feedback_dialog_close => 'Schließen';

  @override
  String get feedback_title_placeholder => 'Titel eingeben...';

  @override
  String get feedback_description_placeholder => 'Beschreibung eingeben...';

  @override
  String get feedback_images_label => 'Bilder (optional, max. 3)';

  @override
  String get feedback_cancel_button => 'Abbrechen';

  @override
  String get feedback_send_dialog_button => 'Senden';

  @override
  String get feedback_success_message => 'Feedback erfolgreich gesendet!';

  @override
  String get feedback_email_placeholder => 'E-Mail Adresse (optional)';

  @override
  String get feedback_category_label => 'Kategorie';

  @override
  String get admin_feedback_no_feedback_title => 'Kein Feedback gefunden';

  @override
  String get admin_feedback_no_feedback_subtitle =>
      'Es scheint noch kein Nutzer Feedback hinterlassen zu haben.';

  @override
  String get admin_feedback_refresh_button => 'Aktualisieren';

  @override
  String get admin_feedback_error_title => 'Es ist ein Fehler aufgetreten';

  @override
  String get admin_feedback_delete_title => 'Feedback löschen';

  @override
  String get admin_feedback_delete_message =>
      'Willst du das Feedback wirklich löschen? Es ist danach nicht wiederherstellbar.';

  @override
  String get admin_feedback_delete_button => 'Löschen';

  @override
  String get admin_feedback_cancel_button => 'Abbrechen';

  @override
  String get admin_feedback_description_label => 'Beschreibung:';

  @override
  String get admin_feedback_images_label => 'Bilder:';

  @override
  String get admin_feedback_list_title => 'Nutzerfeedback';

  @override
  String get admin_feedback_type_label => 'Art des Feedbacks:';

  @override
  String get admin_feedback_sender_label => 'Einsender:';

  @override
  String get dashboard_recommendations_all_landingpages => 'Alle';

  @override
  String get dashboard_recommendations_filter_title => 'Empfehlungen filtern';

  @override
  String get dashboard_recommendations_filter_period => 'Zeitraum';

  @override
  String get dashboard_recommendations_filter_status => 'Status';

  @override
  String get dashboard_recommendations_filter_promoter => 'Promoter';

  @override
  String get dashboard_recommendations_filter_landingpage => 'Landingpage';

  @override
  String get dashboard_recommendations_filter_tooltip => 'Filter öffnen';

  @override
  String get dashboard_promoter_ranking_title => 'Promoter Rangliste';

  @override
  String get dashboard_promoter_ranking_period => 'Zeitraum:';

  @override
  String get dashboard_promoter_ranking_loading_error_title =>
      'Fehler beim Laden';

  @override
  String get dashboard_promoter_ranking_loading_error_message =>
      'Die Promoter-Rangliste konnte nicht geladen werden.';

  @override
  String get dashboard_promoter_ranking_no_promoters =>
      'Keine Promoter gefunden.';

  @override
  String get dashboard_promoter_ranking_no_data =>
      'Keine Promoter-Daten verfügbar.';

  @override
  String get dashboard_landingpage_ranking_title => 'Landingpages Rangliste';

  @override
  String get dashboard_landingpage_ranking_period => 'Zeitraum:';

  @override
  String get dashboard_landingpage_ranking_loading_error_title =>
      'Fehler beim Laden';

  @override
  String get dashboard_landingpage_ranking_loading_error_message =>
      'Die Landingpage-Rangliste konnte nicht geladen werden.';

  @override
  String get dashboard_landingpage_ranking_no_landingpages =>
      'Keine Landingpages gefunden.';

  @override
  String get dashboard_landingpage_ranking_no_data =>
      'Keine Landingpage-Daten verfügbar.';

  @override
  String get admin_legals_title => 'Rechtliches';

  @override
  String get admin_legals_avv_label => 'Auftragsverarbeitungsvertrag';

  @override
  String get admin_legals_avv_placeholder => 'AVV eingeben...';

  @override
  String get admin_legals_privacy_policy_label => 'Datenschutzerklärung';

  @override
  String get admin_legals_privacy_policy_placeholder =>
      'Datenschutzerklärung eingeben...';

  @override
  String get admin_legals_terms_label => 'Allgemeine Geschäftsbedingungen';

  @override
  String get admin_legals_terms_placeholder => 'AGBs eingeben...';

  @override
  String get admin_legals_imprint_label => 'Impressum';

  @override
  String get admin_legals_imprint_placeholder => 'Impressum eingeben...';

  @override
  String get admin_legals_save_button => 'Speichern';

  @override
  String get admin_legals_save_success =>
      'Daten für Rechtliches erfolgreich gespeichert!';

  @override
  String get footer_privacy_policy => 'Datenschutzerklärung';

  @override
  String get footer_imprint => 'Impressum';

  @override
  String get footer_terms_and_conditions => 'AGBs';

  @override
  String get dashboard_quicklink_recommendation_text =>
      'Heute schon eine Empfehlung ausgesprochen?';

  @override
  String get dashboard_quicklink_recommendation_button =>
      'Empfehlung aussprechen';

  @override
  String get dashboard_quicklink_manager_text =>
      'Heute schon deine Empfehlungen überprüft?';

  @override
  String get dashboard_quicklink_manager_button => 'Zum Empfehlungsmanager';
}
