// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/custom_dropdown.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class GenderPicker extends StatelessWidget {
  final double width;
  final String? validate;
  final Gender? initialValue;
  final Function onSelected;

  const GenderPicker({
    super.key,
    required this.width,
    required this.validate,
    this.initialValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

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
          child: CustomDropdown<Gender>(
            width: width,
            label: localization.gender_picker_choose,
            value: initialValue ?? Gender.none,
            type: CustomDropdownType.standard,
            items: [
              CustomDropdownItem(
                  value: Gender.none,
                  label: localization.gender_picker_not_choosen),
              CustomDropdownItem(
                  value: Gender.male, label: localization.gender_picker_male),
              CustomDropdownItem(
                  value: Gender.female,
                  label: localization.gender_picker_female),
            ],
            onChanged: (gender) => onSelected(gender),
          ),
        ),
      );
    });
  }
}
