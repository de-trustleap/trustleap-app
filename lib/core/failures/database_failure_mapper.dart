import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class DatabaseFailureMapper {
  static String mapFailureMessage(
      DatabaseFailure failure, AppLocalizations localizations) {
    switch (failure.runtimeType) {
      case == PermissionDeniedFailure:
        return localizations.database_failure_permission_denied;
      case == NotFoundFailure:
        return localizations.database_failure_not_found;
      case == AlreadyExistsFailure:
        return localizations.database_failure_already_exists;
      case == DeadlineExceededFailure:
        return localizations.database_failure_deadline_exceeded;
      case == CancelledFailure:
        return localizations.database_failure_cancelled;
      case == UnavailableFailure:
        return localizations.database_failure_unavailable;
      default:
        return localizations.database_failure_unknown;
    }
  }
}
