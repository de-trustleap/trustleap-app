import 'package:finanzbegleiter/core/failures/auth_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failure_mapper.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/failure.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class FailureMapper {
  static String mapFailureMessage(
      Failure failure, AppLocalizations localizations) {
    if (failure is AuthFailure) {
      return AuthFailureMapper.mapFailureMessage(failure, localizations);
    } else if (failure is DatabaseFailure) {
      return DatabaseFailureMapper.mapFailureMessage(failure, localizations);
    } else {
      return "";
    }
  }
}
