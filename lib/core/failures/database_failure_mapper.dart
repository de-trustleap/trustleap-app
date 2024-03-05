import 'package:finanzbegleiter/core/failures/database_failures.dart';

class DatabaseFailureMapper {
  static String mapFailureMessage(DatabaseFailure failure) {
    switch (failure.runtimeType) {
      case == PermissionDeniedFailure:
        return "Sie sind nicht berechtigt auf die Daten zuzugreifen.";
      case == NotFoundFailure:
        return "Die angefragten Daten wurden nicht gefunden.";
      case == AlreadyExistsFailure:
        return "Die angegebenen Daten existieren bereits.";
      case == DeadlineExceededFailure:
        return "Der Datenabruf dauert zu lange. Versuche es später nochmal.";
      case == CancelledFailure:
        return "Die Operation wurde abgebrochen.";
      case == UnavailableFailure:
        return "Der Service ist gerade nicht erreichbar.";
      default:
        return "Ein unbekannter Fehler ist aufgetreten.";
    }
  }
}
