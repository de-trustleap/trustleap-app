import 'package:finanzbegleiter/core/failures/auth_failures.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/failures/storage_failures.dart';

class FirebaseExceptionParser {
  static String parseFirebaseAuthExceptionMessage(
      {String plugin = "auth", required String? input}) {
    if (input == null) {
      return "unknown";
    }

    // https://regexr.com/7en3h
    String regexPattern = r'(?<=\(' + plugin + r'/)(.*?)(?=\)\.)';
    RegExp regExp = RegExp(regexPattern);
    Match? match = regExp.firstMatch(input);
    if (match != null) {
      return match.group(0)!;
    }

    return "unknown";
  }

  static AuthFailure getAuthException({required String? input}) {
    final String code =
        FirebaseExceptionParser.parseFirebaseAuthExceptionMessage(input: input);
    if (code == "user-disabled") {
      return UserDisabledFailure();
    } else if (code == "invalid-email") {
      return InvalidEmailFailure();
    } else if (code == "user-not-found") {
      return UserNotFoundFailure();
    } else if (code == "wrong-password") {
      return WrongPasswordFailure();
    } else if (code == "invalid-credential") {
      return InvalidCredentialsFailure();
    } else if (code == "too-many-requests") {
      return TooManyRequestsFailure();
    } else if (code == "email-already-in-use") {
      return EmailAlreadyInUseFailure();
    } else if (code == "weak-password") {
      return WeakPasswordFailure();
    } else if (code == "user-mismatch") {
      return UserMisMatchFailure();
    } else if (code == "invalid-verification-code") {
      return InvalidVerificationCodeFailure();
    } else if (code == "invalid-verification-id") {
      return InvalidVerificationIdFailure();
    } else if (code == "requires-recent-login") {
      return RequiresRecentLoginFailure();
    } else if (code == "missing-password") {
      return MissingPasswordFailure();
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
