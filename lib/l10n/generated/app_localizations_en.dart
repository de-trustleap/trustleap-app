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
  String get register_code => 'Registration code';

  @override
  String get register_now_buttontitle => 'Rgister now';

  @override
  String get register_invalid_code_error => 'Registration failed. Please check whether you are using a valid code and the associated email address.';

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
  String get login_password_forgotten_text => 'Do you have your ';

  @override
  String get login_password_forgotten_linktext => 'Password forgotten?';

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
  String get auth_validation_invalid_date => 'The entered date is invalid.';

  @override
  String get auth_validation_invalid_postcode => 'the postcode is invalid';

  @override
  String get auth_validation_missing_code => 'Please enter your registration code';

  @override
  String get auth_validation_missing_gender => 'Please indicate your gender';

  @override
  String get auth_validation_missing_additional_info => 'reason for recommendation is missing';

  @override
  String get auth_validation_additional_info_exceed_limit => 'You exceeded the maximal amount of 500 characters';

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

  @override
  String get auth_failure_email_already_in_use => 'The email adress is already taken.';

  @override
  String get auth_failure_invalid_email => 'The email address is invalid';

  @override
  String get auth_failure_weak_password => 'The password is too weak. Please use at least 6 characters.';

  @override
  String get auth_failure_user_disabled => 'The user does not exist anymore. Please contact our support team for further investigation.';

  @override
  String get auth_failure_user_not_found => 'The user does not exist.';

  @override
  String get auth_failure_wrong_password => 'The entered password is not correct.';

  @override
  String get auth_failure_invalid_credentials => 'Your entered credentials do not exist.';

  @override
  String get auth_failure_too_many_requests => 'You have entered your login details incorrectly too many times. Try again later.';

  @override
  String get auth_failure_user_mismatch => 'Your login information does not belong to the current user.';

  @override
  String get auth_failure_invalid_verification_code => 'Your verification code is invalid.';

  @override
  String get auth_failure_invalid_verification_id => 'Your verification id is invalid.';

  @override
  String get auth_failure_requires_recent_login => 'Its been too long since you last logged in. Sign in again.';

  @override
  String get auth_failure_missing_password => 'You have to type in your password.';

  @override
  String get auth_failure_unknown => 'An unknown error occured.';

  @override
  String get database_failure_permission_denied => 'Permission denied to access these resources.';

  @override
  String get database_failure_not_found => 'The requested data was not found.';

  @override
  String get database_failure_already_exists => 'the data already exists.';

  @override
  String get database_failure_deadline_exceeded => 'Data retrieval takes too long. Try again later.';

  @override
  String get database_failure_cancelled => 'The operation has been cancelled.';

  @override
  String get database_failure_unavailable => 'The service is currently unavailable.';

  @override
  String get database_failure_unknown => 'An unknown error occured.';

  @override
  String get storage_failure_object_not_found => 'Image not found.';

  @override
  String get storage_failure_not_authenticated => 'You are not logged in. Please login and try again.';

  @override
  String get storage_failure_not_authorized => 'You are not permitted to do this.';

  @override
  String get storage_failure_retry_limit_exceeded => 'There seems to be a problem. The action is taking longer than usual. Please try again later.';

  @override
  String get storage_failure_unknown => 'An unknown error occured. Please try again later.';

  @override
  String get password_forgotten_title => 'Reset password';

  @override
  String get password_forgotten_description => 'Please enter your email address and confirm. A link will then be sent to the email address you provided. You can use this link to reset your password.';

  @override
  String get password_forgotten_success_dialog_title => 'Password reset succeeded';

  @override
  String get password_forgotten_success_dialog_description => 'An email has been sent to the email address provided. You can set your new password using the link in the email.';

  @override
  String get password_forgotten_success_dialog_ok_button_title => 'Back to Login';

  @override
  String get password_forgotten_button_title => 'Reset password';

  @override
  String get password_forgotten_email_textfield_placeholder => 'email address';

  @override
  String get general_error_view_refresh_button_title => 'Try again';

  @override
  String get profile_page_email_section_email => 'E-Mail';

  @override
  String get profile_page_email_section_status => 'Status';

  @override
  String get profile_page_email_section_description => 'Now enter your new email address and confirm. A confirmation link will then be sent to the new email address. You can use this link to verify your new email address and log in again.';

  @override
  String get profile_page_email_section_change_email_button_title => 'Change email address';

  @override
  String get profile_page_email_section_change_email_password_description => 'Please enter your password if you would like to change your email address.';

  @override
  String get profile_page_email_section_change_email_password_continue_button_title => 'Continue';

  @override
  String get profile_page_email_section_resend_verify_email_button_title => 'Resend link for email verification';

  @override
  String get profile_page_email_section_title => 'E-Mail Settings';

  @override
  String get profile_page_email_section_verification_badge_verified => 'Verified';

  @override
  String get profile_page_email_section_verification_badge_unverified => 'Unverifiziert';

  @override
  String get profile_page_image_section_validation_exceededFileSize => 'You have exceeded the maximum allowed size of 5 MB';

  @override
  String get profile_page_image_section_validation_not_valid => 'The image format is invalid';

  @override
  String get profile_page_image_section_only_one_allowed => 'You can only upload one image at a time';

  @override
  String get profile_page_image_section_upload_not_found => 'The image to upload was not found';

  @override
  String get profile_page_image_section_large_image_view_close_button_tooltip_title => 'Close';

  @override
  String get profile_page_password_update_section_title => 'Change password';

  @override
  String get profile_page_password_update_section_new_password_description => 'Please enter your new password and confirm it. You will then be logged out and you can log in with the new password.';

  @override
  String get profile_page_password_update_section_new_password_textfield_placeholder => 'New password';

  @override
  String get profile_page_password_update_section_new_password_repeat_textfield_placeholder => 'Repeat new password';

  @override
  String get profile_page_password_update_section_new_password_confirm_button_text => 'Change password';

  @override
  String get profile_page_password_update_section_reauth_description => 'Please enter your current password so that you can create a new password.';

  @override
  String get profile_page_password_update_section_reauth_password_textfield_placeholder => 'Password';

  @override
  String get profile_page_password_update_section_reauth_continue_button_title => 'Weiter';

  @override
  String get profile_page_contact_section_title => 'Contact Information';

  @override
  String get profile_page_contact_section_form_firstname => 'first name';

  @override
  String get profile_page_contact_section_form_lastname => 'last name';

  @override
  String get profile_page_contact_section_form_address => 'address';

  @override
  String get profile_page_contact_section_form_postcode => 'postcode';

  @override
  String get profile_page_contact_section_form_place => 'place';

  @override
  String get profile_page_contact_section_form_save_button_title => 'Save changes';

  @override
  String get profile_page_snackbar_image_changed_message => 'You have successfully customized the profile picture.';

  @override
  String get profile_page_snackbar_contact_information_changes => 'The change to your contact information was successful.';

  @override
  String get profile_page_snackbar_email_verification => 'A link for email verification has been sent to you.';

  @override
  String get profile_page_logout_button_title => 'Logout';

  @override
  String get profile_page_request_failure_message => 'An error occurred while retrieving the data.';

  @override
  String get profile_page_promoters_section_title => 'Promoter';

  @override
  String get profile_page_promoters_section_recommender_count => 'Number of promoters:';

  @override
  String get gender_picker_choose => 'Choose your gender';

  @override
  String get gender_picker_not_choosen => 'Not choosen';

  @override
  String get gender_picker_male => 'Male';

  @override
  String get gender_picker_female => 'Female';

  @override
  String get register_promoter_email_already_in_use => 'The email address already exists for another user.';

  @override
  String get register_promoter_title => 'Register promoter';

  @override
  String get register_promoter_first_name => 'firstname';

  @override
  String get register_promoter_last_name => 'lastname';

  @override
  String get register_promoter_birthdate => 'birthdate';

  @override
  String get register_promoter_email => 'email address';

  @override
  String get register_promoter_additional_info => 'reason for the recommendation';

  @override
  String get register_promoter_register_button => 'Register';

  @override
  String get register_promoter_snackbar_success => 'The new promoter has been successfully registered!';

  @override
  String get promoter_overview_title => 'My promoter';

  @override
  String get promoter_overview_search_placeholder => 'Search...';

  @override
  String get promoter_overview_filter_show_all => 'Show all';

  @override
  String get promoter_overview_filter_show_registered => 'Show registered';

  @override
  String get promoter_overview_filter_show_unregistered => 'Show unregistered';

  @override
  String get promoter_overview_filter_sortby_choose => 'Sort by';

  @override
  String get promoter_overview_filter_sortby_date => 'creation date';

  @override
  String get promoter_overview_filter_sortby_firstname => 'firstname';

  @override
  String get promoter_overview_filter_sortby_lastname => 'lastname';

  @override
  String get promoter_overview_filter_sortby_email => 'email address';

  @override
  String get promoter_overview_filter_sortorder_asc => 'Ascending';

  @override
  String get promoter_overview_filter_sortorder_desc => 'Descending';

  @override
  String get promoter_overview_no_search_results_title => 'No search results';

  @override
  String get promoter_overview_no_search_results_subtitle => 'You don\'t seem to have registered any promoters with the name you\'re looking for yet.\nChange your search term to search for other promoters.';

  @override
  String get promoter_overview_registration_badge_registered => 'Registered';

  @override
  String get promoter_overview_registration_badge_unregistered => 'Not registered';

  @override
  String get promoter_overview_empty_page_title => 'No promoter found';

  @override
  String get promoter_overview_empty_page_subtitle => 'You dont seem to have any promoters registered yet. Register your promoters now to win your first new customers.';

  @override
  String get promoter_overview_empty_page_button_title => 'Register promoter';

  @override
  String get promoter_overview_error_view_title => 'An error occurred while retrieving the data.';

  @override
  String promoter_overview_expiration_date(String date) {
    return 'expires at $date';
  }

  @override
  String promoter_overview_creation_date(String date) {
    return 'Member since $date';
  }
}
