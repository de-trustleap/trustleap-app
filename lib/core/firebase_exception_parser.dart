import 'package:finanzbegleiter/core/failures/auth_failures.dart';

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

  static AuthFailure getAuthException(
      {String plugin = "auth", required String? input}) {
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
      return InvalidVerificationCode();
    } else if (code == "invalid-verification-id") {
      return InvalidVerificationId();
    } else if (code == "requires-recent-login") {
      return RequiresRecentLogin();
    } else {
      return ServerFailure();
    }
  }
}
