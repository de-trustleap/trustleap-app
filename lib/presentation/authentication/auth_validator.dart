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

  String? validateBirthDate(String? input) {
    if (input == null || input.isEmpty) {
      return "Bitte das Geburtsdatum angeben";
    } else if (!_isAdult(DateTime.parse(_prepareDateStringForParser(input)))) {
      return "Sie müssen 18 oder älter sein";
    } else {
      return null;
    }
  }

  bool _isAdult(DateTime date) {
    final DateTime today = DateTime.now();
    final DateTime adultDate = DateTime(
      date.year + 18,
      date.month,
      date.day,
    );
    return adultDate.isBefore(today);
  }

  String _prepareDateStringForParser(String input) {
    final splitted = input.split(".").reversed;
    return splitted.join("");
  }
}
