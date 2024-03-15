import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class AuthFailureMapper {
  static String mapFailureMessage(
      AuthFailure failure, AppLocalizations localization) {
    switch (failure.runtimeType) {
      case == EmailAlreadyInUseFailure:
        return localization.auth_failure_email_already_in_use;
      case == InvalidEmailFailure:
        return localization.auth_failure_invalid_email;
      case == WeakPasswordFailure:
        return localization.auth_failure_weak_password;
      case == UserDisabledFailure:
        return localization.auth_failure_user_disabled;
      case == UserNotFoundFailure:
        return localization.auth_failure_user_not_found;
      case == WrongPasswordFailure:
        return localization.auth_failure_wrong_password;
      case == InvalidCredentialsFailure:
        return localization.auth_failure_invalid_credentials;
      case == TooManyRequestsFailure:
        return localization.auth_failure_too_many_requests;
      case == UserMisMatchFailure:
        return localization.auth_failure_user_mismatch;
      case == InvalidVerificationCodeFailure:
        return localization.auth_failure_invalid_verification_code;
      case == InvalidVerificationIdFailure:
        return localization.auth_failure_invalid_verification_id;
      case == RequiresRecentLoginFailure:
        return localization.auth_failure_requires_recent_login;
      case == MissingPasswordFailure:
        return localization.auth_failure_missing_password;
      default:
        return localization.auth_failure_unknown;
    }
  }
}
