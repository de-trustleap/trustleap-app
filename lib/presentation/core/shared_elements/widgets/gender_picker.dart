// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finanzbegleiter/constants.dart';
import 'package:flutter/material.dart';

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
              label: Text("Wählen Sie ihr Geschlecht",
                  style: Theme.of(context).textTheme.headlineLarge),
              initialSelection: initialValue ?? Gender.none,
              enableSearch: false,
              requestFocusOnTap: false,
              dropdownMenuEntries: const [
                DropdownMenuEntry(
                    value: Gender.none, label: "Nicht ausgewählt"),
                DropdownMenuEntry(value: Gender.male, label: "Männlich"),
                DropdownMenuEntry(value: Gender.female, label: "Weiblich")
              ],
              onSelected: (gender) {
                onSelected(gender);
              }),
        ),
      );
    });
  }
}
