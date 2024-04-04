import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static final _shared = DateTimeFormatter._internal();

  final String dateFormat = "dd.MM.yyyy";

  factory DateTimeFormatter() {
    return _shared;
  }

  DateTimeFormatter._internal();

  String getStringFromDate(BuildContext context, DateTime date) {
    Locale myLocale = Localizations.localeOf(context);
    return DateFormat(dateFormat, myLocale.languageCode).format(date);
  }

  bool stringIsValidDate(String input) {
    DateFormat format = DateFormat(dateFormat);
    try {
      format.parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool dateIsParsable(String input) {
    try {
      DateTime.parse(prepareDateStringForParser(input));
      return true;
    } catch (e) {
      return false;
    }
  }

  String prepareDateStringForParser(String input) {
    final splitted = input.split(".").reversed;
    return splitted.join("");
  }
}
