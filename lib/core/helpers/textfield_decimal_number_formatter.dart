import 'package:flutter/services.dart';

class DecimalNumberFormatter extends TextInputFormatter {
  final int maxIntegerDigits;
  final int maxDecimalDigits;

  DecimalNumberFormatter({this.maxIntegerDigits = 3, this.maxDecimalDigits = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    final sanitizedText = text.replaceAll(',', '.');

    final regExp = RegExp(
      r'^\d{0,' +
          maxIntegerDigits.toString() +
          r'}(\.\d{0,' +
          maxDecimalDigits.toString() +
          r'})?$',
    );

    if (regExp.hasMatch(sanitizedText)) {
      return newValue.copyWith(
        text: sanitizedText,
        selection: newValue.selection,
      );
    } else {
      return oldValue;
    }
  }
}