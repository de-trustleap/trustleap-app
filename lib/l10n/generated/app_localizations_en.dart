// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get register_invalid_code_error =>
      'Registration failed. Please check whether you are using a valid code and the associated email address.';

  @override
  String get register_terms_and_condition_text => 'I approve the';

  @override
  String get register_terms_and_condition_link => 'Terms and condition';

  @override
  String get register_terms_and_condition_text2 => '';

  @override
  String get register_privacy_policy_text => 'I approve the';

  @override
  String get register_privacy_policy_link => 'Privacy policy';

  @override
  String get register_privacy_policy_text2 => '';

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
  String get login_permission_error_message =>
      'An error occurred while querying the permissions';

  @override
  String get auth_validation_missing_email => 'Please enter an email address';

  @override
  String get auth_validation_invalid_email => 'Invalid email address';

  @override
  String get auth_validation_missing_password => 'Please enter a password';

  @override
  String get auth_validation_confirm_password => 'Please confirm the password';

  @override
  String get auth_validation_matching_passwords =>
      'The passwords don\'\'t match';

  @override
  String get auth_validation_missing_firstname => 'Please enter firstname';

  @override
  String get auth_validation_long_firstname =>
      'The entered firstname is too long';

  @override
  String get auth_validation_missing_lastname => 'Please enter lastname';

  @override
  String get auth_validation_long_lastname =>
      'The entered lastname is too long';

  @override
  String get auth_validation_missing_birthdate => 'Please enter birthdate';

  @override
  String get auth_validation_invalid_birthdate => 'You must be 18 or older';

  @override
  String get auth_validation_invalid_date => 'The entered date is invalid.';

  @override
  String get auth_validation_invalid_postcode => 'the postcode is invalid';

  @override
  String get auth_validation_missing_code =>
      'Please enter your registration code';

  @override
  String get auth_validation_missing_gender => 'Please indicate your gender';

  @override
  String get auth_validation_missing_additional_info =>
      'reason for recommendation is missing';

  @override
  String get auth_validation_additional_info_exceed_limit =>
      'You exceeded the maximal amount of 500 characters';

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
  String get menuitems_recommendation_manager => 'Recommendation Manager';

  @override
  String get menuitems_registration_codes => 'Codes';

  @override
  String get menuitems_user_feedback => 'User Feedback';

  @override
  String get menuitems_legals => 'Legal';

  @override
  String get landingpage_overview_error_view_title =>
      'An error occurred while retrieving the data.';

  @override
  String get landingpage_overview_empty_page_title => 'No landingpage found';

  @override
  String get landingpage_overview_empty_page_subtitle =>
      'Seems like you dont have a landing page yet. Create your landing page now.';

  @override
  String get landingpage_overview_empty_page_button_title =>
      'Register Landing Page';

  @override
  String get landingpage_overview_pending_tooltip =>
      'The page is currently being created. Please wait...';

  @override
  String get landingpage_delete_alert_title =>
      'Do you really want to delete the selected landing page?';

  @override
  String get landingpage_delete_alert_msg =>
      'Deleting the landing page cannot be undone.';

  @override
  String get landingpage_delete_alert_msg_promoter_warning =>
      'The following promoters will no longer have active landing pages assigned if you delete this page:\n';

  @override
  String get landingpage_delete_alert_msg_promoter_warning_continue =>
      '\nDo you want to continue anyway? The action cannot be undone.';

  @override
  String get landingpage_success_delete_snackbar_message =>
      'Landing page successfully deleted!';

  @override
  String get landingpage_snackbar_success =>
      'The landing page was successfully created!';

  @override
  String get landingpage_snackbar_success_changed =>
      'The landing page was successfully changed!';

  @override
  String get landingpage_snackbar_success_duplicated =>
      'The landing page was successfully duplicated!';

  @override
  String get landingpage_snackbar_success_toggled_enabled =>
      'The landing page was successfully enabled!';

  @override
  String get landingpage_snackbar_success_toggled_disabled =>
      'The landing page was successfully disabled!';

  @override
  String get landingpage_snackbar_failure_toggled =>
      'An error occurred while toggle the landing page';

  @override
  String get landingpage_overview_context_menu_disable => 'disable';

  @override
  String get landingpage_overview_context_menu_enable => 'enable';

  @override
  String get landingpage_overview_max_count_msg =>
      'Maximum number of landing pages reached';

  @override
  String get landingpage_create_buttontitle => 'Create Landing Page';

  @override
  String get landingpage_validate_LandingPageName => 'Please enter a name!';

  @override
  String get landingpage_validate_LandingPageText => 'Please enter text!';

  @override
  String get landingpage_validate_impressum => 'Please enter impressum';

  @override
  String get landingpage_validate_privacy_policy =>
      'Please enter privacy policy';

  @override
  String get landingpage_validate_initial_information =>
      'Please enter initial information';

  @override
  String landingpage_creation_progress_indicator_text(
      int currentStep, int elementsTotal) {
    return 'Step $currentStep of $elementsTotal';
  }

  @override
  String get landingpage_creation_impressum_placeholder => 'Impressum';

  @override
  String get landingpage_creation_privacy_policy_placeholder =>
      'Privacy policy';

  @override
  String get landingpage_creation_initial_information_placeholder =>
      'Initial information (optional)';

  @override
  String get landingpage_creation_terms_and_conditions_placeholder =>
      'Terms and conditions (optional)';

  @override
  String get landingpage_creation_scripts_description =>
      'Javascript <script> tags can be entered below.\nThis is used, for example, to integrate cookie banners or tracking tools into the landing page.';

  @override
  String get landingpage_creation_scripts_placeholder =>
      'Script tags (optional)';

  @override
  String get landingpage_creation_back_button_text => 'Back';

  @override
  String get landingpage_creation_edit_button_text => 'Edit Landingpage';

  @override
  String get landingpage_create_txt => 'Create Landing Page';

  @override
  String get landingpage_creation_continue => 'Continue';

  @override
  String get landingpage_create_promotion_template_description =>
      'Below you can create a template that your promoters will use to send recommendations via WhatsApp.\nYou can use different placeholders which you can choose from the placeholder menu.';

  @override
  String get landingpage_create_promotion_template_placeholder =>
      'Template for promoter (optional)';

  @override
  String get landingpage_create_promotion_template_default_text =>
      'This is the promotion template.';

  @override
  String get emoji_search_placeholder => 'Search Emoji';

  @override
  String get open_emoji_picker_tooltip => 'Open emoji picker';

  @override
  String get landingpage_create_promotion_placeholder_menu =>
      'Choose placeholder';

  @override
  String
      get landingpage_create_promotion_placeholder_service_provider_first_name =>
          'First name of provider';

  @override
  String
      get landingpage_create_promotion_placeholder_service_provider_last_name =>
          'Last name of provider';

  @override
  String get landingpage_create_promotion_placeholder_service_provider_name =>
      'Name of provider';

  @override
  String get landingpage_create_promotion_placeholder_promoter_first_name =>
      'First name of promoter';

  @override
  String get landingpage_create_promotion_placeholder_promoter_last_name =>
      'Last name of promoter';

  @override
  String get landingpage_create_promotion_placeholder_promoter_name =>
      'Name of promoter';

  @override
  String get landingpage_create_promotion_placeholder_receiver_name =>
      'Name of receiver';

  @override
  String get landingpage_overview_context_menu_delete => 'Delete';

  @override
  String get landingpage_overview_context_menu_duplicate => 'Duplicate';

  @override
  String get placeholder_title => 'Title';

  @override
  String get placeholder_description => 'Description';

  @override
  String get landingpage_creator_placeholder_contact_email =>
      'Contact email address';

  @override
  String get landingpage_creator_business_model_title => 'Business Model';

  @override
  String get landingpage_creator_business_model_b2b_label => 'B2B';

  @override
  String get landingpage_creator_business_model_b2c_label => 'B2C';

  @override
  String get landingpage_creator_business_model_info_tooltip =>
      'Choose whether your customers are B2B (business customers) or B2C (end consumers). This is important to embed a disclaimer on the landing page in case of B2B customers.\\nIf you address both business customers and end consumers, choose B2C.';

  @override
  String get error_msg_pleace_upload_picture => 'Please upload an image';

  @override
  String get auth_failure_email_already_in_use =>
      'The email adress is already taken.';

  @override
  String get auth_failure_invalid_email => 'The email address is invalid';

  @override
  String get auth_failure_weak_password =>
      'The password is too weak. Please use at least 6 characters.';

  @override
  String get auth_failure_user_disabled =>
      'The user does not exist anymore. Please contact our support team for further investigation.';

  @override
  String get auth_failure_user_not_found => 'The user does not exist.';

  @override
  String get auth_failure_wrong_password =>
      'The entered password is not correct.';

  @override
  String get auth_failure_invalid_credentials =>
      'Your entered credentials do not exist.';

  @override
  String get auth_failure_too_many_requests =>
      'You have entered your login details incorrectly too many times. Try again later.';

  @override
  String get auth_failure_user_mismatch =>
      'Your login information does not belong to the current user.';

  @override
  String get auth_failure_invalid_verification_code =>
      'Your verification code is invalid.';

  @override
  String get auth_failure_invalid_verification_id =>
      'Your verification id is invalid.';

  @override
  String get auth_failure_requires_recent_login =>
      'Its been too long since you last logged in. Sign in again.';

  @override
  String get auth_failure_missing_password =>
      'You have to type in your password.';

  @override
  String get auth_failure_unknown => 'An unknown error occured.';

  @override
  String get database_failure_permission_denied =>
      'Permission denied to access these resources.';

  @override
  String get database_failure_not_found => 'The requested data was not found.';

  @override
  String get database_failure_already_exists => 'the data already exists.';

  @override
  String get database_failure_deadline_exceeded =>
      'Data retrieval takes too long. Try again later.';

  @override
  String get database_failure_cancelled => 'The operation has been cancelled.';

  @override
  String get database_failure_unavailable =>
      'The service is currently unavailable.';

  @override
  String get database_failure_unknown => 'An unknown error occured.';

  @override
  String get storage_failure_object_not_found => 'Image not found.';

  @override
  String get storage_failure_not_authenticated =>
      'You are not logged in. Please login and try again.';

  @override
  String get storage_failure_not_authorized =>
      'You are not permitted to do this.';

  @override
  String get storage_failure_retry_limit_exceeded =>
      'There seems to be a problem. The action is taking longer than usual. Please try again later.';

  @override
  String get storage_failure_unknown =>
      'An unknown error occured. Please try again later.';

  @override
  String get password_forgotten_title => 'Reset password';

  @override
  String get password_forgotten_description =>
      'Please enter your email address and confirm. A link will then be sent to the email address you provided. You can use this link to reset your password.';

  @override
  String get password_forgotten_success_dialog_title =>
      'Password reset succeeded';

  @override
  String get password_forgotten_success_dialog_description =>
      'An email has been sent to the email address provided. You can set your new password using the link in the email.';

  @override
  String get password_forgotten_success_dialog_ok_button_title =>
      'Back to Login';

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
  String get profile_page_email_section_description =>
      'Now enter your new email address and confirm. A confirmation link will then be sent to the new email address. You can use this link to verify your new email address and log in again.';

  @override
  String get profile_page_email_section_change_email_button_title =>
      'Change email address';

  @override
  String get profile_page_email_section_change_email_password_description =>
      'Please enter your password if you would like to change your email address.';

  @override
  String
      get profile_page_email_section_change_email_password_continue_button_title =>
          'Continue';

  @override
  String get profile_page_email_section_resend_verify_email_button_title =>
      'Resend link for email verification';

  @override
  String get profile_page_email_section_title => 'E-Mail Settings';

  @override
  String get profile_page_email_section_verification_badge_verified =>
      'Verified';

  @override
  String get profile_page_email_section_verification_badge_unverified =>
      'Unverifiziert';

  @override
  String get profile_page_image_section_validation_exceededFileSize =>
      'You have exceeded the maximum allowed size of 5 MB';

  @override
  String get profile_page_image_section_validation_not_valid =>
      'The image format is invalid';

  @override
  String get profile_page_image_section_only_one_allowed =>
      'You can only upload one image at a time';

  @override
  String get profile_page_image_section_upload_not_found =>
      'The image to upload was not found';

  @override
  String
      get profile_page_image_section_large_image_view_close_button_tooltip_title =>
          'Close';

  @override
  String get profile_page_password_update_section_title => 'Change password';

  @override
  String get profile_page_password_update_section_new_password_description =>
      'Please enter your new password and confirm it. You will then be logged out and you can log in with the new password.';

  @override
  String
      get profile_page_password_update_section_new_password_textfield_placeholder =>
          'New password';

  @override
  String
      get profile_page_password_update_section_new_password_repeat_textfield_placeholder =>
          'Repeat new password';

  @override
  String
      get profile_page_password_update_section_new_password_confirm_button_text =>
          'Change password';

  @override
  String get profile_page_password_update_section_reauth_description =>
      'Please enter your current password so that you can create a new password.';

  @override
  String
      get profile_page_password_update_section_reauth_password_textfield_placeholder =>
          'Password';

  @override
  String
      get profile_page_password_update_section_reauth_continue_button_title =>
          'Weiter';

  @override
  String get profile_page_contact_section_title => 'Contact Information';

  @override
  String get profile_page_contact_section_subtitle =>
      'Update your personal information here.';

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
  String get profile_page_contact_section_form_save_button_title =>
      'Save changes';

  @override
  String get profile_page_snackbar_image_changed_message =>
      'You have successfully customized the profile picture.';

  @override
  String get profile_page_snackbar_contact_information_changes =>
      'The change to your contact information was successful.';

  @override
  String get profile_page_snackbar_email_verification =>
      'A link for email verification has been sent to you.';

  @override
  String get profile_page_snackbar_company_registered =>
      'The request for the company registration has been sent succesful.';

  @override
  String get profile_page_logout_button_title => 'Logout';

  @override
  String get profile_page_request_failure_message =>
      'An error occurred while retrieving the data.';

  @override
  String get profile_page_calendly_integration_title => 'Calendly Integration';

  @override
  String get profile_page_calendly_integration_description =>
      'Connect your Calendly account to enable appointment booking.';

  @override
  String get profile_page_promoters_section_title => 'Promoter';

  @override
  String get gender_picker_choose => 'Choose your gender';

  @override
  String get gender_picker_not_choosen => 'Not choosen';

  @override
  String get gender_picker_male => 'Male';

  @override
  String get gender_picker_female => 'Female';

  @override
  String get register_promoter_email_already_in_use =>
      'The email address already exists for another user.';

  @override
  String get register_promoter_title => 'Register promoter';

  @override
  String get register_promoter_first_name => 'firstname';

  @override
  String get register_promoter_last_name => 'lastname';

  @override
  String get register_promoter_email => 'email address';

  @override
  String get register_promoter_additional_info =>
      'reason for the recommendation';

  @override
  String get register_promoter_register_button => 'Register';

  @override
  String get register_promoter_snackbar_success =>
      'The new promoter has been successfully registered!';

  @override
  String get register_promoter_no_landingpage_title =>
      'You have not created a landing page yet';

  @override
  String get register_promoter_no_landingpage_subtitle =>
      'In order to create a new promoter it is necessary to have an active landing page.';

  @override
  String get register_promoter_missing_landingpage_error_message =>
      'The promoter has not yet been assigned a landing page';

  @override
  String get register_promoter_missing_company_error_message =>
      'You cannot register a promoter because you are not affiliated with any company';

  @override
  String get register_promoter_landingpage_assign_title =>
      'Assign Landingpages';

  @override
  String get promoter_register_tab_title => 'Register promoter';

  @override
  String get my_promoters_tab_title => 'My promoters';

  @override
  String get promoter_page_edit_promoter_snackbar_title =>
      'Successfully edited promoter!';

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
  String get promoter_overview_no_search_results_subtitle =>
      'You don\'t seem to have registered any promoters with the name you\'re looking for yet.\nChange your search term to search for other promoters.';

  @override
  String get promoter_overview_registration_badge_registered => 'Registered';

  @override
  String get promoter_overview_registration_badge_unregistered =>
      'Not registered';

  @override
  String get promoter_overview_empty_page_title => 'No promoter found';

  @override
  String get promoter_overview_empty_page_subtitle =>
      'You dont seem to have any promoters registered yet. Register your promoters now to win your first new customers.';

  @override
  String get promoter_overview_empty_page_button_title => 'Register promoter';

  @override
  String get promoter_overview_error_view_title =>
      'An error occurred while retrieving the data.';

  @override
  String promoter_overview_expiration_date(String date) {
    return 'expires at $date';
  }

  @override
  String promoter_overview_creation_date(String date) {
    return 'Member since $date';
  }

  @override
  String get promoter_overview_edit_promoter_tooltip => 'Edit';

  @override
  String get promoter_overview_delete_promoter_tooltip => 'Delete';

  @override
  String get promoter_overview_delete_promoter_alert_title =>
      'Should the selected promoter really be deleted?';

  @override
  String get promoter_overview_delete_promoter_alert_description =>
      'Deleting the promoter cannot be undone.';

  @override
  String get promoter_overview_delete_promoter_alert_delete_button => 'Delete';

  @override
  String get promoter_overview_delete_promoter_alert_cancel_button => 'Cancel';

  @override
  String get promoter_overview_delete_promoter_success_snackbar =>
      'Promoter successfully deleted';

  @override
  String get promoter_overview_delete_promoter_failure_snackbar =>
      'Promoter deletion failed!';

  @override
  String get delete_account_title => 'Delete account';

  @override
  String get delete_account_subtitle =>
      'Once your account is deleted, your data will remain with us for 30 days. During this time you can still contact support to reverse the deletion. Your data will then be irrevocably deleted.\n\nPlease enter your password to delete the account.';

  @override
  String get delete_account_password_placeholder => 'Password';

  @override
  String get delete_account_button_title => 'Delete account';

  @override
  String get delete_account_confirmation_alert_title =>
      'Really delete your account?';

  @override
  String get delete_account_confirmation_alert_message =>
      'Are you sure you want to delete your account?';

  @override
  String get delete_account_confirmation_alert_ok_button_title =>
      'Delete account';

  @override
  String get delete_account_confirmation_alert_cancel_button_title => 'Cancel';

  @override
  String get recommendation_page_leadTextField_title_prefix => 'Text for';

  @override
  String get recommendation_page_leadTextField_send_button =>
      'Send via Whatsapp';

  @override
  String get recommendation_page_leadTextField_send_email_button =>
      'Send via Email';

  @override
  String get recommendation_page_send_whatsapp_error =>
      'WhatsApp is not installed or cannot be opened.';

  @override
  String get recommendation_page_send_email_error =>
      'Email client could not be opened.';

  @override
  String get recommendation_page_max_item_Message =>
      'A maximum of 6 items can be added.';

  @override
  String get recommendations_choose_reason_placeholder => 'Choose a reason';

  @override
  String get recommendations_choose_reason_not_chosen => 'Not chosen';

  @override
  String get recommendations_title => 'Generate recommendations';

  @override
  String get recommendations_form_promoter_placeholder => 'Promoter';

  @override
  String get recommendations_form_service_provider_placeholder =>
      'Service provider';

  @override
  String get recommendations_form_recommendation_name_placeholder =>
      'Recommendation name';

  @override
  String get recommendations_form_generate_recommendation_button_title =>
      'Generate recommendations';

  @override
  String get recommendations_error_view_title =>
      'An error occurred while retrieving the data';

  @override
  String get recommendations_validation_missing_lead_name =>
      'Please enter a name';

  @override
  String get recommendations_validation_missing_promoter_name =>
      'Please enter a name';

  @override
  String get recommendations_validation_missing_reason =>
      'Please enter a reason';

  @override
  String get profile_company_contact_section_title => 'Company Information';

  @override
  String get profile_company_contact_section_subtitle =>
      'Update your company data here.';

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
  String get profile_company_contact_section_avv_checkbox_text =>
      'I approve the';

  @override
  String get profile_company_contact_section_avv_checkbox_text_part2 => '.';

  @override
  String get profile_company_contact_section_avv_link => 'OPC';

  @override
  String get profile_company_contact_section_avv_already_approved =>
      'already approved.';

  @override
  String get profile_company_contact_section_avv_generating =>
      'OPC is being generated...';

  @override
  String get profile_company_validator_missing_name =>
      'Please enter the company name';

  @override
  String get profile_company_validator_missing_industry =>
      'Please enter the industry';

  @override
  String get profile_company_validator_invalid_phone =>
      'The phone number is invalid';

  @override
  String get profile_company_validator_missing_address =>
      'Please enter the address';

  @override
  String get profile_company_validator_missing_postCode =>
      'Please enter a postcode';

  @override
  String get profile_company_validator_invalid_postCode =>
      'The postcode is invalid';

  @override
  String get profile_company_validator_missing_place => 'Please enter a place';

  @override
  String get profile_company_validator_missing_phone =>
      'Please enter a phone number';

  @override
  String get profile_company_contact_section_success_snackbar_message =>
      'Company information changed successfully';

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
  String get admin_company_request_detail_decline_button_title =>
      'Decline request';

  @override
  String get admin_company_request_detail_accept_button_title =>
      'Accept request';

  @override
  String get admin_company_request_overview_from_user => 'from: ';

  @override
  String get admin_company_request_overview_empty_title =>
      'There are no requests';

  @override
  String get admin_company_request_overview_empty_body =>
      'There dont appear to be any registration requests from companies at this time.';

  @override
  String get admin_company_request_overview_title =>
      'Requests for company registrations';

  @override
  String get admin_company_request_overview_error => 'There was an error';

  @override
  String get admin_registration_code_creator_success_snackbar =>
      'Code successfully sent!';

  @override
  String get admin_registration_code_creator_title =>
      'Create registration code';

  @override
  String get admin_registration_code_creator_description =>
      'Here you can create a registration code for a user. The code will be sent to the specified email address. The user who registered with this code is not assigned to a company.';

  @override
  String get admin_registration_code_creator_email_placeholder =>
      'Email address';

  @override
  String get admin_registration_code_creator_firstname_placeholder =>
      'Firstname';

  @override
  String get admin_registration_code_creator_send_code_button => 'Send code';

  @override
  String get company_registration_form_title => 'Register company';

  @override
  String get company_registration_form_name_textfield_placeholder =>
      'Company name';

  @override
  String get company_registration_form_industry_textfield_placeholder =>
      'Industry';

  @override
  String get company_registration_form_website_textfield_placeholder =>
      'Website (optional)';

  @override
  String get company_registration_form_address_textfield_placeholder =>
      'Address';

  @override
  String get company_registration_form_postcode_textfield_placeholder =>
      'Postcode';

  @override
  String get company_registration_form_place_textfield_placeholder => 'Place';

  @override
  String get company_registration_form_phone_textfield_placeholder => 'Phone';

  @override
  String get company_registration_form_register_button_title => 'Register now';

  @override
  String get profile_register_company_section_title => 'Company registration';

  @override
  String get profile_register_company_section_subtitle_in_progress =>
      'Your request is being processed.\nThe processing time is on average 7 days.';

  @override
  String get profile_register_company_section_subtitle_requested_at =>
      'Requested at ';

  @override
  String get profile_register_company_section_subtitle =>
      'Register your company now to take advantage of the apps additional benefits.';

  @override
  String get profile_register_company_section_button_title =>
      'Go to registration';

  @override
  String get profile_image_upload_tooltip => 'Upload image';

  @override
  String get landingpage_overview_edit_tooltip => 'Edit landingpage';

  @override
  String get landingpage_overview_show_tooltip => 'Show Landingpage';

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
  String get promoter_overview_filter_title => 'Promoter Filter';

  @override
  String get promoter_overview_filter_registration_title =>
      'Registration Status';

  @override
  String get promoter_overview_filter_sortby_title => 'Sort By';

  @override
  String get promoter_overview_filter_sortorder_title => 'Sort Order';

  @override
  String get promoter_overview_view_switch_grid_tooltip => 'Grid view';

  @override
  String get promoter_overview_view_switch_table_tooltip => 'List view';

  @override
  String get recommendations_form_add_button_tooltip => 'Add recommendation';

  @override
  String get recommendations_limit_title => 'Recommendation Limit';

  @override
  String get recommendations_limit_description =>
      'You can send up to 6 recommendations per month.';

  @override
  String recommendations_limit_status(int current, int max) {
    return 'Sent in the last 30 days: $current / $max';
  }

  @override
  String recommendations_limit_reset_days(int days) {
    return 'Resets in: $days days';
  }

  @override
  String recommendations_limit_reset_hours(int hours) {
    return 'Resets in: $hours hours';
  }

  @override
  String recommendations_sent_success(String name) {
    return 'The recommendation to $name has been sent successfully!';
  }

  @override
  String get recommendations_limit_reached_tooltip =>
      'Recommendation limit reached';

  @override
  String get recommendations_no_active_landingpage_tooltip =>
      'No active landing page assigned';

  @override
  String get recommendations_no_active_landingpage_warning =>
      'No recommendations possible - You have no active landing page assigned';

  @override
  String get landingpage_pagebuilder_container_request_error =>
      'An error occurred while retrieving the data';

  @override
  String get landingpage_pagebuilder_container_permission_error_title =>
      'You are not authorized to access this page';

  @override
  String get landingpage_pagebuilder_container_permission_error_message =>
      'You do not have the appropriate permission to access this page. Please log in with an account that is authorized to do so.';

  @override
  String get landingpage_pagebuilder_appbar_save_button_title => 'Save';

  @override
  String get landingpage_pagebuilder_save_error_alert_title => 'Save failed';

  @override
  String get landingpage_pagebuilder_save_error_alert_message =>
      'An error occurred while saving your new landing page content. Please try again later.';

  @override
  String get landingpage_pagebuilder_save_error_alert_button => 'OK';

  @override
  String get landingpage_pagebuilder_save_success_snackbar =>
      'The changes were saved successfully.';

  @override
  String get landingpage_pagebuilder_image_upload_exceeds_file_size_error =>
      'The image exceeds the 5 MB limit and cannot be uploaded!';

  @override
  String get landingpage_pagebuilder_unload_alert_message =>
      'Do you really want to leave the site? Changes that are not saved will be lost.';

  @override
  String get landingpage_pagebuilder_config_menu_content_tab => 'Content';

  @override
  String get landingpage_pagebuilder_config_menu_design_tab => 'Design';

  @override
  String get landingpage_pagebuilder_config_menu_container_type => 'Container';

  @override
  String get landingpage_pagebuilder_config_menu_column_type => 'Column';

  @override
  String get landingpage_pagebuilder_config_menu_row_type => 'Row';

  @override
  String get landingpage_pagebuilder_config_menu_text_type => 'Text';

  @override
  String get landingpage_pagebuilder_config_menu_image_type => 'Image';

  @override
  String get landingpage_pagebuilder_config_menu_icon_type => 'Icon';

  @override
  String get landingpage_pagebuilder_config_menu_button_type => 'Button';

  @override
  String get landingpage_pagebuilder_config_menu_contact_form_type =>
      'Contact Form';

  @override
  String get landingpage_pagebuilder_config_menu_footer_type => 'Footer';

  @override
  String get landingpage_pagebuilder_config_menu_video_player_type =>
      'Video Player';

  @override
  String get landingpage_pagebuilder_config_menu_anchor_button_type =>
      'Anchor Button';

  @override
  String get landingpage_pagebuilder_config_menu_calendly_type => 'Calendly';

  @override
  String get landingpage_pagebuilder_config_menu_unknown_type => 'Unknown';

  @override
  String get landingpage_pagebuilder_text_config_text_title =>
      'Text configuration';

  @override
  String get landingpage_pagebuilder_text_config_alignment => 'Alignment';

  @override
  String get landingpage_pagebuilder_text_config_alignment_left => 'left-align';

  @override
  String get landingpage_pagebuilder_text_config_alignment_center => 'center';

  @override
  String get landingpage_pagebuilder_text_config_alignment_right =>
      'right-align';

  @override
  String get landingpage_pagebuilder_text_config_alignment_justify => 'justify';

  @override
  String get landingpage_pagebuilder_text_config_lineheight => 'Line height';

  @override
  String get landingpage_pagebuilder_text_config_letterspacing =>
      'Letter spacing';

  @override
  String get landingpage_pagebuilder_text_config_color => 'Text color';

  @override
  String get landingpage_pagebuilder_text_config_font_family => 'Font family';

  @override
  String get landingpage_pagebuilder_text_config_shadow => 'Text shadow';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_title =>
      'Configure shadow';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_spread_radius =>
      'Spread radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_blur_radius =>
      'Blur radius';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_x_offset =>
      'X offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_y_offset =>
      'Y offset';

  @override
  String get landingpage_pagebuilder_text_config_shadow_alert_apply => 'Apply';

  @override
  String get landingpage_pagebuilder_text_config_fontsize => 'Font size';

  @override
  String get landingpage_pagebuilder_color_picker_title => 'Select color';

  @override
  String get landingpage_pagebuilder_color_picker_hex_textfield => 'Hex code';

  @override
  String get landingpage_pagebuilder_color_picker_ok_button => 'OK';

  @override
  String get landingpage_pagebuilder_text_config_text_placeholder =>
      'Type text here...';

  @override
  String get landingpage_pagebuilder_text_config_content_title =>
      'Text content';

  @override
  String get landingpage_pagebuilder_layout_spacing_top => 'Top';

  @override
  String get landingpage_pagebuilder_layout_spacing_bottom => 'Bottom';

  @override
  String get landingpage_pagebuilder_layout_spacing_left => 'Left';

  @override
  String get landingpage_pagebuilder_layout_spacing_right => 'Right';

  @override
  String get landingpage_pagebuilder_layout_menu_title => 'Layout';

  @override
  String get landingpage_pagebuilder_layout_menu_padding => 'Padding';

  @override
  String get landingpage_pagebuilder_layout_menu_margin => 'Margin';

  @override
  String get landingpage_pagebuilder_layout_menu_alignment => 'Alignment';

  @override
  String get landingpage_pagebuilder_layout_menu_width_percentage =>
      'Width in %';

  @override
  String landingpage_pagebuilder_layout_menu_width_warning(String totalWidth) {
    return 'Sum of widths: $totalWidth% (will be scaled to 100%)';
  }

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_switch =>
      'Show pronoter image';

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_title =>
      'Background image';

  @override
  String get landingpage_pagebuilder_layout_menu_image_control_title_promoter =>
      'Specify a placeholder image if the promoter image does not exist';

  @override
  String get landingpage_pagebuilder_layout_menu_background_contentmode =>
      'Content mode';

  @override
  String get landingpage_pagebuilder_layout_menu_background_overlay =>
      'Image overlay';

  @override
  String get landingpage_pagebuilder_layout_menu_background => 'Background';

  @override
  String get landingpage_pagebuilder_layout_menu_background_color =>
      'Background color';

  @override
  String get landingpage_pagebuilder_custom_css_menu_title => 'Custom CSS';

  @override
  String get landingpage_pagebuilder_custom_css_menu_description =>
      'To further customize the layout of this element, you can add custom CSS here.\nCSS changes are not visible in the pagebuilder. You need to check it in the landingpage preview.';

  @override
  String get pagebuilder_layout_menu_alignment_top_left => 'top left';

  @override
  String get pagebuilder_layout_menu_alignment_top_center => 'top center';

  @override
  String get pagebuilder_layout_menu_alignment_top_right => 'top right';

  @override
  String get pagebuilder_layout_menu_alignment_center_left => 'center left';

  @override
  String get pagebuilder_layout_menu_alignment_center => 'center';

  @override
  String get pagebuilder_layout_menu_alignment_center_right => 'center right';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_left => 'bottom left';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_center => 'bottom center';

  @override
  String get pagebuilder_layout_menu_alignment_bottom_right => 'bottom right';

  @override
  String get pagebuilder_layout_menu_size_control_size => 'Size';

  @override
  String get pagebuilder_layout_menu_size_control_width => 'Width';

  @override
  String get pagebuilder_layout_menu_size_control_height => 'Height';

  @override
  String get pagebuilder_image_config_title => 'Image configuration';

  @override
  String get pagebuilder_image_config_content_mode => 'Content mode';

  @override
  String get pagebuilder_image_config_image_overlay => 'Image overlay';

  @override
  String get pagebuilder_image_config_border_radius => 'Radius';

  @override
  String get pagebuilder_image_config_border_title => 'Border';

  @override
  String get pagebuilder_image_config_border_width => 'Border width';

  @override
  String get pagebuilder_image_config_border_color => 'Border color';

  @override
  String get pagebuilder_image_config_image_content => 'Image content';

  @override
  String get landingpage_pagebuilder_container_config_container_title =>
      'Container configuration';

  @override
  String get landingpage_pagebuilder_container_config_auto_sizing =>
      'Auto sizing';

  @override
  String get landingpage_pagebuilder_container_config_container_shadow =>
      'Shadow';

  @override
  String get landingpage_pagebuilder_container_config_container_border_title =>
      'Border';

  @override
  String get landingpage_pagebuilder_container_config_container_border_width =>
      'Border width';

  @override
  String get landingpage_pagebuilder_container_config_container_border_color =>
      'Border color';

  @override
  String get landingpage_pagebuilder_row_config_row_title =>
      'Row configuration';

  @override
  String get landingpage_pagebuilder_row_config_row_equal_heights =>
      'Equal heights';

  @override
  String get landingpage_pagebuilder_row_config_row_main_axis_alignment =>
      'Alignment x-axis';

  @override
  String get landingpage_pagebuilder_row_config_row_cross_axis_alignment =>
      'Alignment y-axis';

  @override
  String get landingpage_pagebuilder_column_config_column_title =>
      'Column configuration';

  @override
  String get landingpage_pagebuilder_icon_content => 'Icon content';

  @override
  String get landingpage_pagebuilder_icon_content_change_icon => 'Change icon';

  @override
  String get landingpage_pagebuilder_icon_config_icon_title =>
      'Icon configuration';

  @override
  String get landingpage_pagebuilder_icon_config_color => 'Color';

  @override
  String get landingpage_pagebuilder_icon_config_size => 'Size';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_title =>
      'Choose an icon';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_close => 'Close';

  @override
  String get landingpage_pagebuilder_icon_config_icon_picker_search => 'Search';

  @override
  String
      get landingpage_pagebuilder_icon_config_icon_picker_search_no_results =>
          'No results for:';

  @override
  String get landingpage_pagebuilder_spacer_config_title =>
      'Height configuration';

  @override
  String get landingpage_pagebuilder_spacer_config_height => 'Height';

  @override
  String get landingpage_pagebuilder_spacer_config_width_percentage =>
      'Width in %';

  @override
  String get landingpage_pagebuilder_config_menu_spacer_type => 'Height';

  @override
  String get landingpage_pagebuilder_contactform_content_email =>
      'Contactform email';

  @override
  String get landingpage_pagebuilder_contactform_content_email_subtitle =>
      'Please enter the recipient email address to which the contact request will be sent.';

  @override
  String get landingpage_pagebuilder_contactform_content_email_placeholder =>
      'Email address';

  @override
  String get pagebuilder_button_config_button_width => 'Width';

  @override
  String get pagebuilder_button_config_button_height => 'Height';

  @override
  String get pagebuilder_button_config_button_background_color =>
      'Background color';

  @override
  String get pagebuilder_button_config_button_border_title => 'Border';

  @override
  String get pagebuilder_button_config_button_border_radius => 'Radius';

  @override
  String get pagebuilder_button_config_button_border_width => 'Border width';

  @override
  String get pagebuilder_button_config_button_border_color => 'Border color';

  @override
  String get pagebuilder_button_config_button_text_configuration =>
      'Button text configuration';

  @override
  String get pagebuilder_contact_form_config_name_textfield_title =>
      'Name textfield';

  @override
  String get pagebuilder_contact_form_config_email_textfield_title =>
      'E-Mail textfield';

  @override
  String get pagebuilder_contact_form_config_phone_textfield_title =>
      'Phone textfield';

  @override
  String get pagebuilder_contact_form_config_message_textfield_title =>
      'Message textfield';

  @override
  String get pagebuilder_contact_form_config_button_title =>
      'Button configuration';

  @override
  String get pagebuilder_textfield_config_textfield_width => 'Width';

  @override
  String get pagebuilder_textfield_config_textfield_min_lines =>
      'Number of lines min';

  @override
  String get pagebuilder_textfield_config_textfield_max_lines =>
      'Number of lines max';

  @override
  String get pagebuilder_textfield_config_textfield_required =>
      'Required field';

  @override
  String get pagebuilder_textfield_config_textfield_background_color =>
      'Background color';

  @override
  String get pagebuilder_textfield_config_textfield_border_color =>
      'Border color';

  @override
  String get pagebuilder_textfield_config_textfield_placeholder =>
      'Placeholder';

  @override
  String get pagebuilder_textfield_config_textfield_text_configuration =>
      'Textfield text configuration';

  @override
  String
      get pagebuilder_textfield_config_textfield_placeholder_text_configuration =>
          'Textfield placeholder configuration';

  @override
  String get landingpage_pagebuilder_config_menu_section_type => 'Section';

  @override
  String get landingpage_pagebuilder_footer_config_privacy_policy =>
      'Privacy Policy Configuration';

  @override
  String get landingpage_pagebuilder_footer_config_impressum =>
      'Impressum Configuration';

  @override
  String get landingpage_pagebuilder_footer_config_initial_information =>
      'Initial Information Configuration ';

  @override
  String get landingpage_pagebuilder_footer_config_terms_and_conditions =>
      'Terms and Conditions Configuration';

  @override
  String edit_promoter_title(String firstName, String lastName) {
    return 'Edit $firstName $lastName';
  }

  @override
  String get edit_promoter_subtitle =>
      'Here you can adjust the landingpage allocation.';

  @override
  String get edit_promoter_save_button_title => 'Save changes';

  @override
  String get edit_promoter_inactive_landingpage_tooltip =>
      'This landingpage is not active';

  @override
  String get edit_promoter_inactive_landingpage_tooltip_activate_action =>
      'Activate landingpage';

  @override
  String get promoter_overview_inactive_landingpage_tooltip_warning =>
      'The promoter doesnt have active assinged landingpages';

  @override
  String get promoter_overview_inactive_landingpage_tooltip_warning_action =>
      'Assign landingpage';

  @override
  String get landingpage_pagebuilder_video_player_config_title =>
      'Video Player Configuration';

  @override
  String get pagebuilder_calendly_config_title => 'Calendly Configuration';

  @override
  String get pagebuilder_calendly_config_width => 'Width';

  @override
  String get pagebuilder_calendly_config_height => 'Height';

  @override
  String get pagebuilder_calendly_config_border_radius => 'Border Radius';

  @override
  String get pagebuilder_section_maxwidth_title => 'Max Width';

  @override
  String get pagebuilder_section_maxwidth => 'Max Width';

  @override
  String get pagebuilder_section_background_constrained =>
      'Apply max width to background';

  @override
  String get pagebuilder_section_full_height => 'Full viewport height';

  @override
  String get pagebuilder_widget_maxwidth => 'Max Width';

  @override
  String get pagebuilder_calendly_config_text_color => 'Text Color';

  @override
  String get pagebuilder_calendly_config_background_color => 'Background Color';

  @override
  String get pagebuilder_calendly_config_primary_color => 'Primary Color';

  @override
  String get pagebuilder_calendly_content_title => 'Calendly Event Selection';

  @override
  String get pagebuilder_calendly_content_hide_event_details =>
      'Hide Event Details';

  @override
  String get pagebuilder_calendly_content_loading_event_types =>
      'Loading event types...';

  @override
  String get pagebuilder_calendly_content_connecting => 'Connecting...';

  @override
  String get pagebuilder_calendly_content_error_prefix => 'Error:';

  @override
  String get pagebuilder_calendly_content_select_event_type =>
      'Select event type:';

  @override
  String get pagebuilder_calendly_content_choose_event_type =>
      'Choose event type...';

  @override
  String get pagebuilder_calendly_content_connection_required =>
      'Calendly connection required';

  @override
  String get pagebuilder_calendly_content_connection_description =>
      'To select event types, you must first connect to Calendly.';

  @override
  String get pagebuilder_calendly_content_connect_button =>
      'Connect to Calendly';

  @override
  String get landingpage_pagebuilder_video_player_config_youtube_link =>
      'Youtube link';

  @override
  String
      get landingpage_pagebuilder_video_player_config_youtube_link_description =>
          'Please provide the YouTube link where your video can be accessed.';

  @override
  String
      get landingpage_pagebuilder_video_player_config_youtube_link_placeholder =>
          'Youtube link';

  @override
  String get landingpage_creator_missing_companydata_error =>
      'Company data not found';

  @override
  String get landingpage_creator_default_page_info_text =>
      'The data from your company profile is used to create the default landing page. This data will be displayed on the default landing page. If you change your company data, the data on your default page will also change.';

  @override
  String get landingpage_creator_ai_loading_subtitle =>
      'The AI ​​is currently creating your landing page...';

  @override
  String get landingpage_creator_ai_loading_subtitle2 =>
      'This may take up to 5 minutes.\nYou can leave this site. The landingpage will appear in your overview when it has been generated.';

  @override
  String get landingpage_creator_ai_form_section_title =>
      'Or let our AI create the page for you';

  @override
  String get landingpage_creator_ai_form_title =>
      'Enter some information about your business and let the AI ​​create a customized landing page.';

  @override
  String get landingpage_creator_ai_form_radio_title => 'Kind of landing page:';

  @override
  String get landingpage_creator_ai_form_radio_business => 'Business/Company';

  @override
  String get landingpage_creator_ai_form_radio_finance => 'Finance Advisor';

  @override
  String get landingpage_creator_ai_form_radio_individual => 'Individual';

  @override
  String get landingpage_creator_ai_form_business_placeholder =>
      'Industry/Company Type';

  @override
  String get landingpage_creator_ai_form_finance_placeholder =>
      'Specialization';

  @override
  String get landingpage_creator_ai_form_custom_description_placeholder =>
      'Additional information (optional)';

  @override
  String get landingpage_creator_ai_form_character_count => 'Characters';

  @override
  String get landingpage_creator_ai_form_example =>
      'Example: Our financial office is centrally located in the city center, family-run since 1985, and specializes in independent financial advice and retirement planning. Reliability and trust are our focus – clear structures and calm shades of blue and gray are desired.';

  @override
  String get landingpage_overview_no_default_page_title => 'Setup Landingpage';

  @override
  String get landingpage_overview_no_default_page_subtitle =>
      'You haven\'t set up a landing page for your company yet. Here you can create a default landing page to start with. This landing page will be used if the link to another landing page expires. The landing page displays company information and a contact form.';

  @override
  String get landingpage_overview_no_default_page_button_title =>
      'Create default landingpage';

  @override
  String get landingpage_overview_created_at => 'Created on';

  @override
  String get landingpage_overview_updated_at => 'Modified on';

  @override
  String get landingpage_overview_deactivated => 'DEACTIVATED';

  @override
  String get edit_promoter_no_data_title => 'No data found';

  @override
  String get edit_promoter_no_data_subtitle =>
      'No data was found for this promoter';

  @override
  String get send_recommendation_alert_title => 'Recommendation sent?';

  @override
  String get save_recommendation_loading_title => 'Save recommendation';

  @override
  String get save_recommendation_loading_subtitle =>
      'The recommendation is being saved';

  @override
  String send_recommendation_alert_description(String receiver) {
    return 'Did you successfully send the recommendation to $receiver? The link in the recommendation will only become valid once you confirm it here.';
  }

  @override
  String get send_recommendation_alert_yes_button => 'Yes';

  @override
  String get send_recommendation_alert_no_button => 'No';

  @override
  String get send_recommendation_missing_link_text =>
      'The [LINK] placeholder is missing!';

  @override
  String get recommendation_manager_expired_day => 'day';

  @override
  String get recommendation_manager_expired_days => 'days';

  @override
  String get recommendation_manager_status_level_1 => 'Recommendation made';

  @override
  String get recommendation_manager_status_level_2 => 'Link clicked';

  @override
  String get recommendation_manager_status_level_3 => 'Contacted';

  @override
  String get recommendation_manager_status_level_4 => 'Appointment made';

  @override
  String get recommendation_manager_status_level_5 => 'Completed';

  @override
  String get recommendation_manager_status_level_6 => 'Not completed';

  @override
  String get recommendation_manager_filter_expires_date => 'Expiration date';

  @override
  String get recommendation_manager_filter_last_updated => 'Last updated';

  @override
  String get recommendation_manager_filter_promoter => 'Promoter';

  @override
  String get recommendation_manager_filter_recommendation_receiver =>
      'Receiver';

  @override
  String get recommendation_manager_filter_reason => 'Reason';

  @override
  String get recommendation_manager_filter_ascending => 'Ascending';

  @override
  String get recommendation_manager_filter_descending => 'Descending';

  @override
  String get recommendation_manager_filter_status_all => 'All';

  @override
  String get recommendation_manager_list_header_priority => 'Priority';

  @override
  String get recommendation_manager_list_header_receiver =>
      'Recommendation name';

  @override
  String get recommendation_manager_list_header_promoter => 'Promoter';

  @override
  String get recommendation_manager_list_header_status => 'Status';

  @override
  String get recommendation_manager_list_header_expiration_date => 'Expires in';

  @override
  String get recommendation_manager_no_search_result_title =>
      'No search results';

  @override
  String get recommendation_manager_no_search_result_description =>
      'No recommendations were found for your search term.';

  @override
  String get recommendation_manager_list_tile_receiver =>
      'Recommendation receiver';

  @override
  String get recommendation_manager_list_tile_reason => 'Recommendation reason';

  @override
  String get recommendation_manager_list_tile_delete_button_title =>
      'Delete recommendation';

  @override
  String get recommendation_manager_title => 'My Recommendations';

  @override
  String get recommendation_manager_filter_tooltip => 'Filter recommendations';

  @override
  String get recommendation_manager_search_close_tooltip =>
      'Delete search term';

  @override
  String get recommendation_manager_search_placeholder => 'Suche...';

  @override
  String get recommendation_manager_no_data_title => 'No recommendations found';

  @override
  String get recommendation_manager_no_data_description =>
      'No recommendations were found. You don\'t seem to have made a recommendation yet. Your recommendations are displayed in the Recommendation Manager.';

  @override
  String get recommendation_manager_no_data_button_title =>
      'Make a recommendation';

  @override
  String get recommendation_manager_failure_text => 'An error has occurred';

  @override
  String get recommendation_manager_tile_progress_appointment_button_tooltip =>
      'Mark as scheduled';

  @override
  String get recommendation_manager_tile_progress_finish_button_tooltip =>
      'Mark as completed';

  @override
  String get recommendation_manager_tile_progress_failed_button_tooltip =>
      'Mark as failed';

  @override
  String get recommendation_manager_delete_alert_title =>
      'Delete recommendation';

  @override
  String get recommendation_manager_delete_alert_description =>
      'Are you sure you want to delete the recommendation? This action cannot be undone.';

  @override
  String get recommendation_manager_delete_alert_delete_button =>
      'Delete recommendation';

  @override
  String get recommendation_manager_delete_alert_cancel_button => 'Cancel';

  @override
  String get recommendation_manager_delete_snackbar =>
      'The recommendation was successfully deleted!';

  @override
  String get recommendation_manager_finished_at_list_header => 'Finished at';

  @override
  String get recommendation_manager_archive_no_data_title =>
      'No archived recommendations found';

  @override
  String get recommendation_manager_archive_no_data_description =>
      'You don\'t appear to have archived any recommendations yet. All completed and incomplete recommendations are stored in the archive.';

  @override
  String get recommendation_manager_filter_finished_at => 'Completion date';

  @override
  String get recommendation_manager_finish_alert_title =>
      'Finish recommendation';

  @override
  String get recommendation_manager_finish_alert_message =>
      'Do you really want to mark the recommendation as completed?\nThe recommendation will then be archived.';

  @override
  String get recommendation_manager_finish_alert_archive_button => 'Archive';

  @override
  String get recommendation_manager_finish_alert_cancel_button => 'Cancel';

  @override
  String get recommendation_manager_failed_alert_title =>
      'Recommendation not completed';

  @override
  String get recommendation_manager_failed_alert_description =>
      'Are you sure you want to mark the recommendation as failed?\nThe recommendation will then be archived.';

  @override
  String get recommendation_manager_failed_alert_archive_button => 'Archive';

  @override
  String get recommendation_manager_failed_alert_cancel_button => 'Cancel';

  @override
  String get recommendation_manager_scheduled_snackbar =>
      'Appointment was successfully scheduled!';

  @override
  String get recommendation_manager_finished_snackbar =>
      'Your recommendation has been moved to the archive!';

  @override
  String get recommendation_manager_active_recommendations_tab =>
      'Active Recommendations';

  @override
  String get recommendation_manager_achive_tab => 'Archive';

  @override
  String get recommendation_manager_filter_sort_by_status => 'Sort by status';

  @override
  String get recommendation_manager_filter_sort_by_favorites =>
      'Sort by favorites';

  @override
  String get recommendation_manager_filter_favorites => 'Favorites';

  @override
  String get recommendation_manager_filter_no_favorites => 'No favorites';

  @override
  String get recommendation_manager_favorite_snackbar =>
      'Favorites successfully changed!';

  @override
  String get recommendation_missing_landingpage_title => 'No landingpage found';

  @override
  String get recommendation_missing_landingpage_text =>
      'In order to make a recommendation, you must first create a landing page in addition to your default landing page.';

  @override
  String get recommendation_missing_landingpage_button => 'To the landingpages';

  @override
  String get recommendation_priority_high => 'High';

  @override
  String get recommendation_priority_medium => 'Medium';

  @override
  String get recommendation_priority_low => 'Low';

  @override
  String get pagebuilder_calendly_config_dynamic_height => 'Dynamic Height';

  @override
  String get recommendation_manager_filter_sort_by_priorities =>
      'Sort by priority';

  @override
  String get recommendation_manager_show_landingpage_button =>
      'Show landingpage';

  @override
  String get recommendation_manager_select_priority_tooltip =>
      'Select priority';

  @override
  String get recommendation_manager_priority_snackbar =>
      'Priority successfully changed!';

  @override
  String get recommendation_manager_notes_placeholder => 'Add notes here...';

  @override
  String get recommendation_manager_notes_save_button_tooltip => 'Save notes';

  @override
  String get recommendation_manager_notes_edit_button_tooltip => 'Edit notes';

  @override
  String get recommendation_manager_notes_last_updated =>
      'Notes last edited at:';

  @override
  String get dashboard_tutorial_title => 'Quick Start Guide';

  @override
  String get dashboard_tutorial_step_email_verification_title =>
      'Verify email address';

  @override
  String get dashboard_tutorial_step_email_verification_content =>
      'Verify your email address. To resend the verification link, visit your profile.';

  @override
  String get dashboard_tutorial_step_contact_data_title =>
      'Complete contact data';

  @override
  String get dashboard_tutorial_step_contact_data_content =>
      'Go to your profile and complete your contact data.';

  @override
  String get dashboard_tutorial_step_company_registration_title =>
      'Register company';

  @override
  String get dashboard_tutorial_step_company_registration_content =>
      'Go to your profile and register your company';

  @override
  String get dashboard_tutorial_step_company_approval_title =>
      'Wait for approval';

  @override
  String get dashboard_tutorial_step_company_approval_content =>
      'You have submitted a registration request for your company. Processing the request may take a few days. Please check back later.';

  @override
  String get dashboard_tutorial_step_default_landingpage_title =>
      'Create default landing page';

  @override
  String get dashboard_tutorial_step_default_landingpage_content =>
      'To use the app, you must create a default landing page. This will be used as a fallback if your normal landing page doesn\'t work.';

  @override
  String get dashboard_tutorial_step_landingpage_title => 'Create landing page';

  @override
  String get dashboard_tutorial_step_landingpage_content =>
      'You have successfully created your default landing page. Now you need a normal landing page to promote your product or service.';

  @override
  String get dashboard_tutorial_step_promoter_registration_title =>
      'Register promoter';

  @override
  String get dashboard_tutorial_step_promoter_registration_content =>
      'To promote your service or product, promoters are necessary. Create your first promoter.';

  @override
  String get dashboard_tutorial_step_promoter_waiting_title =>
      'Wait for promoter';

  @override
  String get dashboard_tutorial_step_promoter_waiting_content =>
      'The invited promoter must now register. Please wait until this happens.';

  @override
  String get dashboard_tutorial_step_recommendation_title =>
      'Make recommendation';

  @override
  String get dashboard_tutorial_step_recommendation_content =>
      'It\'s time to make your first recommendation to win your first customer.';

  @override
  String get dashboard_tutorial_step_recommendation_manager_title =>
      'Check recommendation manager';

  @override
  String get dashboard_tutorial_step_recommendation_manager_content =>
      'Your first recommendation is now displayed in the recommendation manager. Here you can prioritize the recommendation, leave notes, and check the status of your recommendation. You will also see all recommendations made by your promoters.';

  @override
  String get dashboard_tutorial_step_complete_title => 'Complete tutorial';

  @override
  String get dashboard_tutorial_step_complete_content =>
      'You have completed all steps for using the app.';

  @override
  String get dashboard_tutorial_button_to_profile => 'To profile';

  @override
  String get dashboard_tutorial_button_to_landingpages => 'To landing pages';

  @override
  String get dashboard_tutorial_button_register_promoter => 'Register promoter';

  @override
  String get dashboard_tutorial_button_make_recommendation =>
      'Make recommendation';

  @override
  String get dashboard_tutorial_button_to_recommendation_manager =>
      'To recommendation manager';

  @override
  String get dashboard_tutorial_button_hide_tutorial => 'Hide tutorial';

  @override
  String get dashboard_tutorial_error_title => 'Failed to load tutorial';

  @override
  String get dashboard_tutorial_error_message =>
      'The request failed. Please try again.';

  @override
  String get recommendation_manager_add_note_button_tooltip => 'Add note';

  @override
  String get recommendation_manager_notes_snackbar =>
      'Notes successfully changed!';

  @override
  String recommendation_manager_notes_last_edited_by_user(String date) {
    return 'Last edited by you on $date';
  }

  @override
  String recommendation_manager_notes_last_edited_by_other(
      String userName, String date) {
    return 'Last edited by $userName on $date';
  }

  @override
  String get pagebuilder_text_placeholder_recommendation_name =>
      'Name of recommendation';

  @override
  String get pagebuilder_text_placeholder_promoter_name => 'Name of promoter';

  @override
  String get pagebuilder_text_placeholder_picker => 'Choose placeholder';

  @override
  String get pagebuilder_config_menu_normal_tab => 'Normal';

  @override
  String get pagebuilder_config_menu_hover_tab => 'Hover';

  @override
  String get pagebuilder_config_menu_hover_switch => 'Activate hover';

  @override
  String get pagebuilder_anchor_button_config_title =>
      'Anchor Button Configuration';

  @override
  String get pagebuilder_anchor_button_content_section_name => 'Section Name';

  @override
  String get pagebuilder_anchor_button_content_section_name_subtitle =>
      'Please enter the section name you want to scroll to. You can find this in the respective section.';

  @override
  String get pagebuilder_anchor_button_content_no_sections_available =>
      'No sections available';

  @override
  String get pagebuilder_anchor_button_content_section_name_placeholder =>
      'Please select';

  @override
  String get pagebuilder_section_id => 'ID:';

  @override
  String get pagebuilder_section_copy_id_tooltip => 'Copy id';

  @override
  String get pagebuilder_hierarchy_button_tooltip => 'Show page hierarchy';

  @override
  String get pagebuilder_responsive_preview_button_tooltip => 'Responsive mode';

  @override
  String get pagebuilder_breakpoint_desktop => 'Desktop';

  @override
  String get pagebuilder_breakpoint_tablet => 'Tablet';

  @override
  String get pagebuilder_breakpoint_mobile => 'Mobile';

  @override
  String get pagebuilder_hierarchy_overlay_title => 'Page structure';

  @override
  String get pagebuilder_hierarchy_overlay_no_elements =>
      'No elements available';

  @override
  String get pagebuilder_hierarchy_overlay_section_element => 'Section';

  @override
  String get pagebuilder_hierarchy_overlay_text => 'Text';

  @override
  String get pagebuilder_hierarchy_overlay_image => 'Image';

  @override
  String get pagebuilder_hierarchy_overlay_button => 'Button';

  @override
  String get pagebuilder_hierarchy_overlay_anchor_button => 'Anchor button';

  @override
  String get pagebuilder_hierarchy_overlay_container => 'Container';

  @override
  String get pagebuilder_hierarchy_overlay_row => 'Row';

  @override
  String get pagebuilder_hierarchy_overlay_column => 'Column';

  @override
  String get pagebuilder_hierarchy_overlay_icon => 'Icon';

  @override
  String get pagebuilder_hierarchy_overlay_contact_form => 'Contact form';

  @override
  String get pagebuilder_hierarchy_overlay_footer => 'Footer';

  @override
  String get pagebuilder_hierarchy_overlay_video_player => 'Video player';

  @override
  String get pagebuilder_hierarchy_overlay_calendly => 'Calendly';

  @override
  String get pagebuilder_hierarchy_overlay_height => 'Height';

  @override
  String get pagebuilder_mobile_not_supported_title =>
      'PageBuilder only available for desktop';

  @override
  String get pagebuilder_mobile_not_supported_subtitle =>
      'The PageBuilder is only available on desktop devices. Please open this page on a computer or laptop.\n\n If you\'re already on a computer, resize the browser window.';

  @override
  String get dashboard_user_not_found_error_title => 'User not found';

  @override
  String get dashboard_user_not_found_error_message =>
      'The current user could not be found. Please try again later.';

  @override
  String get dashboard_greeting => 'Hi';

  @override
  String get dashboard_recommendations_title => 'Number of recommendations';

  @override
  String get dashboard_recommendations_loading_error_title =>
      'Loading recommendations failed';

  @override
  String get dashboard_recommendations_chart_no_recommendations =>
      'No recommendations available';

  @override
  String get dashboard_recommendations_all_promoter => 'All';

  @override
  String get dashboard_recommendations_missing_promoter_name =>
      'Unkown promoter';

  @override
  String get dashboard_recommendations_own_recommendations =>
      'Own recommendations';

  @override
  String dashboard_recommendations_last_24_hours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recommendations',
      one: '1 recommendation',
      zero: '0 recommendations',
    );
    return 'Last 24 hours: $_temp0';
  }

  @override
  String dashboard_recommendations_last_7_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recommendations',
      one: '1 recommendation',
      zero: '0 recommendations',
    );
    return 'Last 7 days: $_temp0';
  }

  @override
  String dashboard_recommendations_last_month(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recommendations',
      one: '1 recommendation',
      zero: '0 recommendations',
    );
    return 'Last month: $_temp0';
  }

  @override
  String get dashboard_promoters_title => 'Number of Promoters';

  @override
  String get dashboard_promoters_loading_error_title =>
      'Loading promoters failed';

  @override
  String dashboard_promoters_last_7_days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count promoters',
      one: '1 promoter',
      zero: '0 promoters',
    );
    return 'Last 7 days: $_temp0';
  }

  @override
  String dashboard_promoters_last_month(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count promoters',
      one: '1 promoter',
      zero: '0 promoters',
    );
    return 'Last month: $_temp0';
  }

  @override
  String dashboard_promoters_last_year(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count promoters',
      one: '1 promoter',
      zero: '0 promoters',
    );
    return 'Last year: $_temp0';
  }

  @override
  String get dashboard_promoters_chart_no_promoters => 'No promoters found';

  @override
  String get recommendation_manager_field_priority => 'Priority';

  @override
  String get recommendation_manager_field_notes => 'Notes';

  @override
  String get recommendation_manager_field_connector => ' and ';

  @override
  String recommendation_manager_edit_message(String userName, String fields) {
    return '$userName has adjusted $fields';
  }

  @override
  String get feedback_send_button => 'Send Feedback';

  @override
  String get feedback_title_required => 'Title is required';

  @override
  String get feedback_title_too_long =>
      'Title can be at most 100 characters long';

  @override
  String get feedback_description_required => 'Description is required';

  @override
  String get feedback_description_too_long =>
      'Description can be at most 1000 characters long';

  @override
  String get feedback_dialog_title => 'Give Feedback';

  @override
  String get feedback_dialog_close => 'Close';

  @override
  String get feedback_title_placeholder => 'Enter title...';

  @override
  String get feedback_description_placeholder => 'Enter description...';

  @override
  String get feedback_images_label => 'Images (optional, max. 3)';

  @override
  String get feedback_cancel_button => 'Cancel';

  @override
  String get feedback_send_dialog_button => 'Send';

  @override
  String get feedback_success_message => 'Feedback sent successfully!';

  @override
  String get feedback_email_placeholder => 'Email address (optional)';

  @override
  String get feedback_category_label => 'Category';

  @override
  String get admin_feedback_no_feedback_title => 'No feedback found';

  @override
  String get admin_feedback_no_feedback_subtitle =>
      'It seems no user has left feedback yet.';

  @override
  String get admin_feedback_refresh_button => 'Refresh';

  @override
  String get admin_feedback_error_title => 'An error occurred';

  @override
  String get admin_feedback_delete_title => 'Delete feedback';

  @override
  String get admin_feedback_delete_message =>
      'Do you really want to delete this feedback? It cannot be restored afterwards.';

  @override
  String get admin_feedback_delete_button => 'Delete';

  @override
  String get admin_feedback_cancel_button => 'Cancel';

  @override
  String get admin_feedback_description_label => 'Description:';

  @override
  String get admin_feedback_images_label => 'Images:';

  @override
  String get admin_feedback_list_title => 'User Feedback';

  @override
  String get admin_feedback_type_label => 'Type of feedback:';

  @override
  String get admin_feedback_sender_label => 'Sender:';

  @override
  String get dashboard_recommendations_all_landingpages => 'All';

  @override
  String get dashboard_recommendations_filter_title => 'Filter Recommendations';

  @override
  String get dashboard_recommendations_filter_period => 'Period';

  @override
  String get dashboard_recommendations_filter_status => 'Status';

  @override
  String get dashboard_recommendations_filter_promoter => 'Promoter';

  @override
  String get dashboard_recommendations_filter_landingpage => 'Landing Page';

  @override
  String get dashboard_recommendations_filter_tooltip => 'Open filter';

  @override
  String get dashboard_promoter_ranking_title => 'Promoter Ranking';

  @override
  String get dashboard_promoter_ranking_period => 'Period:';

  @override
  String get dashboard_promoter_ranking_loading_error_title => 'Loading Error';

  @override
  String get dashboard_promoter_ranking_loading_error_message =>
      'The promoter ranking could not be loaded.';

  @override
  String get dashboard_promoter_ranking_no_promoters => 'No promoters found.';

  @override
  String get dashboard_promoter_ranking_no_data =>
      'No promoter data available.';

  @override
  String get dashboard_landingpage_ranking_title => 'Landingpages Ranking';

  @override
  String get dashboard_landingpage_ranking_period => 'Period:';

  @override
  String get dashboard_landingpage_ranking_loading_error_title =>
      'Loading Error';

  @override
  String get dashboard_landingpage_ranking_loading_error_message =>
      'The landing page ranking could not be loaded.';

  @override
  String get dashboard_landingpage_ranking_no_landingpages =>
      'No landing pages found.';

  @override
  String get dashboard_landingpage_ranking_no_data =>
      'No landing page data available.';

  @override
  String get admin_legals_title => 'Legal';

  @override
  String get admin_legals_avv_label => 'Data Processing Agreement';

  @override
  String get admin_legals_avv_placeholder => 'Enter DPA...';

  @override
  String get admin_legals_privacy_policy_label => 'Privacy Policy';

  @override
  String get admin_legals_privacy_policy_placeholder =>
      'Enter Privacy Policy...';

  @override
  String get admin_legals_terms_label => 'Terms and Conditions';

  @override
  String get admin_legals_terms_placeholder => 'Enter Terms and Conditions...';

  @override
  String get admin_legals_imprint_label => 'Imprint';

  @override
  String get admin_legals_imprint_placeholder => 'Enter Imprint...';

  @override
  String get admin_legals_save_button => 'Save';

  @override
  String get admin_legals_save_success => 'Legal data successfully saved!';

  @override
  String get footer_privacy_policy => 'Privacy Policy';

  @override
  String get footer_imprint => 'Imprint';

  @override
  String get footer_terms_and_conditions => 'Terms & Conditions';

  @override
  String get dashboard_quicklink_recommendation_text =>
      'Have you made a recommendation today?';

  @override
  String get dashboard_quicklink_recommendation_button =>
      'Make a recommendation';

  @override
  String get dashboard_quicklink_manager_text =>
      'Have you checked your recommendations today?';

  @override
  String get dashboard_quicklink_manager_button =>
      'Go to Recommendation Manager';

  @override
  String get dashboard_recommendations_info_tooltip =>
      'Here you can see how many recommendations your promoters have sent in the selected time period.';

  @override
  String get dashboard_promoters_info_tooltip =>
      'Here you can see how many promoters you have gained in the selected time period.';

  @override
  String get dashboard_promoter_ranking_info_tooltip =>
      'This analysis shows you which promoters have generated the most successfully completed recommendations in the selected time period.';

  @override
  String get dashboard_landingpage_ranking_info_tooltip =>
      'This analysis shows you which of your landing pages have generated the most completed recommendations in the selected time period.';

  @override
  String get profile_general_tab => 'Personal Data';

  @override
  String get profile_company_tab => 'Company';

  @override
  String get profile_password_tab => 'Change Password';

  @override
  String get profile_delete_tab => 'Delete Account';

  @override
  String get landingpage_creator_contact_option_title =>
      'Select Contact Option';

  @override
  String get landingpage_creator_contact_option_info =>
      'Choose how interested parties can contact you.';

  @override
  String get landingpage_creator_contact_option_calendly => 'Calendly';

  @override
  String get landingpage_creator_contact_option_form => 'Contact Form';

  @override
  String get landingpage_creator_contact_option_both => 'Both';

  @override
  String get landingpage_creator_calendly_connect_button => 'Connect Calendly';

  @override
  String get landingpage_creator_calendly_connecting => 'Connecting...';

  @override
  String get landingpage_creator_calendly_disconnect_button =>
      'Disconnect Calendly';

  @override
  String get landingpage_creator_calendly_connected =>
      'Calendly account successfully connected';

  @override
  String get landingpage_creator_calendly_event_type_select =>
      'Select Calendly Event Type';

  @override
  String get landingpage_creator_calendly_event_type_validation =>
      'Please select an Event Type';

  @override
  String get landingpage_creator_calendly_event_types_loading =>
      'Loading Event Types...';

  @override
  String get landingpage_creator_calendly_event_types_empty =>
      'No Event Types found. Please create Event Types in your Calendly Dashboard.';

  @override
  String get landingpage_creator_calendly_must_be_connected_error =>
      'Calendly must be connected before you can continue.';

  @override
  String get calendly_success_connected => 'Calendly successfully connected!';

  @override
  String get calendly_success_disconnected =>
      'Calendly successfully disconnected';

  @override
  String get calendly_error_connection => 'Error connecting to Calendly';

  @override
  String get pagebuilder_color_tab => 'Color';

  @override
  String get pagebuilder_gradient_tab => 'Gradient';

  @override
  String get pagebuilder_color_select => 'Select Color';

  @override
  String get pagebuilder_gradient_select => 'Select Gradient';

  @override
  String get pagebuilder_gradient_color_select => 'Select Color';

  @override
  String get pagebuilder_gradient_type_label => 'Type: ';

  @override
  String get pagebuilder_gradient_type_linear => 'Linear';

  @override
  String get pagebuilder_gradient_type_radial => 'Radial';

  @override
  String get pagebuilder_gradient_type_sweep => 'Sweep';

  @override
  String get pagebuilder_gradient_colors_label => 'Colors:';

  @override
  String get pagebuilder_gradient_add_color => 'Add Color';

  @override
  String get pagebuilder_ok => 'OK';

  @override
  String get pagebuilder_section_id_placeholder => 'Section name';

  @override
  String get pagebuilder_section_name_error_empty =>
      'Section name cannot be empty';

  @override
  String get pagebuilder_section_name_error_too_long =>
      'Section name cannot exceed 50 characters';

  @override
  String get pagebuilder_section_name_error_duplicate =>
      'Section ID already exists';

  @override
  String get pagebuilder_section_visible_on_title => 'Visible on';

  @override
  String get pagebuilder_section_visible_on_desktop => 'Desktop';

  @override
  String get pagebuilder_section_visible_on_tablet => 'Tablet';

  @override
  String get pagebuilder_section_visible_on_mobile => 'Mobile';

  @override
  String get pagebuilder_undo_tooltip => 'Undo';

  @override
  String get pagebuilder_redo_tooltip => 'Redo';

  @override
  String get pagebuilder_page_menu_title => 'Elements';

  @override
  String get pagebuilder_widget_template_text => 'Text';

  @override
  String get pagebuilder_widget_template_image => 'Image';

  @override
  String get pagebuilder_widget_template_container => 'Container';

  @override
  String get pagebuilder_widget_template_icon => 'Icon';

  @override
  String get pagebuilder_widget_template_video => 'Video';

  @override
  String get pagebuilder_widget_template_contact_form => 'Contact Form';

  @override
  String get pagebuilder_widget_template_anchor_button => 'Anchor Button';

  @override
  String get pagebuilder_widget_template_calendly => 'Calendly';

  @override
  String get pagebuilder_widget_template_spacer => 'Height';

  @override
  String get pagebuilder_html_text_editor_select_color => 'Select Color';

  @override
  String get pagebuilder_html_text_editor_hint => 'Enter text...';

  @override
  String get pagebuilder_html_text_editor_background_color =>
      'Editor Background Color';

  @override
  String get pagebuilder_widget_controls_edit => 'Edit';

  @override
  String get pagebuilder_widget_controls_delete => 'Delete';

  @override
  String get pagebuilder_widget_controls_duplicate => 'Duplicate';

  @override
  String get pagebuilder_section_controls_duplicate => 'Duplicate';

  @override
  String get pagebuilder_section_controls_delete => 'Delete';

  @override
  String get pagebuilder_section_controls_edit_tooltip => 'Edit';

  @override
  String get pagebuilder_section_controls_drag_tooltip => 'Move';

  @override
  String get pagebuilder_widget_controls_edit_tooltip => 'Edit';

  @override
  String get pagebuilder_widget_controls_drag_tooltip => 'Move';

  @override
  String get pagebuilder_config_menu_open_tooltip => 'Open menu';

  @override
  String get pagebuilder_config_menu_close_tooltip => 'Close menu';

  @override
  String get pagebuilder_responsive_preview_close_tooltip => 'Normal mode';

  @override
  String get pagebuilder_hierarchy_close_tooltip => 'Hide page hierarchy';

  @override
  String get pagebuilder_global_colors_palette_title => 'Global Colors';

  @override
  String get pagebuilder_global_colors_palette_primary => 'Primary';

  @override
  String get pagebuilder_global_colors_palette_secondary => 'Secondary';

  @override
  String get pagebuilder_global_colors_palette_tertiary => 'Tertiary';

  @override
  String get pagebuilder_global_colors_palette_background => 'Background';

  @override
  String get pagebuilder_global_colors_palette_surface => 'Surface';

  @override
  String get pagebuilder_font_family_control_global_heading => 'Global';

  @override
  String get pagebuilder_font_family_control_other_heading => 'Other';

  @override
  String get pagebuilder_font_family_control_headline_font => 'Headline';

  @override
  String get pagebuilder_font_family_control_text_font => 'Body Text';

  @override
  String get pagebuilder_global_styles_fonts_title => 'Global Fonts';

  @override
  String get admin_area_template_manager_title => 'Template Manager';

  @override
  String get admin_area_template_manager_description =>
      'Upload section templates for the pagebuilder';

  @override
  String get admin_area_template_manager_upload_heading =>
      'Upload Section Template';

  @override
  String get admin_area_template_manager_section_json_label => 'Section JSON';

  @override
  String get admin_area_template_manager_thumbnail_label => 'Thumbnail';

  @override
  String get admin_area_template_manager_file_picker_hint => 'Choose file...';

  @override
  String get admin_area_template_manager_asset_images_label => 'Asset Images';

  @override
  String get admin_area_template_manager_add_images_button => 'Add Images';

  @override
  String get admin_area_template_manager_no_assets_selected =>
      'No assets selected';

  @override
  String get admin_area_template_manager_section_type_label => 'Section Type';

  @override
  String get admin_area_template_manager_type_hint => 'Choose type...';

  @override
  String get admin_area_template_manager_type_hero => 'Hero';

  @override
  String get admin_area_template_manager_type_product => 'Product';

  @override
  String get admin_area_template_manager_type_about => 'About';

  @override
  String get admin_area_template_manager_type_call_to_action =>
      'Call To Action';

  @override
  String get admin_area_template_manager_type_advantages => 'Advantages';

  @override
  String get admin_area_template_manager_type_footer => 'Footer';

  @override
  String get admin_area_template_manager_type_contact_form => 'Contact Form';

  @override
  String get admin_area_template_manager_type_calendly => 'Calendly';

  @override
  String get admin_area_template_manager_environment_label => 'Environment';

  @override
  String get admin_area_template_manager_environment_both =>
      'Staging & Production';

  @override
  String get admin_area_template_manager_environment_staging => 'Staging only';

  @override
  String get admin_area_template_manager_environment_prod => 'Production only';

  @override
  String get admin_area_template_manager_upload_button => 'Upload Template';

  @override
  String get admin_area_template_manager_error_missing_files =>
      'Please select at least JSON and Thumbnail';

  @override
  String get admin_area_template_manager_error_missing_type =>
      'Please select a type';

  @override
  String get admin_area_template_manager_error_reading_files =>
      'Error reading files';

  @override
  String get admin_area_template_manager_success_message =>
      'Template uploaded successfully!';

  @override
  String get admin_area_template_manager_tab_create => 'Create template';

  @override
  String get admin_area_template_manager_tab_edit => 'Edit templates';

  @override
  String get admin_area_template_manager_edit_dialog_title => 'Edit template';

  @override
  String get admin_area_template_manager_edit_success =>
      'Template updated successfully!';

  @override
  String get admin_area_template_manager_edit_button => 'Update template';

  @override
  String get admin_area_template_manager_edit_loading => 'Loading templates...';

  @override
  String get admin_area_template_manager_edit_no_templates =>
      'No templates available';

  @override
  String get admin_area_template_manager_json_format_tooltip => 'Format JSON';

  @override
  String get admin_area_template_manager_json_upload_tooltip =>
      'Upload JSON file';

  @override
  String get admin_area_template_manager_json_invalid => 'Invalid JSON format';

  @override
  String get admin_area_template_manager_new_assets_label => 'New Assets';

  @override
  String get menuitems_templates => 'Templates';

  @override
  String get pagebuilder_add_section_create_empty_tooltip =>
      'Create empty section';

  @override
  String get pagebuilder_add_section_create_from_template_tooltip =>
      'Create from template';

  @override
  String get pagebuilder_add_section_choose_layout_heading =>
      'Choose your layout';

  @override
  String get pagebuilder_section_type_hero => 'Hero';

  @override
  String get pagebuilder_section_type_about => 'About';

  @override
  String get pagebuilder_section_type_product => 'Product';

  @override
  String get pagebuilder_section_type_call_to_action => 'Call to Action';

  @override
  String get pagebuilder_section_type_advantages => 'Advantages';

  @override
  String get pagebuilder_section_type_footer => 'Footer';

  @override
  String get pagebuilder_section_type_contact_form => 'Contact Form';

  @override
  String get pagebuilder_section_type_calendly => 'Calendly';

  @override
  String get pagebuilder_template_library_error_loading_template =>
      'Error loading template';

  @override
  String get pagebuilder_template_library_heading => 'Template Selection';

  @override
  String get pagebuilder_template_library_error_loading_templates =>
      'Error loading templates';

  @override
  String pagebuilder_template_library_no_templates_available(String type) {
    return 'No templates available for $type';
  }

  @override
  String get cookie_consent_banner_title => 'We respect your Privacy';

  @override
  String get cookie_consent_banner_description =>
      'We use cookies and similar technologies to provide and improve our website. Some are necessary for functionality, others help us analyze errors and optimize the website.';

  @override
  String get cookie_consent_banner_accept_all => 'Accept all';

  @override
  String get cookie_consent_banner_reject_all => 'Only necessary';

  @override
  String get cookie_consent_banner_customize => 'Customize';

  @override
  String get cookie_consent_settings_title => 'Cookie Settings';

  @override
  String get cookie_consent_settings_description =>
      'Here you can customize your cookie preferences. Necessary cookies are always active and cannot be disabled.';

  @override
  String get cookie_consent_settings_save => 'Save settings';

  @override
  String get cookie_consent_settings_cancel => 'Cancel';

  @override
  String get cookie_consent_category_necessary_title => 'Necessary';

  @override
  String get cookie_consent_category_necessary_description =>
      'These cookies are required for the basic functions of the website, such as login, data storage and security. They cannot be disabled.';

  @override
  String get cookie_consent_category_necessary_services =>
      'Firebase Authentication, Firestore, Cloud Functions, Storage, AppCheck';

  @override
  String get cookie_consent_category_statistics_title => 'Statistics';

  @override
  String get cookie_consent_category_statistics_description =>
      'These cookies help us identify errors and improve the website. Technical error information is collected.';

  @override
  String get cookie_consent_category_statistics_services =>
      'Sentry error tracking';

  @override
  String get cookie_consent_settings_button => 'Cookie Settings';

  @override
  String get cookie_consent_save_success =>
      'Your cookie settings have been saved';

  @override
  String get cookie_consent_save_error => 'Error saving cookie settings';

  @override
  String get cookie_consent_always_active => 'Always active';

  @override
  String get cookie_consent_privacy_policy => 'Privacy Policy';
}
