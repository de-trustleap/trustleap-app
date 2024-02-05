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
}
