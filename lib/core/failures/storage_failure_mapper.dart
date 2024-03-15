import 'package:finanzbegleiter/core/failures/storage_failures.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class StorageFailureMapper {
  static String mapFailureMessage(
      StorageFailure failure, AppLocalizations localization) {
    switch (failure.runtimeType) {
      case == ObjectNotFound:
        return localization.storage_failure_object_not_found;
      case == NotAuthenticated:
        return localization.storage_failure_not_authenticated;
      case == UnAuthorized:
        return localization.storage_failure_not_authorized;
      case == RetryLimitExceeded:
        return localization.storage_failure_retry_limit_exceeded;
      default:
        return localization.storage_failure_unknown;
    }
  }
}
