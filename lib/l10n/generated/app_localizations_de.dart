import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  String get register_code => 'Registrierungscode';

  @override
  String get register_now_buttontitle => 'Jetzt Registrieren';

  @override
  String get register_invalid_code_error => 'Die Registrierung ist fehlgeschlagen. Bitte prüfen Sie ob Sie einen gültigen Code und die zugehörige E-Mail Adresse verwenden.';

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
  String get auth_validation_missing_code => 'Geben Sie bitte ihren Registrierungscode an';

  @override
  String get auth_validation_missing_gender => 'Geben Sie bitte ihr Geschlecht an';

  @override
  String get auth_validation_missing_additional_info => 'Bitte einen Empfehlungsgrund angeben';

  @override
  String get auth_validation_additional_info_exceed_limit => 'Es sind maximal 500 Zeichen erlaubt';

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
  String get landingpage_overview_error_view_title => 'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String get landingpage_overview_empty_page_title => 'Keine Landingpage gefunden';

  @override
  String get landingpage_overview_empty_page_subtitle => 'Sie scheinen noch keine Landingpage zu haben. Erstellen Sie jetzt ihre Landingpage.';

  @override
  String get landingpage_overview_empty_page_button_title => 'Landingpage registrieren';

  @override
  String get landingpage_delete_alert_title => 'Soll die ausgewählte Landingpage wirklich gelöscht werden?';

  @override
  String get landingpage_delete_alert_msg => 'Das Löschen der Landingpage kann nicht rückgängig gemacht werden.';

  @override
  String get landingpage_success_delete_snackbar_message => 'Landinpage erfolgreich gelöscht!';

  @override
  String get landingpage_snackbar_success => 'Die Landingpage wurde erfolgreich erstellt!';

  @override
  String get landingpage_snackbar_success_changed => 'Die Landingpage wurde erfolgreich geändert!';

  @override
  String get landingpage_snackbar_success_duplicated => 'Die Landingpage wurde erfolgreich dupliziert!';

  @override
  String get landingpage_snackbar_success_toggled_enabled => 'Die Landingpage wurde erfolgreich aktiviert!';

  @override
  String get landingpage_snackbar_success_toggled_disabled => 'Die Landingpage wurde erfolgreich deaktiviert!';

  @override
  String get landingpage_snackbar_failure_toggled => 'Beim umstellen der Landingpage ist ein Fehler aufgetreten';

  @override
  String get landingpage_overview_context_menu_disable => 'deaktivieren';

  @override
  String get landingpage_overview_context_menu_enable => 'aktivieren';

  @override
  String get landingpage_overview_max_count_msg => 'Maximale Anzahl an Landingpages wurde erreicht';

  @override
  String get landingpage_create_buttontitle => 'Landingpage erstellen';

  @override
  String get landingpage_validate_LandingPageName => 'Bitte Namen eingeben!';

  @override
  String get landingpage_validate_LandingPageText => 'Bitte Text eingeben!';

  @override
  String get landingpage_create_txt => 'Landingpage erstellen';

  @override
  String get landingpage_create_promotion_template_description => 'Nachfolgend kannst du eine Vorlage erstellen, die deine Promoter nutzen werden um Empfehlungen per Whatsapp zu versenden.\nDu kannst den Platzhalter \$name nutzen, um den Namen des Empfehlungsempfängers anzuzeigen.';

  @override
  String get landingpage_create_promotion_template_placeholder => 'Vorlage für Promoter (optional)';

  @override
  String get landingpage_create_promotion_template_default_text => 'Das ist eine Vorlage für Empfehlungen.';

  @override
  String get emoji_search_placeholder => 'Suche Emoji';

  @override
  String get open_emoji_picker_tooltip => 'Emoji Picker öffnen';

  @override
  String get landingpage_overview_context_menu_delete => 'Löschen';

  @override
  String get landingpage_overview_context_menu_duplicate => 'Duplizieren';

  @override
  String get placeholder_title => 'Titel';

  @override
  String get placeholder_description => 'Beschreibung';

  @override
  String get error_msg_pleace_upload_picture => 'Bitte ein Bild hochladen';

  @override
  String get menuitems_activities => 'Aktivitäten';

  @override
  String get auth_failure_email_already_in_use => 'Die E-Mail Adresse ist bereits vergeben.';

  @override
  String get auth_failure_invalid_email => 'Die eingegebene E-Mail Adresse ist ungültig.';

  @override
  String get auth_failure_weak_password => 'Das angegebene Passwort ist zu schwach. Bitte nutze mindestens 6 Zeichen.';

  @override
  String get auth_failure_user_disabled => 'Der angegebene Nutzer existiert nicht mehr. Wenden Sie sich bitte an den Support.';

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
  String get profile_page_snackbar_company_registered => 'Die Anfrage zur Unternehmensregistrierung wurde erfolgreich versendet.';

  @override
  String get profile_page_logout_button_title => 'Abmelden';

  @override
  String get profile_page_request_failure_message => 'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String get profile_page_promoters_section_title => 'Promoter';

  @override
  String get profile_page_promoters_section_recommender_count => 'Anzahl der Promoter:';

  @override
  String get gender_picker_choose => 'Wählen Sie ihr Geschlecht';

  @override
  String get gender_picker_not_choosen => 'Nicht ausgewählt';

  @override
  String get gender_picker_male => 'Männlich';

  @override
  String get gender_picker_female => 'Weiblich';

  @override
  String get register_promoter_email_already_in_use => 'Die E-Mail Adresse existiert bereits bei einem anderen Nutzer.';

  @override
  String get register_promoter_title => 'Promoter registrieren';

  @override
  String get register_promoter_first_name => 'Vorname';

  @override
  String get register_promoter_last_name => 'Nachname';

  @override
  String get register_promoter_birthdate => 'Geburtsdatum';

  @override
  String get register_promoter_email => 'E-Mail Adresse';

  @override
  String get register_promoter_additional_info => 'Grund der Empfehlung';

  @override
  String get register_promoter_register_button => 'Registrieren';

  @override
  String get register_promoter_snackbar_success => 'Der neue Promoter wurde erfolgreich registriert!';

  @override
  String get register_promoter_no_landingpage_title => 'Du hast noch keine Landingpage erstellt';

  @override
  String get register_promoter_no_landingpage_subtitle => 'Um einen neuen Promoter erstellen zu können ist es nötig, eine aktive Landingpage zu haben.';

  @override
  String get register_promoter_missing_landingpage_error_message => 'Dem Promoter wurde noch keine Landingpage zugewiesen';

  @override
  String get register_promoter_missing_company_error_message => 'Du kannst keinen Promoter registrieren, da du keinem Unternehmen zugehörig bist';

  @override
  String get promoter_overview_title => 'Meine Promoter';

  @override
  String get promoter_overview_search_placeholder => 'Suche...';

  @override
  String get promoter_overview_filter_show_all => 'Alle anzeigen';

  @override
  String get promoter_overview_filter_show_registered => 'Registrierte anzeigen';

  @override
  String get promoter_overview_filter_show_unregistered => 'Unregistrierte anzeigen';

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
  String get promoter_overview_no_search_results_title => 'Keine Suchergebnisse';

  @override
  String get promoter_overview_no_search_results_subtitle => 'Sie scheinen noch keine Promoter mit dem gesuchten Namen registriert zu haben.\nÄndern Sie Ihren Suchbegriff um nach anderen Promotern zu suchen.';

  @override
  String get promoter_overview_registration_badge_registered => 'Registriert';

  @override
  String get promoter_overview_registration_badge_unregistered => 'Nicht registriert';

  @override
  String get promoter_overview_empty_page_title => 'Keine Promoter gefunden';

  @override
  String get promoter_overview_empty_page_subtitle => 'Sie scheinen noch keine Promoter registriert zu haben. Registrieren Sie jetzt ihre Promoter um die ersten Neukunden zu gewinnen.';

  @override
  String get promoter_overview_empty_page_button_title => 'Promoter registrieren';

  @override
  String get promoter_overview_error_view_title => 'Ein Fehler beim Abruf der Daten ist aufgetreten.';

  @override
  String promoter_overview_expiration_date(String date) {
    return 'Läuft am $date ab';
  }

  @override
  String promoter_overview_creation_date(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String get delete_account_title => 'Account löschen';

  @override
  String get delete_account_subtitle => 'Mit der Löschung Ihres Accounts verbleiben Ihre Daten noch 30 Tage bei uns. In dieser Zeit können Sie sich noch beim Support melden um die Löschung rückgängig zu machen. Danach werden Ihre Daten unwiderruflich gelöscht sein.\n\nGeben Sie bitte ihr Passwort ein um den Account zu löschen.';

  @override
  String get delete_account_password_placeholder => 'Passwort';

  @override
  String get delete_account_button_title => 'Account löschen';

  @override
  String get delete_account_confirmation_alert_title => 'Account wirklich löschen?';

  @override
  String get delete_account_confirmation_alert_message => 'Sind Sie sicher dass Sie ihren Account löschen möchten?';

  @override
  String get delete_account_confirmation_alert_ok_button_title => 'Account löschen';

  @override
  String get delete_account_confirmation_alert_cancel_button_title => 'Abbrechen';

  @override
  String get recommendations_choose_reason_placeholder => 'Wähle einen Grund';

  @override
  String get recommendations_choose_reason_not_chosen => 'Nicht ausgewählt';

  @override
  String get recommendations_title => 'Empfehlungen generieren';

  @override
  String get recommendations_form_promoter_placeholder => 'Promoter';

  @override
  String get recommendations_form_service_provider_placeholder => 'Dienstleister';

  @override
  String get recommendations_form_recommendation_name_placeholder => 'Empfehlungsname';

  @override
  String get recommendations_form_generate_recommendation_button_title => 'Empfehlungen generieren';

  @override
  String get recommendations_error_view_title => 'Beim Abrufen der Daten ist ein Fehler aufgetreten';

  @override
  String get recommendations_validation_missing_lead_name => 'Geben Sie bitte einen Namen an';

  @override
  String get recommendations_validation_missing_promoter_name => 'Geben Sie bitte einen Namen an';

  @override
  String get recommendations_validation_missing_reason => 'Bitte einen Grund angeben';

  @override
  String get profile_company_contact_section_title => 'Unternehmensinformationen';

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
  String get profile_company_validator_missing_name => 'Bitte den Unternehmensnamen angeben';

  @override
  String get profile_company_validator_missing_industry => 'Bitte die Branche angeben';

  @override
  String get profile_company_validator_invalid_phone => 'Die angegebene Telefonnummer ist ungültig';

  @override
  String get profile_company_validator_missing_address => 'Bitte eine Adresse angeben';

  @override
  String get profile_company_validator_missing_postCode => 'Bitte eine PLZ angeben';

  @override
  String get profile_company_validator_invalid_postCode => 'Die PLZ ist ungültig';

  @override
  String get profile_company_validator_missing_place => 'Bitte einen Ort angeben';

  @override
  String get profile_company_validator_missing_phone => 'Bitte Telefonnummer angeben';

  @override
  String get profile_company_contact_section_success_snackbar_message => 'Unternehmensinformationen erfolgreich geändert';

  @override
  String get company_requests_overview_title => 'Anfragen für Unternehmensregistrierungen';

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
  String get admin_company_request_detail_decline_button_title => 'Anfrage ablehnen';

  @override
  String get admin_company_request_detail_accept_button_title => 'Anfrage annehmen';

  @override
  String get admin_company_request_overview_from_user => 'von: ';

  @override
  String get admin_company_request_overview_empty_title => 'Keine Anfragen vorhanden';

  @override
  String get admin_company_request_overview_empty_body => 'Zurzeit scheint es keine Registrierungsanfragen von Unternehmen zu geben.';

  @override
  String get admin_company_request_overview_title => 'Anfragen für Unternehmensregistrierungen';

  @override
  String get admin_company_request_overview_error => 'Es ist ein Fehler aufgetreten';

  @override
  String get company_registration_form_title => 'Unternehmen registrieren';

  @override
  String get company_registration_form_name_textfield_placeholder => 'Unternehmensbezeichnung';

  @override
  String get company_registration_form_industry_textfield_placeholder => 'Branche';

  @override
  String get company_registration_form_website_textfield_placeholder => 'Webseite (optional)';

  @override
  String get company_registration_form_address_textfield_placeholder => 'Straße und Hausnummer';

  @override
  String get company_registration_form_postcode_textfield_placeholder => 'PLZ';

  @override
  String get company_registration_form_place_textfield_placeholder => 'Ort';

  @override
  String get company_registration_form_phone_textfield_placeholder => 'Telefonnummer';

  @override
  String get company_registration_form_register_button_title => 'Jetzt registrieren';

  @override
  String get profile_register_company_section_title => 'Unternehmensregistrierung';

  @override
  String get profile_register_company_section_subtitle_in_progress => 'Deine Anfrage ist in Bearbeitung.\nDie Bearbeitungsdauer liegt bei durchschnittlich 7 Tagen.';

  @override
  String get profile_register_company_section_subtitle_requested_at => 'Eingereicht am ';

  @override
  String get profile_register_company_section_subtitle => 'Registriere jetzt dein Unternehmen, um weitere Vorteile der App nutzen zu können.';

  @override
  String get profile_register_company_section_button_title => 'Zur Registrierung';

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
  String get landingpage_pagebuilder_container_request_error => 'Beim Abruf der Daten ist ein Fehler aufgetreten';

  @override
  String get landingpage_pagebuilder_container_permission_error_title => 'Du bist nicht berechtigt diese Seite aufzurufen';

  @override
  String get landingpage_pagebuilder_container_permission_error_message => 'Du hast nicht die entsprechende Berechtigung um diese Seite zu aufzurufen. Melde dich bitte mit einem Account an der dazu berechtigt ist.';

  @override
  String get landingpage_pagebuilder_appbar_save_button_title => 'Speichern';

  @override
  String get landingpage_pagebuilder_save_error_alert_title => 'Speichern fehlgeschlagen';

  @override
  String get landingpage_pagebuilder_save_error_alert_message => 'Beim Speichern deiner neuen Landingpage Inhalte ist ein Fehler aufgetreten. Bitte versuche es später noch einmal.';

  @override
  String get landingpage_pagebuilder_save_error_alert_button => 'OK';

  @override
  String get landingpage_pagebuilder_save_success_snackbar => 'Die Änderungen wurden erfolgreich gespeichert.';

  @override
  String get landingpage_pagebuilder_image_upload_exceeds_file_size_error => 'Das Bild überschreitet die 5 MB Grenze und kann nicht hochgeladen werden!';

  @override
  String get landingpage_pagebuilder_unload_alert_message => 'Willst du die Seite wirklich verlassen? Nicht gespeicherte Änderungen gehen verloren.';

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
  String get landingpage_pagebuilder_config_menu_contact_form_type => 'Kontaktformular';

  @override
  String get landingpage_pagebuilder_config_menu_unknown_type => 'Unbekannt';

  @override
  String get landingpage_pagebuilder_text_config_text_title => 'Text Konfiguration';

  @override
  String get landingpage_pagebuilder_text_config_alignment => 'Ausrichtung';

  @override
  String get landingpage_pagebuilder_text_config_alignment_left => 'linksbündig';

  @override
  String get landingpage_pagebuilder_text_config_alignment_center => 'zentriert';

  @override
  String get landingpage_pagebuilder_text_config_alignment_right => 'rechtsbündig';

  @override
  String get landingpage_pagebuilder_text_config_alignment_justify => 'Blocksatz';

  @override
  String get landingpage_pagebuilder_text_config_lineheight => 'Zeilenhöhe';

  @override
  String get landingpage_pagebuilder_text_config_letterspacing => 'Zeichenabstand';

  @override
  String get landingpage_pagebuilder_text_config_color => 'Schriftfarbe';

  @override
  String get landingpage_pagebuilder_text_config_font_family => 'Schriftart';

  @override
  String get landingpage_pagebuilder_text_config_shadow => 'Textschatten';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_title => 'Schatten konfigurieren';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_spread_radius => 'Spread Radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_blur_radius => 'Blur Radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_x_offset => 'X Offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_y_offset => 'Y Offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_apply => 'Übernehmen';

  @override
  String get landingpage_pagebuilder_text_config_fontsize => 'Schriftgröße';

  @override
  String get landingpage_pagebuilder_color_picker_title => 'Farbe auswählen';

  @override
  String get landingpage_pagebuilder_color_picker_hex_textfield => 'Hex Code';

  @override
  String get landingpage_pagebuilder_text_config_text_placeholder => 'Hier Text eingeben...';

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
  String get landingpage_pagebuilder_layout_menu_image_control_title => 'Hintergrundbild';

  @override
  String get landingpage_pagebuilder_layout_menu_background_contentmode => 'Anzeigemodus';

  @override
  String get landingpage_pagebuilder_layout_menu_background_overlay => 'Bild Overlay';

  @override
  String get landingpage_pagebuilder_layout_menu_background => 'Hintergrund';

  @override
  String get landingpage_pagebuilder_layout_menu_background_color => 'Hintergrundfarbe';

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
  String get pagebuilder_layout_menu_alignment_bottom_center => 'Unten zentriert';

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
}
