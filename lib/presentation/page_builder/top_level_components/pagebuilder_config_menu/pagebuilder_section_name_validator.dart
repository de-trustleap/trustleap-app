import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class PagebuilderSectionNameValidator {
  static const int maxLength = 50;

  static String? validate(
    String? value,
    AppLocalizations localizations, {
    List<String>? existingSectionNames,
    String? currentSectionName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return localizations.pagebuilder_section_name_error_empty;
    }
    if (value.length > maxLength) {
      return localizations.pagebuilder_section_name_error_too_long;
    }
    if (existingSectionNames != null &&
        value.trim() != currentSectionName &&
        existingSectionNames.contains(value.trim())) {
      return localizations.pagebuilder_section_name_error_duplicate;
    }

    return null;
  }
}
