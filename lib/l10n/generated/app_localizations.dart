import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// Caption of the register page
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_title;

  /// The subtitle of the register page
  ///
  /// In en, this message translates to:
  /// **'Registriere now to use our service.'**
  String get register_subtitle;

  /// The firstname in the register form
  ///
  /// In en, this message translates to:
  /// **'firstname'**
  String get register_firstname;

  /// The lastname in the register form
  ///
  /// In en, this message translates to:
  /// **'lastname'**
  String get register_lastname;

  /// The birthdate in the register form
  ///
  /// In en, this message translates to:
  /// **'birthdate'**
  String get register_birthdate;

  /// The address in the register form
  ///
  /// In en, this message translates to:
  /// **'address (optional)'**
  String get register_address;

  /// The postcode in the register form
  ///
  /// In en, this message translates to:
  /// **'postcode (optional)'**
  String get register_postcode;

  /// The living place in the register form
  ///
  /// In en, this message translates to:
  /// **'place (optional)'**
  String get register_place;

  /// The email address in the register form
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get register_email;

  /// The password in the register form
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get register_password;

  /// The confirmed password in the register form
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get register_repeat_password;

  /// The button text for the registration
  ///
  /// In en, this message translates to:
  /// **'Rgister now'**
  String get register_now_buttontitle;

  /// The title of the login page
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get login_title;

  /// The subtitle of the login page
  ///
  /// In en, this message translates to:
  /// **'Please login or register.'**
  String get login_subtitle;

  /// email address field of the login form on the login page
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get login_email;

  /// password field of the login form on the login page
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get login_password;

  /// Title of the login button on the login page
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_login_buttontitle;

  /// Register link on the login page which leads to the register page
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get login_register_linktitle;

  /// Register text on the login page
  ///
  /// In en, this message translates to:
  /// **'You don\'\'t have an account? '**
  String get login_register_text;

  /// validationmessage when no email was entered
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get auth_validation_missing_email;

  /// validationmessage when email is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get auth_validation_invalid_email;

  /// validationmessage when no password was entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get auth_validation_missing_password;

  /// validationmessage when no confirmation password was entered
  ///
  /// In en, this message translates to:
  /// **'Please confirm the password'**
  String get auth_validation_confirm_password;

  /// validationmessage when passwords not match
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'\'t match'**
  String get auth_validation_matching_passwords;

  /// validationmessage when no firstname was entered
  ///
  /// In en, this message translates to:
  /// **'Please enter firstname'**
  String get auth_validation_missing_firstname;

  /// validationmessage when firstname is too long
  ///
  /// In en, this message translates to:
  /// **'The entered firstname is too long'**
  String get auth_validation_long_firstname;

  /// validationmessage when no lastname was entered
  ///
  /// In en, this message translates to:
  /// **'Please enter lastname'**
  String get auth_validation_missing_lastname;

  /// validationmessage when lastname is too long
  ///
  /// In en, this message translates to:
  /// **'The entered lastname is too long'**
  String get auth_validation_long_lastname;

  /// validationmessage when no birthdate was entered
  ///
  /// In en, this message translates to:
  /// **'Please enter birthdate'**
  String get auth_validation_missing_birthdate;

  /// validationmessage when birthdate is invalid
  ///
  /// In en, this message translates to:
  /// **'You must be 18 or older'**
  String get auth_validation_invalid_birthdate;

  /// error message when email is already in use
  ///
  /// In en, this message translates to:
  /// **'The email address is already in use.'**
  String get authfailure_email_already_in_use;

  /// error message when email is invalid
  ///
  /// In en, this message translates to:
  /// **'The entered email adress is invalid.'**
  String get authfailure_invalid_email;

  /// error message when password is too weak
  ///
  /// In en, this message translates to:
  /// **'The entered password is too weak. Please use at least 6 characters.'**
  String get authfailure_weak_password;

  /// error message when the user is disabled
  ///
  /// In en, this message translates to:
  /// **'The user is disabled.'**
  String get authfailure_user_disabled;

  /// error message when the user doesn''t exist
  ///
  /// In en, this message translates to:
  /// **'The user doesn\'\'t exist.'**
  String get authfailure_user_not_found;

  /// error message when a wrong password was entered
  ///
  /// In en, this message translates to:
  /// **'The entered password is wrong.'**
  String get authfailure_wrong_password;

  /// error message when invalid credentials have been entered
  ///
  /// In en, this message translates to:
  /// **'Your credentials are invalid.'**
  String get authfailure_invalid_credentials;

  /// error message when credentials has been entered incorrectly too often.
  ///
  /// In en, this message translates to:
  /// **'You have entered your login details incorrectly too many times. Try again later.'**
  String get authfailure_too_many_requests;

  /// error message when an unknown authentication error occured
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured.'**
  String get authfailure_unknown;

  /// the menu entry for the profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuitems_profile;

  /// the menu entry for the dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get menuitems_dashboard;

  /// the menu entry for the recommendations
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get menuitems_recommendations;

  /// the menu entry for the promoters
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get menuitems_promoters;

  /// the menu entry for the landingpage
  ///
  /// In en, this message translates to:
  /// **'Landingpage'**
  String get menuitems_landingpage;

  /// the menu entry for the activities
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get menuitems_activities;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
