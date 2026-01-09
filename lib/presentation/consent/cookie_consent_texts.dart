import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class CookieConsentTexts {
  final AppLocalizations localizations;

  CookieConsentTexts(this.localizations);

  // Banner
  String get bannerTitle => localizations.cookie_consent_banner_title;
  String get bannerDescription =>
      localizations.cookie_consent_banner_description;
  String get bannerAcceptAll => localizations.cookie_consent_banner_accept_all;
  String get bannerRejectAll => localizations.cookie_consent_banner_reject_all;
  String get bannerCustomize => localizations.cookie_consent_banner_customize;

  // Settings Dialog
  String get settingsTitle => localizations.cookie_consent_settings_title;
  String get settingsDescription =>
      localizations.cookie_consent_settings_description;
  String get settingsSave => localizations.cookie_consent_settings_save;
  String get settingsCancel => localizations.cookie_consent_settings_cancel;

  // Category: Necessary
  String get categoryNecessaryTitle =>
      localizations.cookie_consent_category_necessary_title;
  String get categoryNecessaryDescription =>
      localizations.cookie_consent_category_necessary_description;
  String get categoryNecessaryServices =>
      localizations.cookie_consent_category_necessary_services;

  // Category: Statistics
  String get categoryStatisticsTitle =>
      localizations.cookie_consent_category_statistics_title;
  String get categoryStatisticsDescription =>
      localizations.cookie_consent_category_statistics_description;
  String get categoryStatisticsServices =>
      localizations.cookie_consent_category_statistics_services;

  // Settings Button
  String get settingsButton => localizations.cookie_consent_settings_button;

  // Success/Error Messages
  String get saveSuccess => localizations.cookie_consent_save_success;
  String get saveError => localizations.cookie_consent_save_error;

  // Additional
  String get alwaysActive => localizations.cookie_consent_always_active;
  String get privacyPolicy => localizations.cookie_consent_privacy_policy;
}
