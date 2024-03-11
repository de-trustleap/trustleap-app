import 'package:finanzbegleiter/core/failures/storage_failures.dart';

class StorageFailureMapper {
  static String mapFailureMessage(StorageFailure failure) {
    switch (failure.runtimeType) {
      case == ObjectNotFound:
        return "Es wurde kein Bild gefunden.";
      case == NotAuthenticated:
        return "Du musst dich anmelden um diesen Service nutzen zu können.";
      case == UnAuthorized:
        return "Du bist nicht berechtigt diese Aktion auszuführen.";
      case == RetryLimitExceeded:
        return "Es scheint ein Problem aufgetreten zu sein. Die Aktion dauert länger als gewöhnlich. Bitte versuche es später erneut.";
      default:
        return "Ein unbekannter Fehler ist aufgetreten. Bitte versuche es später erneut.";
    }
  }
}
