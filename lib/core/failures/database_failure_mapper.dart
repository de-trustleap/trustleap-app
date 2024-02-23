import 'package:finanzbegleiter/core/failures/database_failures.dart';

class DatabaseFailureMapper {
  static String mapFailureMessage(DatabaseFailure failure) {
    switch (failure.runtimeType) {
      case == PermissionDeniedFailure:
        return "Sie sind nicht berechtigt auf die Daten zuzugreifen.";
      case == NotFoundFailure:
        return "Die angefragten Daten wurden nicht gefunden.";
      default:
        return "Ein unbekannter Fehler ist aufgetreten.";
    }
  }
}
