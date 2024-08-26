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
  String get delete_buttontitle => 'delete';

  @override
  String get cancel_buttontitle => 'cancel';

  @override
  String get changes_save_button_title => 'save changes';

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
  String get landingpage_overview_title => 'Landing pages overview';

  @override
  String get menuitems_landingpage => 'Landingpage';

  @override
  String get menuitems_company_requests => 'Requests';

  @override
  String get landingpage_overview_error_view_title => 'An error occurred while retrieving the data.';

  @override
  String get landingpage_overview_empty_page_title => 'No landingpage found';

  @override
  String get landingpage_overview_empty_page_subtitle => 'Seems like you dont have a landing page yet. Create your landing page now.';

  @override
  String get landingpage_overview_empty_page_button_title => 'Register Landing Page';

  @override
  String get landingpage_delete_alert_title => 'Do you really want to delete the selected landing page?';

  @override
  String get landingpage_delete_alert_msg => 'Deleting the landing page cannot be undone.';

  @override
  String get landingpage_success_delete_snackbar_message => 'Landing page successfully deleted!';

  @override
  String get landingpage_snackbar_success => 'The landing page was successfully created!';

  @override
  String get landingpage_snackbar_success_changed => 'The landing page was successfully changed!';

  @override
  String get landingpage_snackbar_success_duplicated => 'The landing page was successfully duplicated!';

  @override
  String get landingpage_overview_max_count_msg => 'Maximum number of landing pages reached';

  @override
  String get landingpage_create_buttontitle => 'Create Landing Page';

  @override
  String get landingpage_validate_LandingPageName => 'Please enter a name!';

  @override
  String get landingpage_validate_LandingPageText => 'Please enter text!';

  @override
  String get landingpage_create_txt => 'Create Landing Page';

  @override
  String get landingpage_create_promotion_template_description => 'Below you can create a template that your promoters will use to send recommendations via WhatsApp.\nYou can use the placeholder \$name to display the name of the recommendation recipient.';

  @override
  String get landingpage_create_promotion_template_placeholder => 'Template for promoter (optional)';

  @override
  String get landingpage_create_promotion_template_default_text => 'This is the promotion template.';

  @override
  String get emoji_search_placeholder => 'Search Emoji';

  @override
  String get landingpage_overview_context_menu_delete => 'Delete';

  @override
  String get landingpage_overview_context_menu_duplicate => 'Duplicate';

  @override
  String get placeholder_title => 'Title';

  @override
  String get placeholder_description => 'Description';

  @override
  String get error_msg_pleace_upload_picture => 'Please upload an image';

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
  String get profile_page_snackbar_company_registered => 'The request for the company registration has been sent succesful.';

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
  String get register_promoter_no_landingpage_title => 'You have not created a landing page yet';

  @override
  String get register_promoter_no_landingpage_subtitle => 'In order to create a new promoter it is necessary to have an active landing page.';

  @override
  String get register_promoter_missing_landingpage_error_message => 'The promoter has not yet been assigned a landing page';

  @override
  String get register_promoter_missing_company_error_message => 'You cannot register a promoter because you are not affiliated with any company';

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

  @override
  String get delete_account_title => 'Delete account';

  @override
  String get delete_account_subtitle => 'Once your account is deleted, your data will remain with us for 30 days. During this time you can still contact support to reverse the deletion. Your data will then be irrevocably deleted.\n\nPlease enter your password to delete the account.';

  @override
  String get delete_account_password_placeholder => 'Password';

  @override
  String get delete_account_button_title => 'Delete account';

  @override
  String get delete_account_confirmation_alert_title => 'Really delete your account?';

  @override
  String get delete_account_confirmation_alert_message => 'Are you sure you want to delete your account?';

  @override
  String get delete_account_confirmation_alert_ok_button_title => 'Delete account';

  @override
  String get delete_account_confirmation_alert_cancel_button_title => 'Cancel';

  @override
  String get recommendations_choose_reason_placeholder => 'Choose a reason';

  @override
  String get recommendations_choose_reason_not_chosen => 'Not chosen';

  @override
  String get recommendations_title => 'Generate recommendations';

  @override
  String get recommendations_form_promoter_placeholder => 'Promoter';

  @override
  String get recommendations_form_service_provider_placeholder => 'Service provider';

  @override
  String get recommendations_form_recommendation_name_placeholder => 'Recommendation name';

  @override
  String get recommendations_form_generate_recommendation_button_title => 'Generate recommendations';

  @override
  String get recommendations_error_view_title => 'An error occurred while retrieving the data';

  @override
  String get recommendations_validation_missing_lead_name => 'Please enter a name';

  @override
  String get recommendations_validation_missing_promoter_name => 'Please enter a name';

  @override
  String get recommendations_validation_missing_reason => 'Please enter a reason';

  @override
  String get profile_company_contact_section_title => 'Company Information';

  @override
  String get profile_company_contact_section_name => 'Company name';

  @override
  String get profile_company_contact_section_industry => 'Industry';

  @override
  String get profile_company_contact_section_website => 'Website';

  @override
  String get profile_company_contact_section_address => 'Address';

  @override
  String get profile_company_contact_section_postcode => 'Postcode';

  @override
  String get profile_company_contact_section_place => 'Place';

  @override
  String get profile_company_contact_section_phone => 'Phone';

  @override
  String get profile_company_validator_missing_name => 'Please enter the company name';

  @override
  String get profile_company_validator_missing_industry => 'Please enter the industry';

  @override
  String get profile_company_validator_invalid_phone => 'The phone number is invalid';

  @override
  String get profile_company_validator_missing_address => 'Please enter the address';

  @override
  String get profile_company_validator_missing_postCode => 'Please enter a postcode';

  @override
  String get profile_company_validator_invalid_postCode => 'The postcode is invalid';

  @override
  String get profile_company_validator_missing_place => 'Please enter a place';

  @override
  String get profile_company_validator_missing_phone => 'Please enter a phone number';

  @override
  String get profile_company_contact_section_success_snackbar_message => 'Company information changed successfully';

  @override
  String get company_requests_overview_title => 'Company Registration Requests';

  @override
  String get admin_company_request_detail_title => 'Request';

  @override
  String get admin_company_request_detail_name => 'Company name:';

  @override
  String get admin_company_request_detail_industry => 'Industry:';

  @override
  String get admin_company_request_detail_address => 'Address:';

  @override
  String get admin_company_request_detail_postcode => 'Postcode:';

  @override
  String get admin_company_request_detail_place => 'Place:';

  @override
  String get admin_company_request_detail_phone => 'Phone:';

  @override
  String get admin_company_request_detail_website => 'Website:';

  @override
  String get admin_company_request_detail_user_title => 'User';

  @override
  String get admin_company_request_detail_user_name => 'Name:';

  @override
  String get admin_company_request_detail_user_email => 'Email Address:';

  @override
  String get admin_company_request_detail_decline_button_title => 'Decline request';

  @override
  String get admin_company_request_detail_accept_button_title => 'Accept request';

  @override
  String get admin_company_request_overview_from_user => 'from: ';

  @override
  String get admin_company_request_overview_empty_title => 'There are no requests';

  @override
  String get admin_company_request_overview_empty_body => 'There dont appear to be any registration requests from companies at this time.';

  @override
  String get admin_company_request_overview_title => 'Requests for company registrations';

  @override
  String get admin_company_request_overview_error => 'There was an error';

  @override
  String get company_registration_form_title => 'Register company';

  @override
  String get company_registration_form_name_textfield_placeholder => 'Company name';

  @override
  String get company_registration_form_industry_textfield_placeholder => 'Industry';

  @override
  String get company_registration_form_website_textfield_placeholder => 'Website (optional)';

  @override
  String get company_registration_form_address_textfield_placeholder => 'Address';

  @override
  String get company_registration_form_postcode_textfield_placeholder => 'Postcode';

  @override
  String get company_registration_form_place_textfield_placeholder => 'Place';

  @override
  String get company_registration_form_phone_textfield_placeholder => 'Phone';

  @override
  String get company_registration_form_register_button_title => 'Register now';

  @override
  String get profile_register_company_section_title => 'Company registration';

  @override
  String get profile_register_company_section_subtitle_in_progress => 'Your request is being processed.\nThe processing time is on average 7 days.';

  @override
  String get profile_register_company_section_subtitle_requested_at => 'Requested at ';

  @override
  String get profile_register_company_section_subtitle => 'Register your company now to take advantage of the apps additional benefits.';

  @override
  String get profile_register_company_section_button_title => 'Go to registration';

  @override
  String get profile_image_upload_tooltip => 'Upload image';

  @override
  String get landingpage_overview_edit_tooltip => 'Edit landingpage';

  @override
  String get profile_edit_email_tooltip => 'Change email address';

  @override
  String get theme_switch_lightmode_tooltip => 'Lightmode';

  @override
  String get theme_switch_darkmode_tooltip => 'Darkmode';

  @override
  String get promoter_overview_reset_search_tooltip => 'Reset search';

  @override
  String get promoter_overview_filter_tooltip => 'Filter promoters';

  @override
  String get promoter_overview_view_switch_grid_tooltip => 'Grid view';

  @override
  String get promoter_overview_view_switch_table_tooltip => 'List view';

  @override
  String get recommendations_form_add_button_tooltip => 'Add recommendation';
}
