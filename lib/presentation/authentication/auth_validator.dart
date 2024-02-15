class AuthValidator {
  String? validateEmail(String? input) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

    if (input == null || input.isEmpty) {
      return "Please enter email";
    } else if (RegExp(emailRegex).hasMatch(input)) {
      return null;
    } else {
      return "Ungültige E-Mail Adresse";
    }
  }

  String? validatePassword(String? input) {
    if (input == null || input.isEmpty) {
      return "Bitte ein Password angeben";
    } else {
      return null;
    }
  }

  String? validatePasswordRepeat(String? input, String? otherPassword) {
    if (input == null || input.isEmpty) {
      return "Bitte das Passwort bestätigen";
    } else if (otherPassword != input) {
      return "Die Passwörter stimmen nicht überein";
    } else {
      return null;
    }
  }

  String? validateFirstName(String? input) {
    if (input == null || input.isEmpty) {
      return "Bitte den Vornamen angeben";
    } else if (input.length > 60) {
      return "Der angegebene Vorname ist zu lang";
    } else {
      return null;
    }
  }

  String? validateLastName(String? input) {
    if (input == null || input.isEmpty) {
      return "Bitte den Nachnamen angeben";
    } else if (input.length > 60) {
      return "Der angegebene Nachname ist zu lang";
    } else {
      return null;
    }
  }
}
