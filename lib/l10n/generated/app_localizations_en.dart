import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get register_title => 'Register';

  @override
  String get register_subtitle => 'Registriere now to use our service.';

  @override
  String get register_firstname => 'firstname';

  @override
  String get register_lastname => 'lastname';

  @override
  String get register_birthdate => 'birthdate';

  @override
  String get register_address => 'address (optional)';

  @override
  String get register_postcode => 'postcode (optional)';

  @override
  String get register_place => 'place (optional)';

  @override
  String get register_email => 'email address';

  @override
  String get register_password => 'password';

  @override
  String get register_repeat_password => 'confirm password';

  @override
  String get register_now_buttontitle => 'Rgister now';

  @override
  String get login_title => 'Welcome';

  @override
  String get login_subtitle => 'Please login or register.';

  @override
  String get login_email => 'email address';

  @override
  String get login_password => 'password';

  @override
  String get login_login_buttontitle => 'Login';

  @override
  String get login_register_linktitle => 'Register now';

  @override
  String get login_register_text => 'You don\'\'t have an account? ';

  @override
  String get auth_validation_missing_email => 'Please enter an email address';

  @override
  String get auth_validation_invalid_email => 'Invalid email address';

  @override
  String get auth_validation_missing_password => 'Please enter a password';

  @override
  String get auth_validation_confirm_password => 'Please confirm the password';

  @override
  String get auth_validation_matching_passwords => 'The passwords don\'\'t match';

  @override
  String get auth_validation_missing_firstname => 'Please enter firstname';

  @override
  String get auth_validation_long_firstname => 'The entered firstname is too long';

  @override
  String get auth_validation_missing_lastname => 'Please enter lastname';

  @override
  String get auth_validation_long_lastname => 'The entered lastname is too long';

  @override
  String get auth_validation_missing_birthdate => 'Please enter birthdate';

  @override
  String get auth_validation_invalid_birthdate => 'You must be 18 or older';

  @override
  String get authfailure_email_already_in_use => 'The email address is already in use.';

  @override
  String get authfailure_invalid_email => 'The entered email adress is invalid.';

  @override
  String get authfailure_weak_password => 'The entered password is too weak. Please use at least 6 characters.';

  @override
  String get authfailure_user_disabled => 'The user is disabled.';

  @override
  String get authfailure_user_not_found => 'The user doesn\'\'t exist.';

  @override
  String get authfailure_wrong_password => 'The entered password is wrong.';

  @override
  String get authfailure_invalid_credentials => 'Your credentials are invalid.';

  @override
  String get authfailure_too_many_requests => 'You have entered your login details incorrectly too many times. Try again later.';

  @override
  String get authfailure_unknown => 'An unknown error occured.';

  @override
  String get menuitems_profile => 'Profile';

  @override
  String get menuitems_dashboard => 'Dashboard';

  @override
  String get menuitems_recommendations => 'Recommendations';

  @override
  String get menuitems_promoters => 'Promoter';

  @override
  String get menuitems_landingpage => 'Landingpage';

  @override
  String get menuitems_activities => 'Activities';
}
