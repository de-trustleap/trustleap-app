import 'package:finanzbegleiter/core/failures/auth_failures.dart';

class AuthFailureMapper {
  static String mapFailureMessage(AuthFailure failure) {
    switch (failure.runtimeType) {
      case == EmailAlreadyInUseFailure:
        return "Die E-Mail Adresse ist bereits vergeben.";
      case == InvalidEmailFailure:
        return "Die eingegebene E-Mail Adresse ist ungültig.";
      case == WeakPasswordFailure:
        return "Das angegebene Passwort ist zu schwach. Bitte nutze mindestens 6 Zeichen.";
      case == UserDisabledFailure:
        return "Der angegebene Nutzername ist gesperrt.";
      case == UserNotFoundFailure:
        return "Der angegebene Nutzername existiert nicht.";
      case == WrongPasswordFailure:
        return "Das angegebene Passwort ist falsch.";
      case == InvalidCredentialsFailure:
        return "Deine Zugangsdaten existieren nicht.";
      case == TooManyRequestsFailure:
        return "Du hast deine Zugangsdaten zu oft falsch eingegeben. Versuche es später noch einmal.";
      case == UserMisMatchFailure:
        return "Deine Anmeldeinformationen gehören nicht zum aktuellen User.";
      case == InvalidVerificationCode:
        return "Dein Verifizierungscode ist ungültig.";
      case == InvalidVerificationId:
        return "Die ID zu deinen Anmeldeinformationen ist ungültig.";
      case == RequiresRecentLogin:
        return "Deine letzte Anmeldung ist zu lange her. Melde dich erneut an.";
      case == ServerFailure:
        return "Ein unbekannter Fehler ist aufgetreten.";
      default:
        return "Ein unbekannter Fehler ist aufgetreten.";
    }
  }
}
