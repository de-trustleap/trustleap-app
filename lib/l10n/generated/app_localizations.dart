import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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

  /// The registration code in the register form
  ///
  /// In en, this message translates to:
  /// **'Registration code'**
  String get register_code;

  /// The button text for the registration
  ///
  /// In en, this message translates to:
  /// **'Rgister now'**
  String get register_now_buttontitle;

  /// The error message on the registration form if the code is invalid.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please check whether you are using a valid code and the associated email address.'**
  String get register_invalid_code_error;

  /// The first part of the Terms and Conditions checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **'I approve the'**
  String get register_terms_and_condition_text;

  /// The link part of the Terms and Conditions checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **'Terms and condition'**
  String get register_terms_and_condition_link;

  /// The second part of the Terms and Conditions checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **''**
  String get register_terms_and_condition_text2;

  /// The first part of the privacy checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **'I approve the'**
  String get register_privacy_policy_text;

  /// The link part of the privacy checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get register_privacy_policy_link;

  /// The second part of the privacy checkbox text on the registration page
  ///
  /// In en, this message translates to:
  /// **''**
  String get register_privacy_policy_text2;

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

  /// Title of the delete buttons
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete_buttontitle;

  /// Titel of the cancel buttons
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel_buttontitle;

  /// Button for save changes
  ///
  /// In en, this message translates to:
  /// **'save changes'**
  String get changes_save_button_title;

  /// password forgotten text on login page.
  ///
  /// In en, this message translates to:
  /// **'Do you have your '**
  String get login_password_forgotten_text;

  /// password forgotten link text on login page.
  ///
  /// In en, this message translates to:
  /// **'Password forgotten?'**
  String get login_password_forgotten_linktext;

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

  /// Error message on the login page if the permissions could not be queried
  ///
  /// In en, this message translates to:
  /// **'An error occurred while querying the permissions'**
  String get login_permission_error_message;

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

  /// validationmessage when date is invalid
  ///
  /// In en, this message translates to:
  /// **'The entered date is invalid.'**
  String get auth_validation_invalid_date;

  /// validationmessage when postcode is invalid
  ///
  /// In en, this message translates to:
  /// **'the postcode is invalid'**
  String get auth_validation_invalid_postcode;

  /// validationmessage when registration code is missing
  ///
  /// In en, this message translates to:
  /// **'Please enter your registration code'**
  String get auth_validation_missing_code;

  /// validationmessage when gender is missing
  ///
  /// In en, this message translates to:
  /// **'Please indicate your gender'**
  String get auth_validation_missing_gender;

  /// validationmessage when reason for recommendation is missing.
  ///
  /// In en, this message translates to:
  /// **'reason for recommendation is missing'**
  String get auth_validation_missing_additional_info;

  /// validationmessage when limit of 500 characters has been exceeded.
  ///
  /// In en, this message translates to:
  /// **'You exceeded the maximal amount of 500 characters'**
  String get auth_validation_additional_info_exceed_limit;

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

  /// The title for the landing pages overview
  ///
  /// In en, this message translates to:
  /// **'Landing pages overview'**
  String get landingpage_overview_title;

  /// the menu entry for the landingpage
  ///
  /// In en, this message translates to:
  /// **'Landingpage'**
  String get menuitems_landingpage;

  /// the menu entry for the registration requests of the companies
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get menuitems_company_requests;

  /// the menu entry for the recommendation manager
  ///
  /// In en, this message translates to:
  /// **'Recommendation Manager'**
  String get menuitems_recommendation_manager;

  /// the menu entry for the registration codes
  ///
  /// In en, this message translates to:
  /// **'Codes'**
  String get menuitems_registration_codes;

  /// the menu entry for the user feedback
  ///
  /// In en, this message translates to:
  /// **'User Feedback'**
  String get menuitems_user_feedback;

  /// the menu entry for legal documents
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get menuitems_legals;

  /// Title for the error view that appears if an error occurred while retrieving the data.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the data.'**
  String get landingpage_overview_error_view_title;

  /// Title for the page that appears when there are no landingpage.
  ///
  /// In en, this message translates to:
  /// **'No landingpage found'**
  String get landingpage_overview_empty_page_title;

  /// Text for the page that appears when you don't have a landing page yet
  ///
  /// In en, this message translates to:
  /// **'Seems like you dont have a landing page yet. Create your landing page now.'**
  String get landingpage_overview_empty_page_subtitle;

  /// Title for the button on the page that appears when you don't have a landing page yet
  ///
  /// In en, this message translates to:
  /// **'Register Landing Page'**
  String get landingpage_overview_empty_page_button_title;

  /// Tooltip for landing page tiles that are still being created
  ///
  /// In en, this message translates to:
  /// **'The page is currently being created. Please wait...'**
  String get landingpage_overview_pending_tooltip;

  /// Title for the Landing Page Deletion Dialog
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the selected landing page?'**
  String get landingpage_delete_alert_title;

  /// Message for the Landing Page Deletion Dialog
  ///
  /// In en, this message translates to:
  /// **'Deleting the landing page cannot be undone.'**
  String get landingpage_delete_alert_msg;

  /// Message for the landing page deletion dialog if promoters no longer have a landing page
  ///
  /// In en, this message translates to:
  /// **'The following promoters will no longer have active landing pages assigned if you delete this page:\n'**
  String get landingpage_delete_alert_msg_promoter_warning;

  /// Message to the landing page deletion dialog if promoters no longer have a landing page continue
  ///
  /// In en, this message translates to:
  /// **'\nDo you want to continue anyway? The action cannot be undone.'**
  String get landingpage_delete_alert_msg_promoter_warning_continue;

  /// Snackbar message when a landing page has been successfully deleted
  ///
  /// In en, this message translates to:
  /// **'Landing page successfully deleted!'**
  String get landingpage_success_delete_snackbar_message;

  /// The title of the snackbar when a new landing page is created
  ///
  /// In en, this message translates to:
  /// **'The landing page was successfully created!'**
  String get landingpage_snackbar_success;

  /// The title of the snackbar when a landing page is changed
  ///
  /// In en, this message translates to:
  /// **'The landing page was successfully changed!'**
  String get landingpage_snackbar_success_changed;

  /// The title of the snackbar when a landing page is duplicated
  ///
  /// In en, this message translates to:
  /// **'The landing page was successfully duplicated!'**
  String get landingpage_snackbar_success_duplicated;

  /// The title of the snackbar when a landing page has been deactivated
  ///
  /// In en, this message translates to:
  /// **'The landing page was successfully enabled!'**
  String get landingpage_snackbar_success_toggled_enabled;

  /// The title of the snackbar when a landing page has been activated
  ///
  /// In en, this message translates to:
  /// **'The landing page was successfully disabled!'**
  String get landingpage_snackbar_success_toggled_disabled;

  /// The title of the snackbar when an error occurs while toggle the landingpage
  ///
  /// In en, this message translates to:
  /// **'An error occurred while toggle the landing page'**
  String get landingpage_snackbar_failure_toggled;

  /// Toggle disable button in the context menu on the landing page overview page
  ///
  /// In en, this message translates to:
  /// **'disable'**
  String get landingpage_overview_context_menu_disable;

  /// Toggle enable button in the context menu on the landing page overview page
  ///
  /// In en, this message translates to:
  /// **'enable'**
  String get landingpage_overview_context_menu_enable;

  /// The title when the maximum number of landing pages is reached
  ///
  /// In en, this message translates to:
  /// **'Maximum number of landing pages reached'**
  String get landingpage_overview_max_count_msg;

  /// Title of the Create Landing Page Button
  ///
  /// In en, this message translates to:
  /// **'Create Landing Page'**
  String get landingpage_create_buttontitle;

  /// Validation message for Landing Page Name
  ///
  /// In en, this message translates to:
  /// **'Please enter a name!'**
  String get landingpage_validate_LandingPageName;

  /// Validation message for Landing Page Text
  ///
  /// In en, this message translates to:
  /// **'Please enter text!'**
  String get landingpage_validate_LandingPageText;

  /// Validation message for landingpage impressum
  ///
  /// In en, this message translates to:
  /// **'Please enter impressum'**
  String get landingpage_validate_impressum;

  /// Validation message for Llandingpage privacy policy
  ///
  /// In en, this message translates to:
  /// **'Please enter privacy policy'**
  String get landingpage_validate_privacy_policy;

  /// Validation message for Llandingpage inital information
  ///
  /// In en, this message translates to:
  /// **'Please enter initial information'**
  String get landingpage_validate_initial_information;

  /// Text under the Progress Indicator in Landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Step {currentStep} of {elementsTotal}'**
  String landingpage_creation_progress_indicator_text(
      int currentStep, int elementsTotal);

  /// Placeholder for impressum in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Impressum'**
  String get landingpage_creation_impressum_placeholder;

  /// Placeholder for privacy policy in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get landingpage_creation_privacy_policy_placeholder;

  /// Placeholder for initial information in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Initial information (optional)'**
  String get landingpage_creation_initial_information_placeholder;

  /// Placeholder for terms and conditions in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions (optional)'**
  String get landingpage_creation_terms_and_conditions_placeholder;

  /// Description for script tags in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Javascript <script> tags can be entered below.\nThis is used, for example, to integrate cookie banners or tracking tools into the landing page.'**
  String get landingpage_creation_scripts_description;

  /// Placeholder for script tags in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Script tags (optional)'**
  String get landingpage_creation_scripts_placeholder;

  /// Title for Back Button in Landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get landingpage_creation_back_button_text;

  /// Title for Landingpage edit Button in Landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Edit Landingpage'**
  String get landingpage_creation_edit_button_text;

  /// Text for Creating Landing Page
  ///
  /// In en, this message translates to:
  /// **'Create Landing Page'**
  String get landingpage_create_txt;

  /// Text for continue Button in landingpage creation form
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get landingpage_creation_continue;

  /// Description for the promotion template textfield on the create landingpage form
  ///
  /// In en, this message translates to:
  /// **'Below you can create a template that your promoters will use to send recommendations via WhatsApp.\nYou can use different placeholders which you can choose from the placeholder menu.'**
  String get landingpage_create_promotion_template_description;

  /// Placeholder for the promotion template textfield
  ///
  /// In en, this message translates to:
  /// **'Template for promoter (optional)'**
  String get landingpage_create_promotion_template_placeholder;

  /// The promotion template text will be replaced with this text if it is not set
  ///
  /// In en, this message translates to:
  /// **'This is the promotion template.'**
  String get landingpage_create_promotion_template_default_text;

  /// Placeholder for the search bar for the emoji search
  ///
  /// In en, this message translates to:
  /// **'Search Emoji'**
  String get emoji_search_placeholder;

  /// Tooltip for the button that can open and close the emoji picker
  ///
  /// In en, this message translates to:
  /// **'Open emoji picker'**
  String get open_emoji_picker_tooltip;

  /// Placeholder menu title
  ///
  /// In en, this message translates to:
  /// **'Choose placeholder'**
  String get landingpage_create_promotion_placeholder_menu;

  /// Placeholder variable for the first name of provider
  ///
  /// In en, this message translates to:
  /// **'First name of provider'**
  String
      get landingpage_create_promotion_placeholder_service_provider_first_name;

  /// Placeholder variable for the last name of provider
  ///
  /// In en, this message translates to:
  /// **'Last name of provider'**
  String
      get landingpage_create_promotion_placeholder_service_provider_last_name;

  /// Placeholder variable for the name of provider
  ///
  /// In en, this message translates to:
  /// **'Name of provider'**
  String get landingpage_create_promotion_placeholder_service_provider_name;

  /// Placeholder variable for the first name of promoter
  ///
  /// In en, this message translates to:
  /// **'First name of promoter'**
  String get landingpage_create_promotion_placeholder_promoter_first_name;

  /// Placeholder variable for the last name of promoter
  ///
  /// In en, this message translates to:
  /// **'Last name of promoter'**
  String get landingpage_create_promotion_placeholder_promoter_last_name;

  /// Placeholder variable for the name of promoter
  ///
  /// In en, this message translates to:
  /// **'Name of promoter'**
  String get landingpage_create_promotion_placeholder_promoter_name;

  /// Placeholder variable for the name of receiver
  ///
  /// In en, this message translates to:
  /// **'Name of receiver'**
  String get landingpage_create_promotion_placeholder_receiver_name;

  /// Delete button in the context menu on the landing page overview page.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get landingpage_overview_context_menu_delete;

  /// Duplicate button in the context menu on the landing page overview page.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get landingpage_overview_context_menu_duplicate;

  /// Platzhalter textbox for Title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get placeholder_title;

  /// Placeholder textbox for description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get placeholder_description;

  /// Placeholder for contact email address in landingpage creator
  ///
  /// In en, this message translates to:
  /// **'Contact email address'**
  String get landingpage_creator_placeholder_contact_email;

  /// Title for business model selection in landingpage creator
  ///
  /// In en, this message translates to:
  /// **'Business Model'**
  String get landingpage_creator_business_model_title;

  /// Label for B2B business model
  ///
  /// In en, this message translates to:
  /// **'B2B'**
  String get landingpage_creator_business_model_b2b_label;

  /// Label for B2C business model
  ///
  /// In en, this message translates to:
  /// **'B2C'**
  String get landingpage_creator_business_model_b2c_label;

  /// Tooltip text for the business model InfoButton
  ///
  /// In en, this message translates to:
  /// **'Choose whether your customers are B2B (business customers) or B2C (end consumers). This is important to embed a disclaimer on the landing page in case of B2B customers.\\nIf you address both business customers and end consumers, choose B2C.'**
  String get landingpage_creator_business_model_info_tooltip;

  /// Error message when no image has been uploaded.
  ///
  /// In en, this message translates to:
  /// **'Please upload an image'**
  String get error_msg_pleace_upload_picture;

  /// error message when the email address is already taken.
  ///
  /// In en, this message translates to:
  /// **'The email adress is already taken.'**
  String get auth_failure_email_already_in_use;

  /// error message when the email address is invalid.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid'**
  String get auth_failure_invalid_email;

  /// error message when the password is too weak.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak. Please use at least 6 characters.'**
  String get auth_failure_weak_password;

  /// error message when the user is disabled.
  ///
  /// In en, this message translates to:
  /// **'The user does not exist anymore. Please contact our support team for further investigation.'**
  String get auth_failure_user_disabled;

  /// error message when the user does not exist.
  ///
  /// In en, this message translates to:
  /// **'The user does not exist.'**
  String get auth_failure_user_not_found;

  /// error message when the password is not correct.
  ///
  /// In en, this message translates to:
  /// **'The entered password is not correct.'**
  String get auth_failure_wrong_password;

  /// error message when the credentials are wrong.
  ///
  /// In en, this message translates to:
  /// **'Your entered credentials do not exist.'**
  String get auth_failure_invalid_credentials;

  /// error message when the credentials has been entered wrong too many times.
  ///
  /// In en, this message translates to:
  /// **'You have entered your login details incorrectly too many times. Try again later.'**
  String get auth_failure_too_many_requests;

  /// error message when the credentials do not belong to the current user.
  ///
  /// In en, this message translates to:
  /// **'Your login information does not belong to the current user.'**
  String get auth_failure_user_mismatch;

  /// error message when the verification code is invalid.
  ///
  /// In en, this message translates to:
  /// **'Your verification code is invalid.'**
  String get auth_failure_invalid_verification_code;

  /// error message for an invalid verification id.
  ///
  /// In en, this message translates to:
  /// **'Your verification id is invalid.'**
  String get auth_failure_invalid_verification_id;

  /// error message if the last login was too long ago and you have to log in again.
  ///
  /// In en, this message translates to:
  /// **'Its been too long since you last logged in. Sign in again.'**
  String get auth_failure_requires_recent_login;

  /// error message when there is a missing password.
  ///
  /// In en, this message translates to:
  /// **'You have to type in your password.'**
  String get auth_failure_missing_password;

  /// general error message.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured.'**
  String get auth_failure_unknown;

  /// Error message if you want to access files for which you need authorization without authorization.
  ///
  /// In en, this message translates to:
  /// **'Permission denied to access these resources.'**
  String get database_failure_permission_denied;

  /// error message when the requested data was not found.
  ///
  /// In en, this message translates to:
  /// **'The requested data was not found.'**
  String get database_failure_not_found;

  /// error message when the data already exists.
  ///
  /// In en, this message translates to:
  /// **'the data already exists.'**
  String get database_failure_already_exists;

  /// error message when there is a timeout.
  ///
  /// In en, this message translates to:
  /// **'Data retrieval takes too long. Try again later.'**
  String get database_failure_deadline_exceeded;

  /// error message when the operation has been cancelled.
  ///
  /// In en, this message translates to:
  /// **'The operation has been cancelled.'**
  String get database_failure_cancelled;

  /// error message when the service is unavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable.'**
  String get database_failure_unavailable;

  /// general error message.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured.'**
  String get database_failure_unknown;

  /// error message that the image was not found
  ///
  /// In en, this message translates to:
  /// **'Image not found.'**
  String get storage_failure_object_not_found;

  /// error message when are not logged in.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in. Please login and try again.'**
  String get storage_failure_not_authenticated;

  /// error message when are not permitted.
  ///
  /// In en, this message translates to:
  /// **'You are not permitted to do this.'**
  String get storage_failure_not_authorized;

  /// error message when there is a timeout.
  ///
  /// In en, this message translates to:
  /// **'There seems to be a problem. The action is taking longer than usual. Please try again later.'**
  String get storage_failure_retry_limit_exceeded;

  /// general error message.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occured. Please try again later.'**
  String get storage_failure_unknown;

  /// title of the password forgotten page.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get password_forgotten_title;

  /// description of the password forgotten page.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address and confirm. A link will then be sent to the email address you provided. You can use this link to reset your password.'**
  String get password_forgotten_description;

  /// title for the password forgotten success alert.
  ///
  /// In en, this message translates to:
  /// **'Password reset succeeded'**
  String get password_forgotten_success_dialog_title;

  /// description for the password forgotten success alert.
  ///
  /// In en, this message translates to:
  /// **'An email has been sent to the email address provided. You can set your new password using the link in the email.'**
  String get password_forgotten_success_dialog_description;

  /// ok button title for the password forgotten success alert.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get password_forgotten_success_dialog_ok_button_title;

  /// button title for password reset on the password forgotten page.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get password_forgotten_button_title;

  /// placeholder for the email address textfield on the password forgotten page.
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get password_forgotten_email_textfield_placeholder;

  /// title for the refresh button on the page that appears when no data could be loaded
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get general_error_view_refresh_button_title;

  /// Row heading for the email column in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get profile_page_email_section_email;

  /// Row heading for the status column in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get profile_page_email_section_status;

  /// description text in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Now enter your new email address and confirm. A confirmation link will then be sent to the new email address. You can use this link to verify your new email address and log in again.'**
  String get profile_page_email_section_description;

  /// button title of the change email button in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Change email address'**
  String get profile_page_email_section_change_email_button_title;

  /// description of the passwort entry in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password if you would like to change your email address.'**
  String get profile_page_email_section_change_email_password_description;

  /// button title of the continue button of the passwort entry in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String
      get profile_page_email_section_change_email_password_continue_button_title;

  /// button title of the resend email verification button in the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Resend link for email verification'**
  String get profile_page_email_section_resend_verify_email_button_title;

  /// title of the email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'E-Mail Settings'**
  String get profile_page_email_section_title;

  /// title of the verified verification badge in email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profile_page_email_section_verification_badge_verified;

  /// title of the unverified verification badge in email area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Unverifiziert'**
  String get profile_page_email_section_verification_badge_unverified;

  /// validation message when upload image is larger than 5 MB.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded the maximum allowed size of 5 MB'**
  String get profile_page_image_section_validation_exceededFileSize;

  /// validation message when image format is invalid
  ///
  /// In en, this message translates to:
  /// **'The image format is invalid'**
  String get profile_page_image_section_validation_not_valid;

  /// validation message when trying to upload multiple images at once using drag and drop.
  ///
  /// In en, this message translates to:
  /// **'You can only upload one image at a time'**
  String get profile_page_image_section_only_one_allowed;

  /// validation message if the image was not found to upload.
  ///
  /// In en, this message translates to:
  /// **'The image to upload was not found'**
  String get profile_page_image_section_upload_not_found;

  /// the title of the tooltip that is displayed when you hover over the close button in full screen mode
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String
      get profile_page_image_section_large_image_view_close_button_tooltip_title;

  /// title of the change password section on profile page.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profile_page_password_update_section_title;

  /// the description of the change password page on the profile page if a new password should be specified.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password and confirm it. You will then be logged out and you can log in with the new password.'**
  String get profile_page_password_update_section_new_password_description;

  /// placeholder for the new password text field on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String
      get profile_page_password_update_section_new_password_textfield_placeholder;

  /// placeholder for the new password repeat text field on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String
      get profile_page_password_update_section_new_password_repeat_textfield_placeholder;

  /// button title for the confirm password change button on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String
      get profile_page_password_update_section_new_password_confirm_button_text;

  /// Description for reauthentication on the Change Password page in the Profile page.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password so that you can create a new password.'**
  String get profile_page_password_update_section_reauth_description;

  /// Placeholder for the password text field of the reauthentication on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String
      get profile_page_password_update_section_reauth_password_textfield_placeholder;

  /// Continue button title of reauthentication on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Weiter'**
  String get profile_page_password_update_section_reauth_continue_button_title;

  /// Title of the contact information section in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get profile_page_contact_section_title;

  /// First name text field designation in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'first name'**
  String get profile_page_contact_section_form_firstname;

  /// Last name text field designation in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'last name'**
  String get profile_page_contact_section_form_lastname;

  /// Address text field designation in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'address'**
  String get profile_page_contact_section_form_address;

  /// Postcode text field designation in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'postcode'**
  String get profile_page_contact_section_form_postcode;

  /// Place text field designation in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'place'**
  String get profile_page_contact_section_form_place;

  /// Save changes button title in the contact information area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profile_page_contact_section_form_save_button_title;

  /// Snackbar title for changing the profile picture on the profile page.
  ///
  /// In en, this message translates to:
  /// **'You have successfully customized the profile picture.'**
  String get profile_page_snackbar_image_changed_message;

  /// Snackbar title for changing contact information on the profile page.
  ///
  /// In en, this message translates to:
  /// **'The change to your contact information was successful.'**
  String get profile_page_snackbar_contact_information_changes;

  /// Snackbar title to send the email for verification.
  ///
  /// In en, this message translates to:
  /// **'A link for email verification has been sent to you.'**
  String get profile_page_snackbar_email_verification;

  /// Snackbar title to send the company registration request.
  ///
  /// In en, this message translates to:
  /// **'The request for the company registration has been sent succesful.'**
  String get profile_page_snackbar_company_registered;

  /// Title of the logout button on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_page_logout_button_title;

  /// Message if no data can be loaded on the profile page.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the data.'**
  String get profile_page_request_failure_message;

  /// Title of the Calendly section on the profile page
  ///
  /// In en, this message translates to:
  /// **'Calendly Integration'**
  String get profile_page_calendly_integration_title;

  /// Description of the Calendly integration on the profile page
  ///
  /// In en, this message translates to:
  /// **'Connect your Calendly account to enable appointment booking.'**
  String get profile_page_calendly_integration_description;

  /// title of the promoter section on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get profile_page_promoters_section_title;

  /// The text above the gender dropdown menu if no gender has yet been selected.
  ///
  /// In en, this message translates to:
  /// **'Choose your gender'**
  String get gender_picker_choose;

  /// The text in the gender dropdown menu if no gender has yet been selected.
  ///
  /// In en, this message translates to:
  /// **'Not choosen'**
  String get gender_picker_not_choosen;

  /// The text in the gender dropdown menu if male has been selected.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get gender_picker_male;

  /// The text in the gender dropdown menu if female has been selected.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get gender_picker_female;

  /// The error text in the promoter registration form if there is already a promoter with this email address.
  ///
  /// In en, this message translates to:
  /// **'The email address already exists for another user.'**
  String get register_promoter_email_already_in_use;

  /// The title of the promoter registration form.
  ///
  /// In en, this message translates to:
  /// **'Register promoter'**
  String get register_promoter_title;

  /// The first name placeholder in the text field of the promoter register form
  ///
  /// In en, this message translates to:
  /// **'firstname'**
  String get register_promoter_first_name;

  /// The last name placeholder in the text field of the promoter register form
  ///
  /// In en, this message translates to:
  /// **'lastname'**
  String get register_promoter_last_name;

  /// The email placeholder in the text field of the promoter register form
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get register_promoter_email;

  /// The reason for the recommendation placeholder in the text field of the promoter register form
  ///
  /// In en, this message translates to:
  /// **'reason for the recommendation'**
  String get register_promoter_additional_info;

  /// The button title to register a new promoter
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_promoter_register_button;

  /// The title of the snack bar when a new promoter is registered
  ///
  /// In en, this message translates to:
  /// **'The new promoter has been successfully registered!'**
  String get register_promoter_snackbar_success;

  /// The title of the page that appears if you do not have a landing page yet and still want to register a promoter
  ///
  /// In en, this message translates to:
  /// **'You have not created a landing page yet'**
  String get register_promoter_no_landingpage_title;

  /// The subtitle of the page that appears if you don't have a landing page yet and still want to register a promoter
  ///
  /// In en, this message translates to:
  /// **'In order to create a new promoter it is necessary to have an active landing page.'**
  String get register_promoter_no_landingpage_subtitle;

  /// Error message that appears if no landing page was assigned during promoter registration.
  ///
  /// In en, this message translates to:
  /// **'The promoter has not yet been assigned a landing page'**
  String get register_promoter_missing_landingpage_error_message;

  /// Error message that appears if no company exists during promoter registration.
  ///
  /// In en, this message translates to:
  /// **'You cannot register a promoter because you are not affiliated with any company'**
  String get register_promoter_missing_company_error_message;

  /// Title of the checkboxes for the landing page assignment during promoter registration
  ///
  /// In en, this message translates to:
  /// **'Assign Landingpages'**
  String get register_promoter_landingpage_assign_title;

  /// Title for the register promoter tab
  ///
  /// In en, this message translates to:
  /// **'Register promoter'**
  String get promoter_register_tab_title;

  /// Title for the my promoters tab
  ///
  /// In en, this message translates to:
  /// **'My promoters'**
  String get my_promoters_tab_title;

  /// The title of the snack bar that appears on the Promoter Page when you have successfully edited a Promoter.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited promoter!'**
  String get promoter_page_edit_promoter_snackbar_title;

  /// The title of the promoter overview
  ///
  /// In en, this message translates to:
  /// **'My promoter'**
  String get promoter_overview_title;

  /// Placeholder in searchbar on the promoter overview
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get promoter_overview_search_placeholder;

  /// Radio button title for selecting which type of users should be displayed
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get promoter_overview_filter_show_all;

  /// Radio button title for selecting which type of users should be displayed
  ///
  /// In en, this message translates to:
  /// **'Show registered'**
  String get promoter_overview_filter_show_registered;

  /// Radio button title for selecting which type of users should be displayed
  ///
  /// In en, this message translates to:
  /// **'Show unregistered'**
  String get promoter_overview_filter_show_unregistered;

  /// The text above the sorting dropdown menu if no gender has yet been selected.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get promoter_overview_filter_sortby_choose;

  /// The text in the sorting dropdown menu if creation date has been selected.
  ///
  /// In en, this message translates to:
  /// **'creation date'**
  String get promoter_overview_filter_sortby_date;

  /// The text in the sorting dropdown menu if firstname has been selected.
  ///
  /// In en, this message translates to:
  /// **'firstname'**
  String get promoter_overview_filter_sortby_firstname;

  /// The text in the sorting dropdown menu if lastname has been selected.
  ///
  /// In en, this message translates to:
  /// **'lastname'**
  String get promoter_overview_filter_sortby_lastname;

  /// The text in the sorting dropdown menu if email address has been selected.
  ///
  /// In en, this message translates to:
  /// **'email address'**
  String get promoter_overview_filter_sortby_email;

  /// Radio button title for selecting which sorting order has been selected.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get promoter_overview_filter_sortorder_asc;

  /// Radio button title for selecting which sorting order has been selected.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get promoter_overview_filter_sortorder_desc;

  /// Title for the no search results view.
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get promoter_overview_no_search_results_title;

  /// Text for the no search results view.
  ///
  /// In en, this message translates to:
  /// **'You don\'t seem to have registered any promoters with the name you\'re looking for yet.\nChange your search term to search for other promoters.'**
  String get promoter_overview_no_search_results_subtitle;

  /// Text that says if the shown promoter is registered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get promoter_overview_registration_badge_registered;

  /// Text that says if the shown promoter is not registered.
  ///
  /// In en, this message translates to:
  /// **'Not registered'**
  String get promoter_overview_registration_badge_unregistered;

  /// Title for the page that appears when there are no promoters.
  ///
  /// In en, this message translates to:
  /// **'No promoter found'**
  String get promoter_overview_empty_page_title;

  /// Text for the page that appears when there are no promoters.
  ///
  /// In en, this message translates to:
  /// **'You dont seem to have any promoters registered yet. Register your promoters now to win your first new customers.'**
  String get promoter_overview_empty_page_subtitle;

  /// Title for the button on the page that appears when there are no promoters.
  ///
  /// In en, this message translates to:
  /// **'Register promoter'**
  String get promoter_overview_empty_page_button_title;

  /// Title for the error view that appears if an error occurred while retrieving the data.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the data.'**
  String get promoter_overview_error_view_title;

  /// Text on the promoter tile that says when the promoter expires.
  ///
  /// In en, this message translates to:
  /// **'expires at {date}'**
  String promoter_overview_expiration_date(String date);

  /// Text on the promoter tile that says when the promoter has been created.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String promoter_overview_creation_date(String date);

  /// Text for the edit promoter button in the three dots menu on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get promoter_overview_edit_promoter_tooltip;

  /// Text for the delete promoter button in the three dots menu on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get promoter_overview_delete_promoter_tooltip;

  /// Title for the promoter deletion alert
  ///
  /// In en, this message translates to:
  /// **'Should the selected promoter really be deleted?'**
  String get promoter_overview_delete_promoter_alert_title;

  /// Description for the promoter deletion alert
  ///
  /// In en, this message translates to:
  /// **'Deleting the promoter cannot be undone.'**
  String get promoter_overview_delete_promoter_alert_description;

  /// Delete button for the promoter deletion alert
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get promoter_overview_delete_promoter_alert_delete_button;

  /// Cancel button for the promoter deletion alert
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get promoter_overview_delete_promoter_alert_cancel_button;

  /// Snackbar title for the success case of promoter deletion
  ///
  /// In en, this message translates to:
  /// **'Promoter successfully deleted'**
  String get promoter_overview_delete_promoter_success_snackbar;

  /// Snackbar title for the failure case of promoter deletion
  ///
  /// In en, this message translates to:
  /// **'Promoter deletion failed!'**
  String get promoter_overview_delete_promoter_failure_snackbar;

  /// Title for the page to delete the account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account_title;

  /// Text for the page to delete the account
  ///
  /// In en, this message translates to:
  /// **'Once your account is deleted, your data will remain with us for 30 days. During this time you can still contact support to reverse the deletion. Your data will then be irrevocably deleted.\n\nPlease enter your password to delete the account.'**
  String get delete_account_subtitle;

  /// Placeholder for the password textfield on the account deletion page.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get delete_account_password_placeholder;

  /// Title for the button on the account deletion page.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account_button_title;

  /// Title for the confirmation alert on the account deletion page.
  ///
  /// In en, this message translates to:
  /// **'Really delete your account?'**
  String get delete_account_confirmation_alert_title;

  /// Message for the confirmation alert on the account deletion page.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get delete_account_confirmation_alert_message;

  /// Title for the confirm button on the confirmation alert to delete the account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account_confirmation_alert_ok_button_title;

  /// Title for the cancel button on the confirmation alert to delete the account.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get delete_account_confirmation_alert_cancel_button_title;

  /// Prefix for LeadTextField title
  ///
  /// In en, this message translates to:
  /// **'Text for'**
  String get recommendation_page_leadTextField_title_prefix;

  /// Title for the send button
  ///
  /// In en, this message translates to:
  /// **'Send via Whatsapp'**
  String get recommendation_page_leadTextField_send_button;

  /// Title for the email send button
  ///
  /// In en, this message translates to:
  /// **'Send via Email'**
  String get recommendation_page_leadTextField_send_email_button;

  /// Message shown when the message cannot be sent
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed or cannot be opened.'**
  String get recommendation_page_send_whatsapp_error;

  /// Message shown when the email client cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Email client could not be opened.'**
  String get recommendation_page_send_email_error;

  /// Message shown when more than 6 items are added
  ///
  /// In en, this message translates to:
  /// **'A maximum of 6 items can be added.'**
  String get recommendation_page_max_item_Message;

  /// Placeholder for the drop-down menu of recommendation reasons on the recommendation page.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason'**
  String get recommendations_choose_reason_placeholder;

  /// Not selected Entry for the recommendation reasons drop-down menu on the recommendation page.
  ///
  /// In en, this message translates to:
  /// **'Not chosen'**
  String get recommendations_choose_reason_not_chosen;

  /// Title for the recommendations page.
  ///
  /// In en, this message translates to:
  /// **'Generate recommendations'**
  String get recommendations_title;

  /// Placeholder for the promoter text field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get recommendations_form_promoter_placeholder;

  /// Placeholder for the service provider text field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get recommendations_form_service_provider_placeholder;

  /// Placeholder for the recommendation name text field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Recommendation name'**
  String get recommendations_form_recommendation_name_placeholder;

  /// Title for the generate recommendations button in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Generate recommendations'**
  String get recommendations_form_generate_recommendation_button_title;

  /// Text in the error view in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the data'**
  String get recommendations_error_view_title;

  /// Validation message if you have not provided a name in the recommendation name field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get recommendations_validation_missing_lead_name;

  /// Validation message if you have not provided a name in the promoter name field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get recommendations_validation_missing_promoter_name;

  /// Validation message if you have not provided a reason in the recommendation reason field in the recommendation form.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get recommendations_validation_missing_reason;

  /// Title of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Company Information'**
  String get profile_company_contact_section_title;

  /// Name above the company name text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get profile_company_contact_section_name;

  /// Name above the industry text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get profile_company_contact_section_industry;

  /// Name above the website text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get profile_company_contact_section_website;

  /// Name above the address text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get profile_company_contact_section_address;

  /// Name above the postcode text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get profile_company_contact_section_postcode;

  /// Name above the place text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get profile_company_contact_section_place;

  /// Name above the phone text field of the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profile_company_contact_section_phone;

  /// First part of the OPC text of the Contact section in the Company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'I approve the'**
  String get profile_company_contact_section_avv_checkbox_text;

  /// Second part of the OPC text of the Contact section in the Company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get profile_company_contact_section_avv_checkbox_text_part2;

  /// OPC link in the Contact section in the Company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'OPC'**
  String get profile_company_contact_section_avv_link;

  /// OPC text if already agreed in the contact section in the company tab on the profile page.
  ///
  /// In en, this message translates to:
  /// **'already approved.'**
  String get profile_company_contact_section_avv_already_approved;

  /// OPC is generated text in the Contact section in the Company tab on the profile page
  ///
  /// In en, this message translates to:
  /// **'OPC is being generated...'**
  String get profile_company_contact_section_avv_generating;

  /// Validation message when there is no company name.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company name'**
  String get profile_company_validator_missing_name;

  /// Validation message when there is no industry.
  ///
  /// In en, this message translates to:
  /// **'Please enter the industry'**
  String get profile_company_validator_missing_industry;

  /// Validation message when the phone number is invalid.
  ///
  /// In en, this message translates to:
  /// **'The phone number is invalid'**
  String get profile_company_validator_invalid_phone;

  /// Validation message when there is no address.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address'**
  String get profile_company_validator_missing_address;

  /// Validation message when there is no postcode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a postcode'**
  String get profile_company_validator_missing_postCode;

  /// Validation message when the postcode is invalid.
  ///
  /// In en, this message translates to:
  /// **'The postcode is invalid'**
  String get profile_company_validator_invalid_postCode;

  /// Validation message when there is no place.
  ///
  /// In en, this message translates to:
  /// **'Please enter a place'**
  String get profile_company_validator_missing_place;

  /// Validation message when there is no phone number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a phone number'**
  String get profile_company_validator_missing_phone;

  /// Snackbar message when company information changed successfully.
  ///
  /// In en, this message translates to:
  /// **'Company information changed successfully'**
  String get profile_company_contact_section_success_snackbar_message;

  /// Heading for the company registration requests in the admin module
  ///
  /// In en, this message translates to:
  /// **'Company Registration Requests'**
  String get company_requests_overview_title;

  /// Heading for the company registration request in the admin module
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get admin_company_request_detail_title;

  /// Text for the company name on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Company name:'**
  String get admin_company_request_detail_name;

  /// Text for the industry on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Industry:'**
  String get admin_company_request_detail_industry;

  /// Text for the address on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get admin_company_request_detail_address;

  /// Text for the postcode on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Postcode:'**
  String get admin_company_request_detail_postcode;

  /// Text for the place on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Place:'**
  String get admin_company_request_detail_place;

  /// Text for the phone on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get admin_company_request_detail_phone;

  /// Text for the website on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Website:'**
  String get admin_company_request_detail_website;

  /// Heading for the user section of company registration request in the admin module
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get admin_company_request_detail_user_title;

  /// Text for the user name on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get admin_company_request_detail_user_name;

  /// Text for the email address on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Email Address:'**
  String get admin_company_request_detail_user_email;

  /// Text for the decline button on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Decline request'**
  String get admin_company_request_detail_decline_button_title;

  /// Text for the accept button on the company request detail page in the admin module
  ///
  /// In en, this message translates to:
  /// **'Accept request'**
  String get admin_company_request_detail_accept_button_title;

  /// Text on the company request overview page that indicates which user the request comes from
  ///
  /// In en, this message translates to:
  /// **'from: '**
  String get admin_company_request_overview_from_user;

  /// Title on the page that comes when there are no company requests
  ///
  /// In en, this message translates to:
  /// **'There are no requests'**
  String get admin_company_request_overview_empty_title;

  /// Text on the page that comes when there are no company requests
  ///
  /// In en, this message translates to:
  /// **'There dont appear to be any registration requests from companies at this time.'**
  String get admin_company_request_overview_empty_body;

  /// Title on the business registration requests overview page
  ///
  /// In en, this message translates to:
  /// **'Requests for company registrations'**
  String get admin_company_request_overview_title;

  /// Error text on the business registration requests overview page
  ///
  /// In en, this message translates to:
  /// **'There was an error'**
  String get admin_company_request_overview_error;

  /// Snackbar message for successfully creating a registration code in the Admin Panel
  ///
  /// In en, this message translates to:
  /// **'Code successfully sent!'**
  String get admin_registration_code_creator_success_snackbar;

  /// Title for the registration code creation in the admin panel
  ///
  /// In en, this message translates to:
  /// **'Create registration code'**
  String get admin_registration_code_creator_title;

  /// Description for creating registration code in the admin panel
  ///
  /// In en, this message translates to:
  /// **'Here you can create a registration code for a user. The code will be sent to the specified email address. The user who registered with this code is not assigned to a company.'**
  String get admin_registration_code_creator_description;

  /// Placeholder for the email address text field for the registration code creation in the admin panel
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get admin_registration_code_creator_email_placeholder;

  /// Placeholder for the firstname text field for the registration code creation in the admin panel
  ///
  /// In en, this message translates to:
  /// **'Firstname'**
  String get admin_registration_code_creator_firstname_placeholder;

  /// Title for sending the code Button for creating the registration code in the admin panel
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get admin_registration_code_creator_send_code_button;

  /// Title of the form in the company registration page
  ///
  /// In en, this message translates to:
  /// **'Register company'**
  String get company_registration_form_title;

  /// Placeholder for the company name textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get company_registration_form_name_textfield_placeholder;

  /// Placeholder for the industry textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get company_registration_form_industry_textfield_placeholder;

  /// Placeholder for the website textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Website (optional)'**
  String get company_registration_form_website_textfield_placeholder;

  /// Placeholder for the address textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get company_registration_form_address_textfield_placeholder;

  /// Placeholder for the postcode textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Postcode'**
  String get company_registration_form_postcode_textfield_placeholder;

  /// Placeholder for the place textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get company_registration_form_place_textfield_placeholder;

  /// Placeholder for the phone textfield in the registration form
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get company_registration_form_phone_textfield_placeholder;

  /// Text on the register button in the company registration form
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get company_registration_form_register_button_title;

  /// Title for the company registration section on the profile page
  ///
  /// In en, this message translates to:
  /// **'Company registration'**
  String get profile_register_company_section_title;

  /// Text for the company registration section on the profile page when the registration is in progress
  ///
  /// In en, this message translates to:
  /// **'Your request is being processed.\nThe processing time is on average 7 days.'**
  String get profile_register_company_section_subtitle_in_progress;

  /// Text for the company registration section on the profile page for the date
  ///
  /// In en, this message translates to:
  /// **'Requested at '**
  String get profile_register_company_section_subtitle_requested_at;

  /// Text for the company registration section on the profile page
  ///
  /// In en, this message translates to:
  /// **'Register your company now to take advantage of the apps additional benefits.'**
  String get profile_register_company_section_subtitle;

  /// Button text for the company registration section on the profile page
  ///
  /// In en, this message translates to:
  /// **'Go to registration'**
  String get profile_register_company_section_button_title;

  /// Tooltip for the image upload on the profile page
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get profile_image_upload_tooltip;

  /// Tooltip for landingpage edit button on the landingpage overview
  ///
  /// In en, this message translates to:
  /// **'Edit landingpage'**
  String get landingpage_overview_edit_tooltip;

  /// Tooltip for landingpage show button on the landingpage overview
  ///
  /// In en, this message translates to:
  /// **'Show Landingpage'**
  String get landingpage_overview_show_tooltip;

  /// Tooltip for the button for changing the email address on the profile page
  ///
  /// In en, this message translates to:
  /// **'Change email address'**
  String get profile_edit_email_tooltip;

  /// Tooltip for the Theme Switcher Light Mode button in the menu
  ///
  /// In en, this message translates to:
  /// **'Lightmode'**
  String get theme_switch_lightmode_tooltip;

  /// Tooltip for the Theme Switcher Light Mode button in the menu
  ///
  /// In en, this message translates to:
  /// **'Darkmode'**
  String get theme_switch_darkmode_tooltip;

  /// Tooltip for the reset search button on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'Reset search'**
  String get promoter_overview_reset_search_tooltip;

  /// Tooltip for the filter button on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'Filter promoters'**
  String get promoter_overview_filter_tooltip;

  /// Title for the promoter filter bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Promoter Filter'**
  String get promoter_overview_filter_title;

  /// Section title for registration filter
  ///
  /// In en, this message translates to:
  /// **'Registration Status'**
  String get promoter_overview_filter_registration_title;

  /// Section title for sort by filter
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get promoter_overview_filter_sortby_title;

  /// Section title for sort order filter
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get promoter_overview_filter_sortorder_title;

  /// Tooltip for the grid button on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get promoter_overview_view_switch_grid_tooltip;

  /// Tooltip for the table button on the promoter overview page
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get promoter_overview_view_switch_table_tooltip;

  /// Tooltip for the add recommendation button in the recommendations form
  ///
  /// In en, this message translates to:
  /// **'Add recommendation'**
  String get recommendations_form_add_button_tooltip;

  /// Title for the recommendation limit
  ///
  /// In en, this message translates to:
  /// **'Recommendation Limit'**
  String get recommendations_limit_title;

  /// Description of the recommendation limit
  ///
  /// In en, this message translates to:
  /// **'You can send up to 6 recommendations per month.'**
  String get recommendations_limit_description;

  /// Status of the recommendation limit with current count
  ///
  /// In en, this message translates to:
  /// **'Sent in the last 30 days: {current} / {max}'**
  String recommendations_limit_status(int current, int max);

  /// Text for the reset time of the recommendation limit in days
  ///
  /// In en, this message translates to:
  /// **'Resets in: {days} days'**
  String recommendations_limit_reset_days(int days);

  /// Text for the reset time of the recommendation limit in hours
  ///
  /// In en, this message translates to:
  /// **'Resets in: {hours} hours'**
  String recommendations_limit_reset_hours(int hours);

  /// Success message after sending a recommendation
  ///
  /// In en, this message translates to:
  /// **'The recommendation to {name} has been sent successfully!'**
  String recommendations_sent_success(String name);

  /// Tooltip when the recommendation limit is reached
  ///
  /// In en, this message translates to:
  /// **'Recommendation limit reached'**
  String get recommendations_limit_reached_tooltip;

  /// Tooltip when no active landing page is assigned
  ///
  /// In en, this message translates to:
  /// **'No active landing page assigned'**
  String get recommendations_no_active_landingpage_tooltip;

  /// Warning when no active landing page is assigned
  ///
  /// In en, this message translates to:
  /// **'No recommendations possible - You have no active landing page assigned'**
  String get recommendations_no_active_landingpage_warning;

  /// Error title on the page builder page if request fails
  ///
  /// In en, this message translates to:
  /// **'An error occurred while retrieving the data'**
  String get landingpage_pagebuilder_container_request_error;

  /// Error title on the page builder page if permission denied
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to access this page'**
  String get landingpage_pagebuilder_container_permission_error_title;

  /// Error message on the page builder page if permission denied
  ///
  /// In en, this message translates to:
  /// **'You do not have the appropriate permission to access this page. Please log in with an account that is authorized to do so.'**
  String get landingpage_pagebuilder_container_permission_error_message;

  /// Text of the save button in the page builder
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get landingpage_pagebuilder_appbar_save_button_title;

  /// Title of the error alert that appears if saving in the Page Builder failed
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get landingpage_pagebuilder_save_error_alert_title;

  /// Text of the error alert that appears if saving in the Page Builder failed
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving your new landing page content. Please try again later.'**
  String get landingpage_pagebuilder_save_error_alert_message;

  /// Button text of the error alert that appears if saving in the Page Builder failed
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get landingpage_pagebuilder_save_error_alert_button;

  /// Text for the snack bar that will be displayed in the page builder if the save was successful
  ///
  /// In en, this message translates to:
  /// **'The changes were saved successfully.'**
  String get landingpage_pagebuilder_save_success_snackbar;

  /// Error message that appears in the page builder when you want to upload an image that is larger than 5 MB
  ///
  /// In en, this message translates to:
  /// **'The image exceeds the 5 MB limit and cannot be uploaded!'**
  String get landingpage_pagebuilder_image_upload_exceeds_file_size_error;

  /// Error message for the alert on the page builder page, which is called when you want to leave the page and have not saved.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to leave the site? Changes that are not saved will be lost.'**
  String get landingpage_pagebuilder_unload_alert_message;

  /// Content tab title in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get landingpage_pagebuilder_config_menu_content_tab;

  /// Design tab title in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get landingpage_pagebuilder_config_menu_design_tab;

  /// Container title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get landingpage_pagebuilder_config_menu_container_type;

  /// Column title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get landingpage_pagebuilder_config_menu_column_type;

  /// Row title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get landingpage_pagebuilder_config_menu_row_type;

  /// Text title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get landingpage_pagebuilder_config_menu_text_type;

  /// Image title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get landingpage_pagebuilder_config_menu_image_type;

  /// Icon title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get landingpage_pagebuilder_config_menu_icon_type;

  /// Button title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get landingpage_pagebuilder_config_menu_button_type;

  /// Contact form title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Contact Form'**
  String get landingpage_pagebuilder_config_menu_contact_form_type;

  /// Footer title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get landingpage_pagebuilder_config_menu_footer_type;

  /// Video player title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Video Player'**
  String get landingpage_pagebuilder_config_menu_video_player_type;

  /// Anchor button title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Anchor Button'**
  String get landingpage_pagebuilder_config_menu_anchor_button_type;

  /// Calendly title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Calendly'**
  String get landingpage_pagebuilder_config_menu_calendly_type;

  /// Unknown title in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get landingpage_pagebuilder_config_menu_unknown_type;

  /// Title for the collapsible view for the text configuration in the pagebuilder text configuration
  ///
  /// In en, this message translates to:
  /// **'Text configuration'**
  String get landingpage_pagebuilder_text_config_text_title;

  /// menu entry in the pagebuilder text configuration
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get landingpage_pagebuilder_text_config_alignment;

  /// Tooltip for left alignment Button in text configuration
  ///
  /// In en, this message translates to:
  /// **'left-align'**
  String get landingpage_pagebuilder_text_config_alignment_left;

  /// Tooltip for center alignment Button in text configuration
  ///
  /// In en, this message translates to:
  /// **'center'**
  String get landingpage_pagebuilder_text_config_alignment_center;

  /// Tooltip for right alignment Button in text configuration
  ///
  /// In en, this message translates to:
  /// **'right-align'**
  String get landingpage_pagebuilder_text_config_alignment_right;

  /// Tooltip for justify alignment Button in text configuration
  ///
  /// In en, this message translates to:
  /// **'justify'**
  String get landingpage_pagebuilder_text_config_alignment_justify;

  /// Text for line height in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Line height'**
  String get landingpage_pagebuilder_text_config_lineheight;

  /// Text for letter spacing in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Letter spacing'**
  String get landingpage_pagebuilder_text_config_letterspacing;

  /// Text for color in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get landingpage_pagebuilder_text_config_color;

  /// Text for font family in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Font family'**
  String get landingpage_pagebuilder_text_config_font_family;

  /// Text for text shadow in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Text shadow'**
  String get landingpage_pagebuilder_text_config_shadow;

  /// Title for text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Configure shadow'**
  String get landingpage_pagebuilder_text_config_shadow_alert_title;

  /// Text for spread radius in the text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Spread radius'**
  String get landingpage_pagebuilder_text_config_shadow_alert_spread_radius;

  /// Text for blur radius in the text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Blur radius'**
  String get landingpage_pagebuilder_text_config_shadow_alert_blur_radius;

  /// Text for x offset in the text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'X offset'**
  String get landingpage_pagebuilder_text_config_shadow_alert_x_offset;

  /// Text for y offset in the text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Y offset'**
  String get landingpage_pagebuilder_text_config_shadow_alert_y_offset;

  /// Text for apply button in the text shadow alert in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get landingpage_pagebuilder_text_config_shadow_alert_apply;

  /// Text for font size in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get landingpage_pagebuilder_text_config_fontsize;

  /// Title for the Color Picker in the pagebuilder configuration
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get landingpage_pagebuilder_color_picker_title;

  /// Title for the hex code textfield in the Color Picker in the pagebuilder configuration
  ///
  /// In en, this message translates to:
  /// **'Hex code'**
  String get landingpage_pagebuilder_color_picker_hex_textfield;

  /// Titel für den Button im Color Picker in der Pagebuilder Konfiguration
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get landingpage_pagebuilder_color_picker_ok_button;

  /// Placeholder for the textfield in the text configuration
  ///
  /// In en, this message translates to:
  /// **'Type text here...'**
  String get landingpage_pagebuilder_text_config_text_placeholder;

  /// Title for the collapsible view for the text content in the pagebuilder text configuration
  ///
  /// In en, this message translates to:
  /// **'Text content'**
  String get landingpage_pagebuilder_text_config_content_title;

  /// Placeholder for Spacing top textfield in the layout menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get landingpage_pagebuilder_layout_spacing_top;

  /// Placeholder for Spacing bottom textfield in the layout menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get landingpage_pagebuilder_layout_spacing_bottom;

  /// Placeholder for Spacing left textfield in the layout menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get landingpage_pagebuilder_layout_spacing_left;

  /// Placeholder for Spacing right textfield in the layout menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get landingpage_pagebuilder_layout_spacing_right;

  /// Title for the layout Collapsible in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get landingpage_pagebuilder_layout_menu_title;

  /// Title padding menu in the Pagebuilder Config Menu in the layout area
  ///
  /// In en, this message translates to:
  /// **'Padding'**
  String get landingpage_pagebuilder_layout_menu_padding;

  /// Title margin menu in the Pagebuilder Config Menu in the layout area
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get landingpage_pagebuilder_layout_menu_margin;

  /// Title alignment menu in the Pagebuilder Config Menu in the layout area
  ///
  /// In en, this message translates to:
  /// **'Alignment'**
  String get landingpage_pagebuilder_layout_menu_alignment;

  /// Title width in percent menu in the Pagebuilder Config Menu in the layout area
  ///
  /// In en, this message translates to:
  /// **'Width in %'**
  String get landingpage_pagebuilder_layout_menu_width_percentage;

  /// Warning when the sum of widths exceeds 100% in the Pagebuilder Config Menu in the layout area
  ///
  /// In en, this message translates to:
  /// **'Sum of widths: {totalWidth}% (will be scaled to 100%)'**
  String landingpage_pagebuilder_layout_menu_width_warning(String totalWidth);

  /// Switch title for promoter image in pagebuilder config menu in background area
  ///
  /// In en, this message translates to:
  /// **'Show pronoter image'**
  String get landingpage_pagebuilder_layout_menu_image_control_switch;

  /// Title background image menu in the Pagebuilder Config Menu in the background area
  ///
  /// In en, this message translates to:
  /// **'Background image'**
  String get landingpage_pagebuilder_layout_menu_image_control_title;

  /// Title background image menu item for image if promoter image should be used in the Pagebuilder Config menu in the background area
  ///
  /// In en, this message translates to:
  /// **'Specify a placeholder image if the promoter image does not exist'**
  String get landingpage_pagebuilder_layout_menu_image_control_title_promoter;

  /// Title contentmode menu in the Pagebuilder Config Menu in the background area
  ///
  /// In en, this message translates to:
  /// **'Content mode'**
  String get landingpage_pagebuilder_layout_menu_background_contentmode;

  /// Title image overlay image menu in the Pagebuilder Config Menu in the background area
  ///
  /// In en, this message translates to:
  /// **'Image overlay'**
  String get landingpage_pagebuilder_layout_menu_background_overlay;

  /// Title background menu in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get landingpage_pagebuilder_layout_menu_background;

  /// Title background color image menu in the Pagebuilder Config Menu in the background area
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get landingpage_pagebuilder_layout_menu_background_color;

  /// Title for Custom CSS menu item in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Custom CSS'**
  String get landingpage_pagebuilder_custom_css_menu_title;

  /// Description for Custom CSS menu item in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'To further customize the layout of this element, you can add custom CSS here.\nCSS changes are not visible in the pagebuilder. You need to check it in the landingpage preview.'**
  String get landingpage_pagebuilder_custom_css_menu_description;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'top left'**
  String get pagebuilder_layout_menu_alignment_top_left;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'top center'**
  String get pagebuilder_layout_menu_alignment_top_center;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'top right'**
  String get pagebuilder_layout_menu_alignment_top_right;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'center left'**
  String get pagebuilder_layout_menu_alignment_center_left;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'center'**
  String get pagebuilder_layout_menu_alignment_center;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'center right'**
  String get pagebuilder_layout_menu_alignment_center_right;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'bottom left'**
  String get pagebuilder_layout_menu_alignment_bottom_left;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'bottom center'**
  String get pagebuilder_layout_menu_alignment_bottom_center;

  /// Title for dropdown entry in the alignment menu in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'bottom right'**
  String get pagebuilder_layout_menu_alignment_bottom_right;

  /// Title for size menu in pagebuilder layout menu
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get pagebuilder_layout_menu_size_control_size;

  /// Width for size menu in pagebuilder layout menu
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get pagebuilder_layout_menu_size_control_width;

  /// Height for size menu in pagebuilder layout menu
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get pagebuilder_layout_menu_size_control_height;

  /// Title for image configuration in pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Image configuration'**
  String get pagebuilder_image_config_title;

  /// title for content mode in image configuration in pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Content mode'**
  String get pagebuilder_image_config_content_mode;

  /// title for image overlay in image configuration in pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Image overlay'**
  String get pagebuilder_image_config_image_overlay;

  /// Title for radius in image configuration in pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get pagebuilder_image_config_border_radius;

  /// Title for image content menu in pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Image content'**
  String get pagebuilder_image_config_image_content;

  /// Title for the collapsible view for the container configuration in the pagebuilder container configuration.
  ///
  /// In en, this message translates to:
  /// **'Container configuration'**
  String get landingpage_pagebuilder_container_config_container_title;

  /// Title for the shadow configuration in the pagebuilder container configuration.
  ///
  /// In en, this message translates to:
  /// **'Shadow'**
  String get landingpage_pagebuilder_container_config_container_shadow;

  /// Title for the collapsible view for the row configuration in the pagebuilder row configuration.
  ///
  /// In en, this message translates to:
  /// **'Row configuration'**
  String get landingpage_pagebuilder_row_config_row_title;

  /// Title for the equal heights configuration in the pagebuilder row configuration.
  ///
  /// In en, this message translates to:
  /// **'Equal heights'**
  String get landingpage_pagebuilder_row_config_row_equal_heights;

  /// Title for the main axis alignment configuration in the pagebuilder row configuration.
  ///
  /// In en, this message translates to:
  /// **'Alignment x-axis'**
  String get landingpage_pagebuilder_row_config_row_main_axis_alignment;

  /// Title for the cross axis alignment configuration in the pagebuilder row configuration.
  ///
  /// In en, this message translates to:
  /// **'Alignment y-axis'**
  String get landingpage_pagebuilder_row_config_row_cross_axis_alignment;

  /// Title for the collapsible view for the column configuration in the pagebuilder column configuration.
  ///
  /// In en, this message translates to:
  /// **'Column configuration'**
  String get landingpage_pagebuilder_column_config_column_title;

  /// Title for the collapsible view for the icon content in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Icon content'**
  String get landingpage_pagebuilder_icon_content;

  /// Title for the change icon menu in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get landingpage_pagebuilder_icon_content_change_icon;

  /// Title for the collapsible view for the icon configuration in the pagebuilder icon configuration.
  ///
  /// In en, this message translates to:
  /// **'Icon configuration'**
  String get landingpage_pagebuilder_icon_config_icon_title;

  /// Title for the color menu in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get landingpage_pagebuilder_icon_config_color;

  /// Title for the size menu in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get landingpage_pagebuilder_icon_config_size;

  /// Title for the icon picker in the icon content tab in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get landingpage_pagebuilder_icon_config_icon_picker_title;

  /// Title for the close button in the icon picker in the icon content tab in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get landingpage_pagebuilder_icon_config_icon_picker_close;

  /// Search placeholder in the icon picker in the icon content tab in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get landingpage_pagebuilder_icon_config_icon_picker_search;

  /// Text that is shown when the search have no results in the icon picker in the icon content tab in the pagebuilder icon configuration
  ///
  /// In en, this message translates to:
  /// **'No results for:'**
  String get landingpage_pagebuilder_icon_config_icon_picker_search_no_results;

  /// Title for the collapsible view for the contact form email adress in the pagebuilder contact form configuration.
  ///
  /// In en, this message translates to:
  /// **'Contactform email'**
  String get landingpage_pagebuilder_contactform_content_email;

  /// Text describing the email address input for the contact form email address in the Pagebuilder contact form configuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter the recipient email address to which the contact request will be sent.'**
  String get landingpage_pagebuilder_contactform_content_email_subtitle;

  /// Placeholder for the contact form email address in the Pagebuilder contact form configuration.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get landingpage_pagebuilder_contactform_content_email_placeholder;

  /// Menu for button width in the button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get pagebuilder_button_config_button_width;

  /// Menu for button height in the button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get pagebuilder_button_config_button_height;

  /// Menu for button border radius in the button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get pagebuilder_button_config_button_border_radius;

  /// Menu for button background color in the button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get pagebuilder_button_config_button_background_color;

  /// Title for button text configuration in the button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Button text configuration'**
  String get pagebuilder_button_config_button_text_configuration;

  /// Title for collapsible menu for the name textfield configuration in the contactform configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Name textfield'**
  String get pagebuilder_contact_form_config_name_textfield_title;

  /// Title for collapsible menu for the email textfield configuration in the contactform configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'E-Mail textfield'**
  String get pagebuilder_contact_form_config_email_textfield_title;

  /// Title for collapsible menu for the phone textfield configuration in the contactform configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Phone textfield'**
  String get pagebuilder_contact_form_config_phone_textfield_title;

  /// Title for collapsible menu for the message textfield configuration in the contactform configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Message textfield'**
  String get pagebuilder_contact_form_config_message_textfield_title;

  /// Title for collapsible menu for the button configuration in the contactform configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Button configuration'**
  String get pagebuilder_contact_form_config_button_title;

  /// Menu for textfield width in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get pagebuilder_textfield_config_textfield_width;

  /// Menu for textfield number of lines minimum in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Number of lines min'**
  String get pagebuilder_textfield_config_textfield_min_lines;

  /// Menu for textfield number of lines maximum in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Number of lines max'**
  String get pagebuilder_textfield_config_textfield_max_lines;

  /// Menu for textfield is required in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get pagebuilder_textfield_config_textfield_required;

  /// Menu for textfield background color in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get pagebuilder_textfield_config_textfield_background_color;

  /// Menu for textfield border color in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Border color'**
  String get pagebuilder_textfield_config_textfield_border_color;

  /// Menu for textfield placeholder color in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get pagebuilder_textfield_config_textfield_placeholder;

  /// Title for textfield text configuration in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Textfield text configuration'**
  String get pagebuilder_textfield_config_textfield_text_configuration;

  /// Title for textfield placeholder configuration in the textfield configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Textfield placeholder configuration'**
  String
      get pagebuilder_textfield_config_textfield_placeholder_text_configuration;

  /// Section Title in the Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get landingpage_pagebuilder_config_menu_section_type;

  /// Collapsible Menu for privacy policy configuration of the footer in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Configuration'**
  String get landingpage_pagebuilder_footer_config_privacy_policy;

  /// Collapsible Menu for impressum configuration of the footer in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Impressum Configuration'**
  String get landingpage_pagebuilder_footer_config_impressum;

  /// Collapsible Menu for initial information configuration of the footer in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Initial Information Configuration '**
  String get landingpage_pagebuilder_footer_config_initial_information;

  /// Collapsible Menu for terms and conditions configuration of the footer in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions Configuration'**
  String get landingpage_pagebuilder_footer_config_terms_and_conditions;

  /// Promoter name on the edit promoter page
  ///
  /// In en, this message translates to:
  /// **'Edit {firstName} {lastName}'**
  String edit_promoter_title(String firstName, String lastName);

  /// Untertitel der Promoter bearbeiten Seite
  ///
  /// In en, this message translates to:
  /// **'Here you can adjust the landingpage allocation.'**
  String get edit_promoter_subtitle;

  /// Title of the save button on the edit promoter page
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get edit_promoter_save_button_title;

  /// Tooltip for inactive landingpages on the edit promoter page.
  ///
  /// In en, this message translates to:
  /// **'This landingpage is not active'**
  String get edit_promoter_inactive_landingpage_tooltip;

  /// Tooltip button for landingpage activation on the edit promoter page.
  ///
  /// In en, this message translates to:
  /// **'Activate landingpage'**
  String get edit_promoter_inactive_landingpage_tooltip_activate_action;

  /// Tooltip warning for inactive landingpages on the promoter overview.
  ///
  /// In en, this message translates to:
  /// **'The promoter doesnt have active assinged landingpages'**
  String get promoter_overview_inactive_landingpage_tooltip_warning;

  /// Tooltip warning button for inactive landingpages on the promoter overview.
  ///
  /// In en, this message translates to:
  /// **'Assign landingpage'**
  String get promoter_overview_inactive_landingpage_tooltip_warning_action;

  /// Title for the collapsible view for the video player configuration in the pagebuilder video player configuration.
  ///
  /// In en, this message translates to:
  /// **'Video Player Configuration'**
  String get landingpage_pagebuilder_video_player_config_title;

  /// Title for the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Calendly Configuration'**
  String get pagebuilder_calendly_config_title;

  /// Menu item for Calendly width in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get pagebuilder_calendly_config_width;

  /// Menu item for Calendly height in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get pagebuilder_calendly_config_height;

  /// Menu item for Calendly border radius in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Border Radius'**
  String get pagebuilder_calendly_config_border_radius;

  /// Title for section max width configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Max Width'**
  String get pagebuilder_section_maxwidth_title;

  /// Label for section max width stepper control in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Max Width'**
  String get pagebuilder_section_maxwidth;

  /// Checkbox label for background constraint in section max width configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Apply max width to background'**
  String get pagebuilder_section_background_constrained;

  /// Menu item for Calendly text color in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Text Color'**
  String get pagebuilder_calendly_config_text_color;

  /// Menu item for Calendly background color in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get pagebuilder_calendly_config_background_color;

  /// Menu item for Calendly primary color in the Calendly configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get pagebuilder_calendly_config_primary_color;

  /// Title for the Calendly event selection in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Calendly Event Selection'**
  String get pagebuilder_calendly_content_title;

  /// Checkbox label to hide event details in Calendly configuration
  ///
  /// In en, this message translates to:
  /// **'Hide Event Details'**
  String get pagebuilder_calendly_content_hide_event_details;

  /// Loading indicator when loading event types
  ///
  /// In en, this message translates to:
  /// **'Loading event types...'**
  String get pagebuilder_calendly_content_loading_event_types;

  /// Display when connecting to Calendly
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get pagebuilder_calendly_content_connecting;

  /// Prefix for error messages with Calendly connection
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get pagebuilder_calendly_content_error_prefix;

  /// Label for event type selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select event type:'**
  String get pagebuilder_calendly_content_select_event_type;

  /// Placeholder for event type dropdown
  ///
  /// In en, this message translates to:
  /// **'Choose event type...'**
  String get pagebuilder_calendly_content_choose_event_type;

  /// Title when Calendly connection is needed
  ///
  /// In en, this message translates to:
  /// **'Calendly connection required'**
  String get pagebuilder_calendly_content_connection_required;

  /// Description why Calendly connection is needed
  ///
  /// In en, this message translates to:
  /// **'To select event types, you must first connect to Calendly.'**
  String get pagebuilder_calendly_content_connection_description;

  /// Button text to connect to Calendly
  ///
  /// In en, this message translates to:
  /// **'Connect to Calendly'**
  String get pagebuilder_calendly_content_connect_button;

  /// Title for the collapsible view for the video player youtube link in the pagebuilder video player configuration.
  ///
  /// In en, this message translates to:
  /// **'Youtube link'**
  String get landingpage_pagebuilder_video_player_config_youtube_link;

  /// Description for the video player youtube link in the pagebuilder video player configuration.
  ///
  /// In en, this message translates to:
  /// **'Please provide the YouTube link where your video can be accessed.'**
  String
      get landingpage_pagebuilder_video_player_config_youtube_link_description;

  /// Placeholder for the video player youtube link in the pagebuilder video player configuration.
  ///
  /// In en, this message translates to:
  /// **'Youtube link'**
  String
      get landingpage_pagebuilder_video_player_config_youtube_link_placeholder;

  /// Error message when company data were not found for the creation of a default landingpage
  ///
  /// In en, this message translates to:
  /// **'Company data not found'**
  String get landingpage_creator_missing_companydata_error;

  /// information text for the creation of a default landingpage in the landingpage creator
  ///
  /// In en, this message translates to:
  /// **'The data from your company profile is used to create the default landing page. This data will be displayed on the default landing page. If you change your company data, the data on your default page will also change.'**
  String get landingpage_creator_default_page_info_text;

  /// Subtitle for the loading overlay of the AI ​​generation in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'The AI ​​is currently creating your landing page...'**
  String get landingpage_creator_ai_loading_subtitle;

  /// Another Subtitle for the loading overlay of the AI ​​generation in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'This may take up to 5 minutes.\nYou can leave this site. The landingpage will appear in your overview when it has been generated.'**
  String get landingpage_creator_ai_loading_subtitle2;

  /// Section title for the AI ​​Generation Section in the Landing Page Creator
  ///
  /// In en, this message translates to:
  /// **'Or let our AI create the page for you'**
  String get landingpage_creator_ai_form_section_title;

  /// Title for the AI ​​Generation Section in the Landing Page Creator
  ///
  /// In en, this message translates to:
  /// **'Enter some information about your business and let the AI ​​create a customized landing page.'**
  String get landingpage_creator_ai_form_title;

  /// Title for Radio Button Section for the AI ​​Generation Section in the Landing Page Creator
  ///
  /// In en, this message translates to:
  /// **'Kind of landing page:'**
  String get landingpage_creator_ai_form_radio_title;

  /// Business Radio Button for the AI ​​Generation Section in the Landing Page Creator
  ///
  /// In en, this message translates to:
  /// **'Business/Company'**
  String get landingpage_creator_ai_form_radio_business;

  /// Financial Advisor Radio Button for the AI ​​Generation Section in the Landing Page Creator
  ///
  /// In en, this message translates to:
  /// **'Finance Advisor'**
  String get landingpage_creator_ai_form_radio_finance;

  /// Individual radio button for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get landingpage_creator_ai_form_radio_individual;

  /// Placeholder for business text field for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Industry/Company Type'**
  String get landingpage_creator_ai_form_business_placeholder;

  /// Placeholder for specialization text field for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get landingpage_creator_ai_form_finance_placeholder;

  /// Placeholder for additional information Text field for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Additional information (optional)'**
  String get landingpage_creator_ai_form_custom_description_placeholder;

  /// Character counter for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get landingpage_creator_ai_form_character_count;

  /// Example text for the AI ​​generation section in the landing page creator
  ///
  /// In en, this message translates to:
  /// **'Example: Our financial office is centrally located in the city center, family-run since 1985, and specializes in independent financial advice and retirement planning. Reliability and trust are our focus – clear structures and calm shades of blue and gray are desired.'**
  String get landingpage_creator_ai_form_example;

  /// Title for the page that is displayed if you have not yet created a default landing page.
  ///
  /// In en, this message translates to:
  /// **'Setup Landingpage'**
  String get landingpage_overview_no_default_page_title;

  /// Text for the page that is displayed if you have not yet created a default landing page.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t set up a landing page for your company yet. Here you can create a default landing page to start with. This landing page will be used if the link to another landing page expires. The landing page displays company information and a contact form.'**
  String get landingpage_overview_no_default_page_subtitle;

  /// Button title for the page that is displayed if you have not yet created a default landing page.
  ///
  /// In en, this message translates to:
  /// **'Create default landingpage'**
  String get landingpage_overview_no_default_page_button_title;

  /// Label for the creation date of a landing page
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get landingpage_overview_created_at;

  /// Label for the modification date of a landing page
  ///
  /// In en, this message translates to:
  /// **'Modified on'**
  String get landingpage_overview_updated_at;

  /// Status text for deactivated landing pages
  ///
  /// In en, this message translates to:
  /// **'DEACTIVATED'**
  String get landingpage_overview_deactivated;

  /// Title of the view that appears when no id is given for editing the promoter.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get edit_promoter_no_data_title;

  /// Text of the view that appears when no id is given for editing the promoter.
  ///
  /// In en, this message translates to:
  /// **'No data was found for this promoter'**
  String get edit_promoter_no_data_subtitle;

  /// Title of the alert to confirm whether you have sent a recommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation sent?'**
  String get send_recommendation_alert_title;

  /// Title of the loading dialog when saving a recommendation
  ///
  /// In en, this message translates to:
  /// **'Save recommendation'**
  String get save_recommendation_loading_title;

  /// Subtitle of the loading dialog when saving a recommendation
  ///
  /// In en, this message translates to:
  /// **'The recommendation is being saved'**
  String get save_recommendation_loading_subtitle;

  /// Description of the alert to confirm whether you have sent a recommendation.
  ///
  /// In en, this message translates to:
  /// **'Did you successfully send the recommendation to {receiver}? The link in the recommendation will only become valid once you confirm it here.'**
  String send_recommendation_alert_description(String receiver);

  /// Confirmation button of the alert to confirm whether you have sent a recommendation.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get send_recommendation_alert_yes_button;

  /// Cancel button of the alert to confirm whether you have sent a recommendation.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get send_recommendation_alert_no_button;

  /// Missing link warning when creating a recommendation.
  ///
  /// In en, this message translates to:
  /// **'The [LINK] placeholder is missing!'**
  String get send_recommendation_missing_link_text;

  /// Expired date in days on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get recommendation_manager_expired_day;

  /// Expired date in days on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get recommendation_manager_expired_days;

  /// Text for the first status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Recommendation made'**
  String get recommendation_manager_status_level_1;

  /// Text for the second status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Link clicked'**
  String get recommendation_manager_status_level_2;

  /// Text for the third status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Contacted'**
  String get recommendation_manager_status_level_3;

  /// Text for the fourth status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Appointment made'**
  String get recommendation_manager_status_level_4;

  /// Text for the fifth status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get recommendation_manager_status_level_5;

  /// Text for the sixth status level of the progress bar on the referral manager page
  ///
  /// In en, this message translates to:
  /// **'Not completed'**
  String get recommendation_manager_status_level_6;

  /// Expiration date in the dropdown menu in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Expiration date'**
  String get recommendation_manager_filter_expires_date;

  /// Last updated date in the dropdown menu in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get recommendation_manager_filter_last_updated;

  /// Promoter in the dropdown menu in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get recommendation_manager_filter_promoter;

  /// Recommendation receiver in the dropdown menu in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Receiver'**
  String get recommendation_manager_filter_recommendation_receiver;

  /// Reason in the dropdown menu in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get recommendation_manager_filter_reason;

  /// Ascending Radio Button in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get recommendation_manager_filter_ascending;

  /// Descending Radio Button in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get recommendation_manager_filter_descending;

  /// All Recommendation Status dropdown menu entry in the Filter View on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get recommendation_manager_filter_status_all;

  /// Priority name entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get recommendation_manager_list_header_priority;

  /// Recommendation name entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Recommendation name'**
  String get recommendation_manager_list_header_receiver;

  /// Promoter entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get recommendation_manager_list_header_promoter;

  /// Status entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get recommendation_manager_list_header_status;

  /// Expiration date entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get recommendation_manager_list_header_expiration_date;

  /// Title for the No Search Results view on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No search results'**
  String get recommendation_manager_no_search_result_title;

  /// TitDescriptionle for the No Search Results view on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No recommendations were found for your search term.'**
  String get recommendation_manager_no_search_result_description;

  /// Recommendation receiver text in list cell on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Recommendation receiver'**
  String get recommendation_manager_list_tile_receiver;

  /// Reason text in list cell on the ReferrRecommendational Manager page
  ///
  /// In en, this message translates to:
  /// **'Recommendation reason'**
  String get recommendation_manager_list_tile_reason;

  /// Button title in list cell on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Delete recommendation'**
  String get recommendation_manager_list_tile_delete_button_title;

  /// Title on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'My Recommendations'**
  String get recommendation_manager_title;

  /// Tooltip for the filter button on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Filter recommendations'**
  String get recommendation_manager_filter_tooltip;

  /// Tooltip for the close button in the search bar on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Delete search term'**
  String get recommendation_manager_search_close_tooltip;

  /// Search placeholder in the search bar on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Suche...'**
  String get recommendation_manager_search_placeholder;

  /// Title of the page that is displayed when there are no recommendations on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No recommendations found'**
  String get recommendation_manager_no_data_title;

  /// Description of the page that is displayed when there are no recommendations on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No recommendations were found. You don\'t seem to have made a recommendation yet. Your recommendations are displayed in the Recommendation Manager.'**
  String get recommendation_manager_no_data_description;

  /// Button text of the page that is displayed when there are no recommendations on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Make a recommendation'**
  String get recommendation_manager_no_data_button_title;

  /// Error text on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'An error has occurred'**
  String get recommendation_manager_failure_text;

  /// Tooltip for the Scheduled button in a cell of the Recommendation Manager
  ///
  /// In en, this message translates to:
  /// **'Mark as scheduled'**
  String get recommendation_manager_tile_progress_appointment_button_tooltip;

  /// Tooltip for the Completed button in a cell of the Recommendation Manager
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get recommendation_manager_tile_progress_finish_button_tooltip;

  /// Tooltip for the Not Completed button in a cell of the Recommendation Manager
  ///
  /// In en, this message translates to:
  /// **'Mark as failed'**
  String get recommendation_manager_tile_progress_failed_button_tooltip;

  /// Title of the deletion alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Delete recommendation'**
  String get recommendation_manager_delete_alert_title;

  /// Description of the deletion alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the recommendation? This action cannot be undone.'**
  String get recommendation_manager_delete_alert_description;

  /// Delete button on the Delete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Delete recommendation'**
  String get recommendation_manager_delete_alert_delete_button;

  /// Cancel button on the Delete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recommendation_manager_delete_alert_cancel_button;

  /// Snackbar Text for Recommendation Delete on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'The recommendation was successfully deleted!'**
  String get recommendation_manager_delete_snackbar;

  /// Finished at entry in the list header on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Finished at'**
  String get recommendation_manager_finished_at_list_header;

  /// Title of the page displayed when there are no archived recommendations on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No archived recommendations found'**
  String get recommendation_manager_archive_no_data_title;

  /// Description of the page displayed when there are no archived recommendations on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'You don\'t appear to have archived any recommendations yet. All completed and incomplete recommendations are stored in the archive.'**
  String get recommendation_manager_archive_no_data_description;

  /// Completion Date Text in the dropdown menu in the Filter View on the Referral Manager page
  ///
  /// In en, this message translates to:
  /// **'Completion date'**
  String get recommendation_manager_filter_finished_at;

  /// Title of the Completion Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Finish recommendation'**
  String get recommendation_manager_finish_alert_title;

  /// Message of the Completion Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Do you really want to mark the recommendation as completed?\nThe recommendation will then be archived.'**
  String get recommendation_manager_finish_alert_message;

  /// Archive button of the Complete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get recommendation_manager_finish_alert_archive_button;

  /// Cancel button of the Complete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recommendation_manager_finish_alert_cancel_button;

  /// Title of the not completed Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Recommendation not completed'**
  String get recommendation_manager_failed_alert_title;

  /// Description of the not completed Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark the recommendation as failed?\nThe recommendation will then be archived.'**
  String get recommendation_manager_failed_alert_description;

  /// Archive button of the not Complete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get recommendation_manager_failed_alert_archive_button;

  /// Cancel button of the not Complete Alert on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recommendation_manager_failed_alert_cancel_button;

  /// Snackbar message when appointment was successfully set on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Appointment was successfully scheduled!'**
  String get recommendation_manager_scheduled_snackbar;

  /// Snackbar message when recommendation has been successfully moved to the archive on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Your recommendation has been moved to the archive!'**
  String get recommendation_manager_finished_snackbar;

  /// Tab title on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Active Recommendations'**
  String get recommendation_manager_active_recommendations_tab;

  /// Tab title on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get recommendation_manager_achive_tab;

  /// The text above the status dropdown menu in the filter on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Sort by status'**
  String get recommendation_manager_filter_sort_by_status;

  /// The text above the favorite dropdown menu in the filter on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Sort by favorites'**
  String get recommendation_manager_filter_sort_by_favorites;

  /// The Favorites dropdown menu entry in the filter on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get recommendation_manager_filter_favorites;

  /// The No Favorites dropdown menu entry in the filter on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'No favorites'**
  String get recommendation_manager_filter_no_favorites;

  /// Snackbar message when favorite state of recommendation has been successfully changed on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Favorites successfully changed!'**
  String get recommendation_manager_favorite_snackbar;

  /// Title of the page displayed on the recommendation page if no landing page was found
  ///
  /// In en, this message translates to:
  /// **'No landingpage found'**
  String get recommendation_missing_landingpage_title;

  /// Text of the page displayed on the recommendation page if no landing page was found
  ///
  /// In en, this message translates to:
  /// **'In order to make a recommendation, you must first create a landing page in addition to your default landing page.'**
  String get recommendation_missing_landingpage_text;

  /// Button on the page that is displayed on the recommendation page if no landing page was found, which leads to the landing page menu
  ///
  /// In en, this message translates to:
  /// **'To the landingpages'**
  String get recommendation_missing_landingpage_button;

  /// The priority High for a recommendation
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get recommendation_priority_high;

  /// The priority Medium for a recommendation
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get recommendation_priority_medium;

  /// The priority Low for a recommendation
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get recommendation_priority_low;

  /// Label for the checkbox to enable dynamic height for Calendly widget
  ///
  /// In en, this message translates to:
  /// **'Dynamic Height'**
  String get pagebuilder_calendly_config_dynamic_height;

  /// The text above the priority dropdown menu in the filter on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Sort by priority'**
  String get recommendation_manager_filter_sort_by_priorities;

  /// Button in the recommendation manager cell that opens the landingpage
  ///
  /// In en, this message translates to:
  /// **'Show landingpage'**
  String get recommendation_manager_show_landingpage_button;

  /// Tooltip for the button in the recommendation manager cell that opens the priority dropdown
  ///
  /// In en, this message translates to:
  /// **'Select priority'**
  String get recommendation_manager_select_priority_tooltip;

  /// Snackbar message when priority of recommendation has been successfully changed on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Priority successfully changed!'**
  String get recommendation_manager_priority_snackbar;

  /// Placeholder for the Notes text field in the cells on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Add notes here...'**
  String get recommendation_manager_notes_placeholder;

  /// Tooltip for the Save Notes button in the cells on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Save notes'**
  String get recommendation_manager_notes_save_button_tooltip;

  /// Tooltip for the Edit Notes button in the cells on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Edit notes'**
  String get recommendation_manager_notes_edit_button_tooltip;

  /// Notes Last edited text in the cells on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Notes last edited at:'**
  String get recommendation_manager_notes_last_updated;

  /// The title of the tutorial widget on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get dashboard_tutorial_title;

  /// Title for Step 0: Email verification
  ///
  /// In en, this message translates to:
  /// **'Verify email address'**
  String get dashboard_tutorial_step_email_verification_title;

  /// Content for Step 0: Email verification
  ///
  /// In en, this message translates to:
  /// **'Verify your email address. To resend the verification link, visit your profile.'**
  String get dashboard_tutorial_step_email_verification_content;

  /// Title for Step 1: Complete contact data
  ///
  /// In en, this message translates to:
  /// **'Complete contact data'**
  String get dashboard_tutorial_step_contact_data_title;

  /// Content for Step 1: Complete contact data
  ///
  /// In en, this message translates to:
  /// **'Go to your profile and complete your contact data.'**
  String get dashboard_tutorial_step_contact_data_content;

  /// Title for Step 2: Register company
  ///
  /// In en, this message translates to:
  /// **'Register company'**
  String get dashboard_tutorial_step_company_registration_title;

  /// Content for Step 2: Register company
  ///
  /// In en, this message translates to:
  /// **'Go to your profile and register your company'**
  String get dashboard_tutorial_step_company_registration_content;

  /// Title for Step 3: Wait for approval
  ///
  /// In en, this message translates to:
  /// **'Wait for approval'**
  String get dashboard_tutorial_step_company_approval_title;

  /// Content for Step 3: Wait for approval
  ///
  /// In en, this message translates to:
  /// **'You have submitted a registration request for your company. Processing the request may take a few days. Please check back later.'**
  String get dashboard_tutorial_step_company_approval_content;

  /// Title for Step 4: Create default landing page
  ///
  /// In en, this message translates to:
  /// **'Create default landing page'**
  String get dashboard_tutorial_step_default_landingpage_title;

  /// Content for Step 4: Create default landing page
  ///
  /// In en, this message translates to:
  /// **'To use the app, you must create a default landing page. This will be used as a fallback if your normal landing page doesn\'t work.'**
  String get dashboard_tutorial_step_default_landingpage_content;

  /// Title for Step 5: Create landing page
  ///
  /// In en, this message translates to:
  /// **'Create landing page'**
  String get dashboard_tutorial_step_landingpage_title;

  /// Content for Step 5: Create landing page
  ///
  /// In en, this message translates to:
  /// **'You have successfully created your default landing page. Now you need a normal landing page to promote your product or service.'**
  String get dashboard_tutorial_step_landingpage_content;

  /// Title for Step 6: Register promoter
  ///
  /// In en, this message translates to:
  /// **'Register promoter'**
  String get dashboard_tutorial_step_promoter_registration_title;

  /// Content for Step 6: Register promoter
  ///
  /// In en, this message translates to:
  /// **'To promote your service or product, promoters are necessary. Create your first promoter.'**
  String get dashboard_tutorial_step_promoter_registration_content;

  /// Title for Step 7: Wait for promoter
  ///
  /// In en, this message translates to:
  /// **'Wait for promoter'**
  String get dashboard_tutorial_step_promoter_waiting_title;

  /// Content for Step 7: Wait for promoter
  ///
  /// In en, this message translates to:
  /// **'The invited promoter must now register. Please wait until this happens.'**
  String get dashboard_tutorial_step_promoter_waiting_content;

  /// Title for Step 8: Make recommendation
  ///
  /// In en, this message translates to:
  /// **'Make recommendation'**
  String get dashboard_tutorial_step_recommendation_title;

  /// Content for Step 8: Make recommendation
  ///
  /// In en, this message translates to:
  /// **'It\'s time to make your first recommendation to win your first customer.'**
  String get dashboard_tutorial_step_recommendation_content;

  /// Title for Step 9: Check recommendation manager
  ///
  /// In en, this message translates to:
  /// **'Check recommendation manager'**
  String get dashboard_tutorial_step_recommendation_manager_title;

  /// Content for Step 9: Check recommendation manager
  ///
  /// In en, this message translates to:
  /// **'Your first recommendation is now displayed in the recommendation manager. Here you can prioritize the recommendation, leave notes, and check the status of your recommendation. You will also see all recommendations made by your promoters.'**
  String get dashboard_tutorial_step_recommendation_manager_content;

  /// Title for Step 10: Complete tutorial
  ///
  /// In en, this message translates to:
  /// **'Complete tutorial'**
  String get dashboard_tutorial_step_complete_title;

  /// Content for Step 10: Complete tutorial
  ///
  /// In en, this message translates to:
  /// **'You have completed all steps for using the app.'**
  String get dashboard_tutorial_step_complete_content;

  /// Button text for navigation to profile
  ///
  /// In en, this message translates to:
  /// **'To profile'**
  String get dashboard_tutorial_button_to_profile;

  /// Button text for navigation to landing pages
  ///
  /// In en, this message translates to:
  /// **'To landing pages'**
  String get dashboard_tutorial_button_to_landingpages;

  /// Button text for register promoter
  ///
  /// In en, this message translates to:
  /// **'Register promoter'**
  String get dashboard_tutorial_button_register_promoter;

  /// Button text for make recommendation
  ///
  /// In en, this message translates to:
  /// **'Make recommendation'**
  String get dashboard_tutorial_button_make_recommendation;

  /// Button text for navigation to recommendation manager
  ///
  /// In en, this message translates to:
  /// **'To recommendation manager'**
  String get dashboard_tutorial_button_to_recommendation_manager;

  /// Button text for hide tutorial
  ///
  /// In en, this message translates to:
  /// **'Hide tutorial'**
  String get dashboard_tutorial_button_hide_tutorial;

  /// Error title when tutorial cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load tutorial'**
  String get dashboard_tutorial_error_title;

  /// Error message when tutorial cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'The request failed. Please try again.'**
  String get dashboard_tutorial_error_message;

  /// Tooltip for the Add Note button in the cells on the Recommendation Manager page
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get recommendation_manager_add_note_button_tooltip;

  /// Snackbar message when notes of recommendation has been successfully changed on the recommendation manager page
  ///
  /// In en, this message translates to:
  /// **'Notes successfully changed!'**
  String get recommendation_manager_notes_snackbar;

  /// Text showing when the current user last edited the notes
  ///
  /// In en, this message translates to:
  /// **'Last edited by you on {date}'**
  String recommendation_manager_notes_last_edited_by_user(String date);

  /// Text showing when another user last edited the notes
  ///
  /// In en, this message translates to:
  /// **'Last edited by {userName} on {date}'**
  String recommendation_manager_notes_last_edited_by_other(
      String userName, String date);

  /// Placeholder dropdown entry for name of the recommended person in Pagebuilder Text Config menu
  ///
  /// In en, this message translates to:
  /// **'Name of recommendation'**
  String get pagebuilder_text_placeholder_recommendation_name;

  /// Placeholder dropdown entry for name of the promoter in Pagebuilder Text Config menu
  ///
  /// In en, this message translates to:
  /// **'Name of promoter'**
  String get pagebuilder_text_placeholder_promoter_name;

  /// Title of dropdown menu for placeholder in text config menu
  ///
  /// In en, this message translates to:
  /// **'Choose placeholder'**
  String get pagebuilder_text_placeholder_picker;

  /// Title of the normal tab in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get pagebuilder_config_menu_normal_tab;

  /// Title of the hover tab in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Hover'**
  String get pagebuilder_config_menu_hover_tab;

  /// Title of the hover switch in the hover tab in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Activate hover'**
  String get pagebuilder_config_menu_hover_switch;

  /// Title for the collapsible view for the anchor button configuration in the pagebuilder config menu
  ///
  /// In en, this message translates to:
  /// **'Anchor Button Configuration'**
  String get pagebuilder_anchor_button_config_title;

  /// Title for the collapsible view for the anchor button section name in the pagebuilder anchor button configuration
  ///
  /// In en, this message translates to:
  /// **'Section Name'**
  String get pagebuilder_anchor_button_content_section_name;

  /// Subtitle for the collapsible view for the anchor button section name in the pagebuilder anchor button configuration
  ///
  /// In en, this message translates to:
  /// **'Please enter the section name you want to scroll to. You can find this in the respective section.'**
  String get pagebuilder_anchor_button_content_section_name_subtitle;

  /// Message shown when no sections are available for selection in the anchor button configuration
  ///
  /// In en, this message translates to:
  /// **'No sections available'**
  String get pagebuilder_anchor_button_content_no_sections_available;

  /// Placeholder text for the section name dropdown in the anchor button config menu when no section is selected yet
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get pagebuilder_anchor_button_content_section_name_placeholder;

  /// Text before the ID in the Pagebuilder Section configuration
  ///
  /// In en, this message translates to:
  /// **'ID:'**
  String get pagebuilder_section_id;

  /// Tooltip for the Copy ID button in the Pagebuilder Section configuration
  ///
  /// In en, this message translates to:
  /// **'Copy id'**
  String get pagebuilder_section_copy_id_tooltip;

  /// Button tooltip for the page hierarchy button in the Pagebuilder AppBar
  ///
  /// In en, this message translates to:
  /// **'Show page hierarchy'**
  String get pagebuilder_hierarchy_button_tooltip;

  /// Button tooltip for the responsive preview button in the Pagebuilder AppBar
  ///
  /// In en, this message translates to:
  /// **'Responsive mode'**
  String get pagebuilder_responsive_preview_button_tooltip;

  /// Label for Desktop breakpoint in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get pagebuilder_breakpoint_desktop;

  /// Label for Tablet breakpoint in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get pagebuilder_breakpoint_tablet;

  /// Label for Mobile breakpoint in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get pagebuilder_breakpoint_mobile;

  /// Title of the hierarchy overlay in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Page structure'**
  String get pagebuilder_hierarchy_overlay_title;

  /// No elements available text in the hierarchy overlay in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'No elements available'**
  String get pagebuilder_hierarchy_overlay_no_elements;

  /// Collapsible section element in the hierarchy overlay in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Section'**
  String get pagebuilder_hierarchy_overlay_section_element;

  /// Text element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get pagebuilder_hierarchy_overlay_text;

  /// Image element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get pagebuilder_hierarchy_overlay_image;

  /// Button element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get pagebuilder_hierarchy_overlay_button;

  /// Anchor button element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Anchor button'**
  String get pagebuilder_hierarchy_overlay_anchor_button;

  /// Container element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get pagebuilder_hierarchy_overlay_container;

  /// Row element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Row'**
  String get pagebuilder_hierarchy_overlay_row;

  /// Column element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Column'**
  String get pagebuilder_hierarchy_overlay_column;

  /// Icon element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get pagebuilder_hierarchy_overlay_icon;

  /// Contact form element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Contact form'**
  String get pagebuilder_hierarchy_overlay_contact_form;

  /// Footer element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get pagebuilder_hierarchy_overlay_footer;

  /// Video player element in the hierarchy overlay in the pagebuilder
  ///
  /// In en, this message translates to:
  /// **'Video player'**
  String get pagebuilder_hierarchy_overlay_video_player;

  /// Title of the Mobile not Supported View in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'PageBuilder only available for desktop'**
  String get pagebuilder_mobile_not_supported_title;

  /// Subtitle of the Mobile not Supported View in the Pagebuilder
  ///
  /// In en, this message translates to:
  /// **'The PageBuilder is only available on desktop devices. Please open this page on a computer or laptop.\n\n If you\'re already on a computer, resize the browser window.'**
  String get pagebuilder_mobile_not_supported_subtitle;

  /// User not found error title on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get dashboard_user_not_found_error_title;

  /// User not found error message on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'The current user could not be found. Please try again later.'**
  String get dashboard_user_not_found_error_message;

  /// Welcoming the user on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Hi'**
  String get dashboard_greeting;

  /// Title for the recommendation statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Number of recommendations'**
  String get dashboard_recommendations_title;

  /// Loading error for the recommendation statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Loading recommendations failed'**
  String get dashboard_recommendations_loading_error_title;

  /// Message in case there are no recommendations for the recommendation statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'No recommendations available'**
  String get dashboard_recommendations_chart_no_recommendations;

  /// Dropdown entry for displaying all recommendations of all promoters for the recommendation statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboard_recommendations_all_promoter;

  /// Dropdown entry in case the promoter name is missing for the referral statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Unkown promoter'**
  String get dashboard_recommendations_missing_promoter_name;

  /// Dropdown entry for the company's own recommendations for the recommendation statistics on the dashboard page
  ///
  /// In en, this message translates to:
  /// **'Own recommendations'**
  String get dashboard_recommendations_own_recommendations;

  /// Shows the number of recommendations in the last 24 hours
  ///
  /// In en, this message translates to:
  /// **'Last 24 hours: {count, plural, =0{0 recommendations} =1{1 recommendation} other{{count} recommendations}}'**
  String dashboard_recommendations_last_24_hours(int count);

  /// Shows the number of recommendations in the last 7 days
  ///
  /// In en, this message translates to:
  /// **'Last 7 days: {count, plural, =0{0 recommendations} =1{1 recommendation} other{{count} recommendations}}'**
  String dashboard_recommendations_last_7_days(int count);

  /// Shows the number of recommendations in the last month
  ///
  /// In en, this message translates to:
  /// **'Last month: {count, plural, =0{0 recommendations} =1{1 recommendation} other{{count} recommendations}}'**
  String dashboard_recommendations_last_month(int count);

  /// The title for the dashboard promoters widget
  ///
  /// In en, this message translates to:
  /// **'Number of Promoters'**
  String get dashboard_promoters_title;

  /// Error message when loading promoters fails
  ///
  /// In en, this message translates to:
  /// **'Loading promoters failed'**
  String get dashboard_promoters_loading_error_title;

  /// Shows the number of promoters in the last 7 days
  ///
  /// In en, this message translates to:
  /// **'Last 7 days: {count, plural, =0{0 promoters} =1{1 promoter} other{{count} promoters}}'**
  String dashboard_promoters_last_7_days(int count);

  /// Shows the number of promoters in the last month
  ///
  /// In en, this message translates to:
  /// **'Last month: {count, plural, =0{0 promoters} =1{1 promoter} other{{count} promoters}}'**
  String dashboard_promoters_last_month(int count);

  /// Shows the number of promoters in the last year
  ///
  /// In en, this message translates to:
  /// **'Last year: {count, plural, =0{0 promoters} =1{1 promoter} other{{count} promoters}}'**
  String dashboard_promoters_last_year(int count);

  /// Message when no promoters are found for the chart
  ///
  /// In en, this message translates to:
  /// **'No promoters found'**
  String get dashboard_promoters_chart_no_promoters;

  /// The field name for priority in recommendation edits
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get recommendation_manager_field_priority;

  /// The field name for notes in recommendation edits
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get recommendation_manager_field_notes;

  /// The connector word between multiple edited fields
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get recommendation_manager_field_connector;

  /// Message showing who edited which fields of a recommendation
  ///
  /// In en, this message translates to:
  /// **'{userName} has adjusted {fields}'**
  String recommendation_manager_edit_message(String userName, String fields);

  /// Button tooltip for sending feedback
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback_send_button;

  /// Error message when feedback title is missing
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get feedback_title_required;

  /// Error message when feedback title is too long
  ///
  /// In en, this message translates to:
  /// **'Title can be at most 100 characters long'**
  String get feedback_title_too_long;

  /// Error message when feedback description is missing
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get feedback_description_required;

  /// Error message when feedback description is too long
  ///
  /// In en, this message translates to:
  /// **'Description can be at most 1000 characters long'**
  String get feedback_description_too_long;

  /// Title of the feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get feedback_dialog_title;

  /// Tooltip for close button in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get feedback_dialog_close;

  /// Placeholder for title input field in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Enter title...'**
  String get feedback_title_placeholder;

  /// Placeholder for description input field in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Enter description...'**
  String get feedback_description_placeholder;

  /// Label for image upload area in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Images (optional, max. 3)'**
  String get feedback_images_label;

  /// Text for cancel button in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get feedback_cancel_button;

  /// Text for send button in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get feedback_send_dialog_button;

  /// Success message after sending feedback
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully!'**
  String get feedback_success_message;

  /// Placeholder for the email field in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Email address (optional)'**
  String get feedback_email_placeholder;

  /// Label for the category selection in feedback dialog
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get feedback_category_label;

  /// Title of EmptyPage when no feedback is available
  ///
  /// In en, this message translates to:
  /// **'No feedback found'**
  String get admin_feedback_no_feedback_title;

  /// Subtitle of EmptyPage when no feedback is available
  ///
  /// In en, this message translates to:
  /// **'It seems no user has left feedback yet.'**
  String get admin_feedback_no_feedback_subtitle;

  /// Button text to refresh the feedback list
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get admin_feedback_refresh_button;

  /// Title of ErrorView when loading feedback fails
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get admin_feedback_error_title;

  /// Title of confirmation dialog for deleting feedback
  ///
  /// In en, this message translates to:
  /// **'Delete feedback'**
  String get admin_feedback_delete_title;

  /// Message of confirmation dialog for deleting feedback
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this feedback? It cannot be restored afterwards.'**
  String get admin_feedback_delete_message;

  /// Button text to confirm deletion
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admin_feedback_delete_button;

  /// Button text to cancel deletion
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admin_feedback_cancel_button;

  /// Label for description in feedback tile
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get admin_feedback_description_label;

  /// Label for images in feedback tile
  ///
  /// In en, this message translates to:
  /// **'Images:'**
  String get admin_feedback_images_label;

  /// Title of the Admin Feedback List
  ///
  /// In en, this message translates to:
  /// **'User Feedback'**
  String get admin_feedback_list_title;

  /// Label for the type of feedback in the feedback tile
  ///
  /// In en, this message translates to:
  /// **'Type of feedback:'**
  String get admin_feedback_type_label;

  /// Label for the sender in the feedback tile
  ///
  /// In en, this message translates to:
  /// **'Sender:'**
  String get admin_feedback_sender_label;

  /// Dropdown option for all landing pages
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboard_recommendations_all_landingpages;

  /// Title for the dashboard recommendations filter popup
  ///
  /// In en, this message translates to:
  /// **'Filter Recommendations'**
  String get dashboard_recommendations_filter_title;

  /// Label for the period filter
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get dashboard_recommendations_filter_period;

  /// Label for the status filter
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashboard_recommendations_filter_status;

  /// Label for the promoter filter
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get dashboard_recommendations_filter_promoter;

  /// Label for the landing page filter
  ///
  /// In en, this message translates to:
  /// **'Landing Page'**
  String get dashboard_recommendations_filter_landingpage;

  /// Tooltip for the filter button
  ///
  /// In en, this message translates to:
  /// **'Open filter'**
  String get dashboard_recommendations_filter_tooltip;

  /// Title of the promoter ranking
  ///
  /// In en, this message translates to:
  /// **'Promoter Ranking'**
  String get dashboard_promoter_ranking_title;

  /// Label for the period filter
  ///
  /// In en, this message translates to:
  /// **'Period:'**
  String get dashboard_promoter_ranking_period;

  /// Title for error loading promoter ranking
  ///
  /// In en, this message translates to:
  /// **'Loading Error'**
  String get dashboard_promoter_ranking_loading_error_title;

  /// Error message when loading promoter ranking fails
  ///
  /// In en, this message translates to:
  /// **'The promoter ranking could not be loaded.'**
  String get dashboard_promoter_ranking_loading_error_message;

  /// Message when no promoters are found
  ///
  /// In en, this message translates to:
  /// **'No promoters found.'**
  String get dashboard_promoter_ranking_no_promoters;

  /// Message when no promoter data is available
  ///
  /// In en, this message translates to:
  /// **'No promoter data available.'**
  String get dashboard_promoter_ranking_no_data;

  /// Title for the landing page ranking
  ///
  /// In en, this message translates to:
  /// **'Landingpages Ranking'**
  String get dashboard_landingpage_ranking_title;

  /// Label for the period selection in the landing page ranking
  ///
  /// In en, this message translates to:
  /// **'Period:'**
  String get dashboard_landingpage_ranking_period;

  /// Error title when loading landing page ranking
  ///
  /// In en, this message translates to:
  /// **'Loading Error'**
  String get dashboard_landingpage_ranking_loading_error_title;

  /// Error message when loading landing page ranking
  ///
  /// In en, this message translates to:
  /// **'The landing page ranking could not be loaded.'**
  String get dashboard_landingpage_ranking_loading_error_message;

  /// Message when no landing pages are found
  ///
  /// In en, this message translates to:
  /// **'No landing pages found.'**
  String get dashboard_landingpage_ranking_no_landingpages;

  /// Message when no landing page data is available
  ///
  /// In en, this message translates to:
  /// **'No landing page data available.'**
  String get dashboard_landingpage_ranking_no_data;

  /// Title of the Admin Legals page
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get admin_legals_title;

  /// Label for AVV field
  ///
  /// In en, this message translates to:
  /// **'Data Processing Agreement'**
  String get admin_legals_avv_label;

  /// Placeholder for AVV text field
  ///
  /// In en, this message translates to:
  /// **'Enter DPA...'**
  String get admin_legals_avv_placeholder;

  /// Label for Privacy Policy field
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get admin_legals_privacy_policy_label;

  /// Placeholder for Privacy Policy text field
  ///
  /// In en, this message translates to:
  /// **'Enter Privacy Policy...'**
  String get admin_legals_privacy_policy_placeholder;

  /// Label for Terms field
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get admin_legals_terms_label;

  /// Placeholder for Terms text field
  ///
  /// In en, this message translates to:
  /// **'Enter Terms and Conditions...'**
  String get admin_legals_terms_placeholder;

  /// Label for Imprint field
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get admin_legals_imprint_label;

  /// Placeholder for Imprint text field
  ///
  /// In en, this message translates to:
  /// **'Enter Imprint...'**
  String get admin_legals_imprint_placeholder;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get admin_legals_save_button;

  /// Success message after saving
  ///
  /// In en, this message translates to:
  /// **'Legal data successfully saved!'**
  String get admin_legals_save_success;

  /// Link to Privacy Policy in footer
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footer_privacy_policy;

  /// Link to Imprint in footer
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get footer_imprint;

  /// Link to Terms & Conditions in footer
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get footer_terms_and_conditions;

  /// Text for the first dashboard quicklink - make recommendation
  ///
  /// In en, this message translates to:
  /// **'Have you made a recommendation today?'**
  String get dashboard_quicklink_recommendation_text;

  /// Button text for the first dashboard quicklink - make recommendation
  ///
  /// In en, this message translates to:
  /// **'Make a recommendation'**
  String get dashboard_quicklink_recommendation_button;

  /// Text for the second dashboard quicklink - recommendation manager
  ///
  /// In en, this message translates to:
  /// **'Have you checked your recommendations today?'**
  String get dashboard_quicklink_manager_text;

  /// Button text for the second dashboard quicklink - recommendation manager
  ///
  /// In en, this message translates to:
  /// **'Go to Recommendation Manager'**
  String get dashboard_quicklink_manager_button;

  /// Tooltip text for the info button in dashboard recommendations
  ///
  /// In en, this message translates to:
  /// **'Here you can see how many recommendations your promoters have sent in the selected time period.'**
  String get dashboard_recommendations_info_tooltip;

  /// Tooltip text for the info button in dashboard promoters
  ///
  /// In en, this message translates to:
  /// **'Here you can see how many promoters you have gained in the selected time period.'**
  String get dashboard_promoters_info_tooltip;

  /// Tooltip text for the info button in dashboard promoter ranking
  ///
  /// In en, this message translates to:
  /// **'This analysis shows you which promoters have generated the most successfully completed recommendations in the selected time period.'**
  String get dashboard_promoter_ranking_info_tooltip;

  /// Tooltip text for the info button in dashboard landing page ranking
  ///
  /// In en, this message translates to:
  /// **'This analysis shows you which of your landing pages have generated the most completed recommendations in the selected time period.'**
  String get dashboard_landingpage_ranking_info_tooltip;

  /// Tab title for personal data in profile
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get profile_general_tab;

  /// Tab title for company in profile
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get profile_company_tab;

  /// Tab title for change password in profile
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_password_tab;

  /// Tab title for delete account in profile
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profile_delete_tab;

  /// Title for contact option selection in LandingPage Creator
  ///
  /// In en, this message translates to:
  /// **'Select Contact Option'**
  String get landingpage_creator_contact_option_title;

  /// Info text for contact option selection in LandingPage Creator
  ///
  /// In en, this message translates to:
  /// **'Choose how interested parties can contact you.'**
  String get landingpage_creator_contact_option_info;

  /// Label for Calendly option
  ///
  /// In en, this message translates to:
  /// **'Calendly'**
  String get landingpage_creator_contact_option_calendly;

  /// Label for contact form option
  ///
  /// In en, this message translates to:
  /// **'Contact Form'**
  String get landingpage_creator_contact_option_form;

  /// Label for both options (Calendly + Contact Form)
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get landingpage_creator_contact_option_both;

  /// Button text for Calendly connection
  ///
  /// In en, this message translates to:
  /// **'Connect Calendly'**
  String get landingpage_creator_calendly_connect_button;

  /// Button text while Calendly connection is running
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get landingpage_creator_calendly_connecting;

  /// Button text for Calendly disconnection
  ///
  /// In en, this message translates to:
  /// **'Disconnect Calendly'**
  String get landingpage_creator_calendly_disconnect_button;

  /// Text when Calendly is successfully connected
  ///
  /// In en, this message translates to:
  /// **'Calendly account successfully connected'**
  String get landingpage_creator_calendly_connected;

  /// Label for Event Type dropdown
  ///
  /// In en, this message translates to:
  /// **'Select Calendly Event Type'**
  String get landingpage_creator_calendly_event_type_select;

  /// Validation message for Event Type selection
  ///
  /// In en, this message translates to:
  /// **'Please select an Event Type'**
  String get landingpage_creator_calendly_event_type_validation;

  /// Text while Event Types are loading
  ///
  /// In en, this message translates to:
  /// **'Loading Event Types...'**
  String get landingpage_creator_calendly_event_types_loading;

  /// Text when no Event Types were found
  ///
  /// In en, this message translates to:
  /// **'No Event Types found. Please create Event Types in your Calendly Dashboard.'**
  String get landingpage_creator_calendly_event_types_empty;

  /// Error message when Calendly is selected but not connected
  ///
  /// In en, this message translates to:
  /// **'Calendly must be connected before you can continue.'**
  String get landingpage_creator_calendly_must_be_connected_error;

  /// Success message after successful Calendly connection
  ///
  /// In en, this message translates to:
  /// **'Calendly successfully connected!'**
  String get calendly_success_connected;

  /// Success message after Calendly disconnection
  ///
  /// In en, this message translates to:
  /// **'Calendly successfully disconnected'**
  String get calendly_success_disconnected;

  /// Error message for Calendly connection problem
  ///
  /// In en, this message translates to:
  /// **'Error connecting to Calendly'**
  String get calendly_error_connection;

  /// Tab title for color selection in PageBuilder
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get pagebuilder_color_tab;

  /// Tab title for gradient selection in PageBuilder
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get pagebuilder_gradient_tab;

  /// Switch title for color selection in PageBuilder
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get pagebuilder_color_select;

  /// Switch title for gradient selection in PageBuilder
  ///
  /// In en, this message translates to:
  /// **'Select Gradient'**
  String get pagebuilder_gradient_select;

  /// Dialog title for color selection in gradient editor
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get pagebuilder_gradient_color_select;

  /// Label for gradient type selection
  ///
  /// In en, this message translates to:
  /// **'Type: '**
  String get pagebuilder_gradient_type_label;

  /// Name for linear gradient type
  ///
  /// In en, this message translates to:
  /// **'Linear'**
  String get pagebuilder_gradient_type_linear;

  /// Name for radial gradient type
  ///
  /// In en, this message translates to:
  /// **'Radial'**
  String get pagebuilder_gradient_type_radial;

  /// Name for sweep gradient type
  ///
  /// In en, this message translates to:
  /// **'Sweep'**
  String get pagebuilder_gradient_type_sweep;

  /// Label for color list in gradient editor
  ///
  /// In en, this message translates to:
  /// **'Colors:'**
  String get pagebuilder_gradient_colors_label;

  /// Button text to add a new color to the gradient
  ///
  /// In en, this message translates to:
  /// **'Add Color'**
  String get pagebuilder_gradient_add_color;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get pagebuilder_ok;

  /// Placeholder text for section name input field
  ///
  /// In en, this message translates to:
  /// **'Section name'**
  String get pagebuilder_section_id_placeholder;

  /// Error message when section name is empty
  ///
  /// In en, this message translates to:
  /// **'Section name cannot be empty'**
  String get pagebuilder_section_name_error_empty;

  /// Error message when section name is too long
  ///
  /// In en, this message translates to:
  /// **'Section name cannot exceed 50 characters'**
  String get pagebuilder_section_name_error_too_long;

  /// Error message when section name is duplicate
  ///
  /// In en, this message translates to:
  /// **'Section ID already exists'**
  String get pagebuilder_section_name_error_duplicate;

  /// Title for section visibility configuration in Pagebuilder Config Menu
  ///
  /// In en, this message translates to:
  /// **'Visible on'**
  String get pagebuilder_section_visible_on_title;

  /// Label for Desktop checkbox in section visibility configuration
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get pagebuilder_section_visible_on_desktop;

  /// Label for Tablet checkbox in section visibility configuration
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get pagebuilder_section_visible_on_tablet;

  /// Label for Mobile checkbox in section visibility configuration
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get pagebuilder_section_visible_on_mobile;

  /// Tooltip for Undo button in Pagebuilder Appbar
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get pagebuilder_undo_tooltip;

  /// Tooltip for Redo button in Pagebuilder Appbar
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get pagebuilder_redo_tooltip;

  /// Title for the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Elements'**
  String get pagebuilder_page_menu_title;

  /// Name of the Text widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get pagebuilder_widget_template_text;

  /// Name of the Image widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get pagebuilder_widget_template_image;

  /// Name of the Container widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Container'**
  String get pagebuilder_widget_template_container;

  /// Name of the Icon widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get pagebuilder_widget_template_icon;

  /// Name of the Video widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get pagebuilder_widget_template_video;

  /// Name of the Contact Form widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Contact Form'**
  String get pagebuilder_widget_template_contact_form;

  /// Name of the Anchor Button widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Anchor Button'**
  String get pagebuilder_widget_template_anchor_button;

  /// Name of the Calendly widget template in the Pagebuilder widget menu
  ///
  /// In en, this message translates to:
  /// **'Calendly'**
  String get pagebuilder_widget_template_calendly;

  /// Label for color selection in the HTML text editor
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get pagebuilder_html_text_editor_select_color;

  /// Placeholder text in the HTML text editor
  ///
  /// In en, this message translates to:
  /// **'Enter text...'**
  String get pagebuilder_html_text_editor_hint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
