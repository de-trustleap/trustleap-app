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

  /// Text for Creating Landing Page
  ///
  /// In en, this message translates to:
  /// **'Create Landing Page'**
  String get landingpage_create_txt;

  /// Description for the promotion template textfield on the create landingpage form
  ///
  /// In en, this message translates to:
  /// **'Below you can create a template that your promoters will use to send recommendations via WhatsApp.\nYou can use the placeholder \$name to display the name of the recommendation recipient.'**
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

  /// Error message when no image has been uploaded.
  ///
  /// In en, this message translates to:
  /// **'Please upload an image'**
  String get error_msg_pleace_upload_picture;

  /// the menu entry for the activities
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get menuitems_activities;

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
  String get profile_page_email_section_change_email_password_continue_button_title;

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
  String get profile_page_image_section_large_image_view_close_button_tooltip_title;

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
  String get profile_page_password_update_section_new_password_textfield_placeholder;

  /// placeholder for the new password repeat text field on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Repeat new password'**
  String get profile_page_password_update_section_new_password_repeat_textfield_placeholder;

  /// button title for the confirm password change button on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profile_page_password_update_section_new_password_confirm_button_text;

  /// Description for reauthentication on the Change Password page in the Profile page.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password so that you can create a new password.'**
  String get profile_page_password_update_section_reauth_description;

  /// Placeholder for the password text field of the reauthentication on the change password page in the profile page.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profile_page_password_update_section_reauth_password_textfield_placeholder;

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

  /// title of the promoter section on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Promoter'**
  String get profile_page_promoters_section_title;

  /// Number of promoters in the promoter area on the profile page.
  ///
  /// In en, this message translates to:
  /// **'Number of promoters:'**
  String get profile_page_promoters_section_recommender_count;

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

  /// The birthdate placeholder in the text field of the promoter register form
  ///
  /// In en, this message translates to:
  /// **'birthdate'**
  String get register_promoter_birthdate;

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

  /// Bezeichnung über dem phone Textfeld der Kontakt Sektion im Unternehmens Tab auf der Profilseite
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profile_company_contact_section_phone;

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
