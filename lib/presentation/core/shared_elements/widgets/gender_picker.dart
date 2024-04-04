// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class GenderPicker extends StatelessWidget {
  final double width;
  final String? validate;
  final Gender? initialValue;
  final Function onSelected;

  const GenderPicker({
    Key? key,
    required this.width,
    required this.validate,
    this.initialValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);

    return FormField(builder: (FormFieldState<Gender> state) {
      return SizedBox(
        width: width,
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorText: validate,
          ),
          child: DropdownMenu<Gender>(
              width: width,
              label: Text(localization.gender_picker_choose,
                  style: responsiveValue.isMobile ? themeData.textTheme.bodySmall : themeData.textTheme.bodyMedium),
              initialSelection: initialValue ?? Gender.none,
              enableSearch: false,
              requestFocusOnTap: false,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                    value: Gender.none,
                    label: localization.gender_picker_not_choosen),
                DropdownMenuEntry(
                    value: Gender.male, label: localization.gender_picker_male),
                DropdownMenuEntry(
                    value: Gender.female,
                    label: localization.gender_picker_female)
              ],
              onSelected: (gender) {
                onSelected(gender);
              }),
        ),
      );
    });
  }
}
