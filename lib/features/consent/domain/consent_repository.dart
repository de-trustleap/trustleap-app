import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/consent/domain/consent_preference.dart';

abstract class ConsentRepository {
  bool hasConsentDecision();
  ConsentPreference getConsentPreferences();
  Future<Either<DatabaseFailure, Unit>> saveConsentPreference(
    ConsentPreference preference,
  );
  bool hasConsent(ConsentCategory category);
  Future<Either<DatabaseFailure, Unit>> revokeConsent(String policyVersion);
  bool isConsentOutdated(String currentPolicyVersion);
}
