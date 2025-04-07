import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';

class FirebaseExceptionParser {
  static AuthFailure getAuthException({required String? code}) {
    final trimmedCode = code?.replaceAll("auth/", "");
    if (trimmedCode == "user-disabled") {
      return UserDisabledFailure();
    } else if (trimmedCode == "invalid-email") {
      return InvalidEmailFailure();
    } else if (trimmedCode == "user-not-found") {
      return UserNotFoundFailure();
    } else if (trimmedCode == "wrong-password") {
      return WrongPasswordFailure();
    } else if (trimmedCode == "invalid-credential") {
      return InvalidCredentialsFailure();
    } else if (trimmedCode == "too-many-requests") {
      return TooManyRequestsFailure();
    } else if (trimmedCode == "email-already-in-use") {
      return EmailAlreadyInUseFailure();
    } else if (trimmedCode == "weak-password") {
      return WeakPasswordFailure();
    } else if (trimmedCode == "user-mismatch") {
      return UserMisMatchFailure();
    } else if (trimmedCode == "invalid-verification-code") {
      return InvalidVerificationCodeFailure();
    } else if (trimmedCode == "invalid-verification-id") {
      return InvalidVerificationIdFailure();
    } else if (trimmedCode == "requires-recent-login") {
      return RequiresRecentLoginFailure();
    } else if (trimmedCode == "missing-password") {
      return MissingPasswordFailure();
    } else if (trimmedCode == "invalid-password") {
      return InvalidPasswordFailure();
    } else {
      return ServerFailure();
    }
  }

  static DatabaseFailure getDatabaseException({required String code}) {
    if (code.contains("permission-denied") ||
        code.contains("PERMISSION_DENIED")) {
      return PermissionDeniedFailure();
    } else if (code.contains("already-exists") ||
        code.contains("ALREADY_EXISTS")) {
      return AlreadyExistsFailure();
    } else if (code.contains("deadline-exceeded") ||
        code.contains("DEADLINE_EXCEEDED")) {
      return DeadlineExceededFailure();
    } else if (code.contains("cancelled") || code.contains("CANCELLED")) {
      return CancelledFailure();
    } else if (code.contains("unavailable") || code.contains("UNAVAILABLE")) {
      return UnavailableFailure();
    } else {
      return BackendFailure();
    }
  }

  static StorageFailure getStorageException({required String code}) {
    if (code.contains("object-not-found") ||
        code.contains("OBJECT_NOT_FOUND")) {
      return ObjectNotFound();
    } else if (code.contains("unauthenticated") ||
        code.contains("UNAUTHENTICATED")) {
      return NotAuthenticated();
    } else if (code.contains("unauthorized") || code.contains("UNAUTHORIZED")) {
      return UnAuthorized();
    } else if (code.contains("retry-limit-exceeded") ||
        code.contains("RETRY_LIMIT_EXCEEDED")) {
      return RetryLimitExceeded();
    } else {
      return UnknownFailure();
    }
  }
}
